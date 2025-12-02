<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use App\Models\Persona;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{
    /**
     * 📌 REGISTRO DE USUARIO
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nombres'          => 'required|string|max:100',
            'apellido_paterno' => 'required|string|max:100',
            'email'            => 'required|email|unique:usuarios,email',
            'password'         => 'required|string|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        DB::beginTransaction();
        try {
            // 1. Crear Persona
            $persona = Persona::create([
                'nombres'          => $request->nombres,
                'apellido_paterno' => $request->apellido_paterno,
                'apellido_materno' => $request->apellido_materno,
                'telefono'         => $request->telefono,
                'fecha_nacimiento' => $request->fecha_nacimiento,
            ]);

            // 2. Generar username
            $primerNombre    = Str::ascii(explode(' ', trim($request->nombres))[0] ?? '');
            $apellidoPaterno = Str::ascii(trim($request->apellido_paterno ?? ''));
            $nameGenerado    = strtolower(substr($primerNombre, 0, 2) . substr($apellidoPaterno, 0, 2)) . rand(100, 999);

            // 3. Crear Usuario
            $usuario = Usuario::create([
                'id_rol'             => 4, // Rol usuario
                'id_persona'         => $persona->id,
                'name'               => $nameGenerado,
                'email'              => $request->email,
                'password'           => Hash::make($request->password),
                'descripcion_perfil' => null,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Usuario registrado correctamente',
                'usuario' => $usuario->load('persona', 'rol'),
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * 🔑 LOGIN
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $usuario = Usuario::where('email', $request->email)->first();

        if (!$usuario || !Hash::check($request->password, $usuario->password)) {
            return response()->json(['message' => 'Credenciales incorrectas'], 401);
        }

        $token = $usuario->createToken('mobile')->plainTextToken;

        return response()->json([
            'message' => 'Inicio de sesión exitoso',
            'usuario' => $usuario->load('persona', 'rol'),
            'token'   => $token
        ], 200);
    }

    /**
     * ✏️ ACTUALIZAR PERFIL (Compatible con Chef y Usuario normal)
     */
    public function actualizarPerfil(Request $request)
    {
        // 1. Obtener usuario (Soporte para Token o ID directo para pruebas)
        $user = $request->user();
        if (!$user && $request->has('id')) {
            $user = Usuario::find($request->id);
        }

        if (!$user) {
            return response()->json(['message' => 'No autenticado'], 401);
        }

        // 2. Validación Flexible (Campos "nullable" para que no falle si faltan)
        $validator = Validator::make($request->all(), [
            'nombre'             => 'nullable|string|max:100', // Desde Flutter Chef
            'name'               => 'nullable|string|max:100', // Desde Flutter Usuario
            'email'              => 'nullable|email|unique:usuarios,email,'.$user->id,
            'telefono'           => 'nullable|string|max:20',
            'biografia'          => 'nullable|string',
            'descripcion_perfil' => 'nullable|string',
            'altura'             => 'nullable|numeric',
            'peso'               => 'nullable|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        DB::beginTransaction();
        try {
            // 3. Actualizar datos de USUARIO
            $updateData = [];
            
            // Mapeo: Si llega 'nombre' (Chef) o 'name' (User), actualizamos 'name'
            if ($request->has('nombre')) $updateData['name'] = $request->nombre;
            if ($request->has('name'))   $updateData['name'] = $request->name;
            
            if ($request->has('email'))  $updateData['email'] = $request->email;
            
            // Mapeo: 'biografia' (Chef) o 'descripcion_perfil' (User)
            if ($request->has('biografia')) {
                $bio = $request->biografia;
                if ($request->has('especialidad')) {
                    $bio .= " | " . $request->especialidad;
                }
                $updateData['descripcion_perfil'] = $bio;
            } elseif ($request->has('descripcion_perfil')) {
                $updateData['descripcion_perfil'] = $request->descripcion_perfil;
            }

            if (!empty($updateData)) {
                $user->update($updateData);
            }

            // 4. Actualizar datos de PERSONA
            if ($user->id_persona) {
                $persona = Persona::find($user->id_persona);
                if ($persona) {
                    $personaUpdate = [];
                    
                    if ($request->has('telefono')) $personaUpdate['telefono'] = $request->telefono;
                    if ($request->has('altura'))   $personaUpdate['altura'] = floatval($request->altura);
                    if ($request->has('peso'))     $personaUpdate['peso'] = floatval($request->peso);
                    
                    // Actualizar nombre real en tabla persona si viene del Chef
                    if ($request->has('nombre')) {
                        $personaUpdate['nombres'] = $request->nombre; 
                    }

                    // Manejo de Imagen (Base64)
                    if ($request->has('imagen') && !empty($request->imagen)) {
                        try {
                            // Limpiar encabezados base64 si existen (data:image/png;base64,...)
                            $imagenData = $request->imagen;
                            if (strpos($imagenData, ',') !== false) {
                                $imagenData = explode(',', $imagenData)[1];
                            }
                            $bin = base64_decode($imagenData);
                            // Usar DB::raw o sintaxis compatible con tu driver de BYTEA
                            // Para Laravel con Postgres estándar, a veces basta pasar el binario si el modelo lo casta
                            // O usar pg_escape_bytea si usas query builder puro.
                            // Aquí usaremos una asignación directa asumiendo configuración estándar de Laravel/PDO
                            $persona->imagen = $bin; 
                            $persona->save(); // Save separado para la imagen
                        } catch (\Exception $e) {
                            // Ignorar error de imagen para no romper el resto
                        }
                    }

                    if (!empty($personaUpdate)) {
                        $persona->update($personaUpdate);
                    }
                }
            }

            DB::commit();

            return response()->json([
                "success" => true,
                "message" => "Perfil actualizado correctamente",
                "usuario" => $user->load('persona')
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['success' => false, 'error' => $e->getMessage()], 500);
        }
    }
}