<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use App\Models\Persona;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    /**
     * 📌 REGISTRO DE USUARIO
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            // Datos de persona
            'nombres'           => 'required|string|max:100',
            'apellido_paterno'  => 'required|string|max:100',
            'apellido_materno'  => 'nullable|string|max:100',
            'telefono'          => 'nullable|string|max:20',
            'fecha_nacimiento'  => 'nullable|date',

            // Datos de usuario
            'email'             => 'required|email|unique:usuarios,email',
            'password'          => 'required|string|min:6|confirmed', // confirmar con 'password_confirmation'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // 🧍 Crear registro en tabla PERSONAS
        $persona = Persona::create([
            'nombres'            => $request->nombres,
            'apellido_paterno'   => $request->apellido_paterno,
            'apellido_materno'   => $request->apellido_materno,
            'telefono'           => $request->telefono,
            'fecha_nacimiento'   => $request->fecha_nacimiento,
        ]);

        // 📛 Generar automáticamente username (name)
        $primerNombre    = Str::ascii(explode(' ', trim($request->nombres))[0] ?? '');
        $apellidoPaterno = Str::ascii(trim($request->apellido_paterno ?? ''));
        $nameGenerado    = strtolower(substr($primerNombre, 0, 2) . substr($apellidoPaterno, 0, 2));

        // 👤 Crear registro en tabla USUARIOS
        $usuario = Usuario::create([
            'id_rol'            => 2, // Rol por defecto: usuario
            'id_persona'        => $persona->id,
            'name'              => $nameGenerado,
            'email'             => $request->email,
            'password'          => Hash::make($request->password),
            'descripcion_perfil'=> null,
        ]);

        return response()->json([
            'message' => 'Usuario registrado correctamente',
            'usuario' => $usuario->load('persona', 'rol'),
        ], 201);
    }

    /**
     * 🔑 LOGIN DE USUARIO + SANCTUM TOKEN
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

    $usuario->load('persona', 'rol');
    
    // 🔥 CONVERTIR IMAGEN SI EXISTE
    $imgBase64 = null;
    if ($usuario->persona && $usuario->persona->imagen) {
        $imgBytes = $usuario->persona->imagen;
        if (is_resource($imgBytes)) {
            $imgBytes = stream_get_contents($imgBytes);
        }
        if (!empty($imgBytes)) {
            $imgBase64 = base64_encode($imgBytes);
        }
    }

    $usuarioData = $usuario->toArray();
    
    // 🔥 FORZAR ALTURA Y PESO COMO STRING
    if (isset($usuarioData['persona'])) {
        $usuarioData['persona']['altura'] = isset($usuarioData['persona']['altura'])
    ? (string) $usuarioData['persona']['altura']
    : null;

$usuarioData['persona']['peso'] = isset($usuarioData['persona']['peso'])
    ? (string) $usuarioData['persona']['peso']
    : null;
        $usuarioData['persona']['imagen'] = $imgBase64;
    }

    return response()->json([
        'message' => 'Inicio de sesión exitoso',
        'usuario' => $usuarioData,
        'token'   => $token
    ], 200);
}

    /**
     * ✏️ ACTUALIZAR PERFIL (Protegido por Sanctum)
     */
public function actualizarPerfil(Request $request)
{
    $user = $request->user();

    $validator = Validator::make($request->all(), [
        'name'               => 'required|string|max:100',
        'descripcion_perfil' => 'nullable|string',
        'altura'             => 'required|numeric',
        'peso'               => 'required|numeric',
        'imagen'             => 'nullable|string',
        'nombres'            => 'nullable|string',
        'apellido_paterno'   => 'nullable|string',
        'apellido_materno'   => 'nullable|string',
        'telefono'           => 'nullable|string',
        'fecha_nacimiento'   => 'nullable|date',
    ]);

    if ($validator->fails()) {
        return response()->json(["success" => false, "errors" => $validator->errors()],422);
    }

    // ======================= USUARIO =======================
    $user->update([
        "name"               => $request->name,
        "descripcion_perfil" => $request->descripcion_perfil,
    ]);

    // ======================= PERSONA =======================
    $persona = $user->persona;

    if ($request->has("nombres"))          $persona->nombres = $request->nombres;
    if ($request->has("apellido_paterno")) $persona->apellido_paterno = $request->apellido_paterno;
    if ($request->has("apellido_materno")) $persona->apellido_materno = $request->apellido_materno;
    if ($request->has("telefono"))         $persona->telefono = $request->telefono;
    if ($request->has("fecha_nacimiento")) $persona->fecha_nacimiento = $request->fecha_nacimiento;

    $persona->altura = floatval($request->altura);
    $persona->peso   = floatval($request->peso);

    // Guardar imagen si viene
    if ($request->filled('imagen')) {
        $persona->imagen = base64_decode($request->imagen);
    }

    $persona->save();

    // ======================= PROCESAR IMAGEN =======================
    $img = $persona->imagen;

    if (is_resource($img)) {
        $img = stream_get_contents($img);
    }

    $imgBase64 = (!empty($img)) ? base64_encode($img) : null;

    // ======================= RESPUESTA =======================
    return response()->json([
        "success" => true,
        "message" => "Perfil actualizado",
        "usuario" => [
            "name" => $user->name,
            "descripcion_perfil" => $user->descripcion_perfil,
            "persona" => [
                "nombres" => $persona->nombres,
                "apellido_paterno" => $persona->apellido_paterno,
                "apellido_materno" => $persona->apellido_materno,
                "telefono" => $persona->telefono,
                "altura" => (string) $persona->altura,
                "peso" => (string) $persona->peso,
                "fecha_nacimiento" => $persona->fecha_nacimiento,
                "imagen" => $imgBase64
            ]
        ]
    ]);
}
}
