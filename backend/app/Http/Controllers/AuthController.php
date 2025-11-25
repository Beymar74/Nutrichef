<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use App\Models\Persona;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Google_Client;

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
            'id_rol'            => 4, // Rol por defecto: usuario
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

        // 🔥 Generar token Sanctum
        $token = $usuario->createToken('mobile')->plainTextToken;

        return response()->json([
            'message' => 'Inicio de sesión exitoso',
            'usuario' => $usuario->load('persona', 'rol'),
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
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // 📝 Actualizamos tabla usuarios
        $user->update([
            "name"               => $request->name,
            "descripcion_perfil" => $request->descripcion_perfil,
        ]);

        // 🏋️ Actualizamos tabla personas
        $user->persona->update([
            "altura" => $request->altura,
            "peso"   => $request->peso,
        ]);

        return response()->json([
            "success"  => true,
            "message"  => "Perfil actualizado correctamente",
        ]);
    }
    public function googleLogin(Request $request)
{
    $idToken = $request->input('id_token');

    if (!$idToken) {
        return response()->json([
            'success' => false,
            'message' => 'No se recibió id_token'
        ], 400);
    }

    // Validar token recibido desde Firebase
    $client = new Google_Client(['client_id' => env('GOOGLE_CLIENT_ID')]);
    $payload = $client->verifyIdToken($idToken);

    if (!$payload) {
        return response()->json([
            'success' => false,
            'message' => 'Token inválido'
        ], 401);
    }

    // Datos enviados por Google
    $email          = $payload['email'];
    $nombreCompleto = $payload['name'];
    $fotoGoogle     = $payload['picture'] ?? null;

    // Verificar si el usuario ya existe
    $usuario = Usuario::where('email', $email)->first();

    if (!$usuario) {
        // Registrar si no existe

        $partes = explode(' ', $nombreCompleto);

        $persona = Persona::create([
            'nombres'           => $partes[0] ?? '',
            'apellido_paterno'  => $partes[1] ?? '',
            'apellido_materno'  => $partes[2] ?? '',
            'telefono'          => null,
            'fecha_nacimiento'  => null,
            'foto'              => $fotoGoogle
        ]);

        // Crear nombre corto automático
        $username = strtolower(substr($partes[0], 0, 2) . substr($partes[1] ?? 'x', 0, 2));

        $usuario = Usuario::create([
            'id_rol'            => 4, // rol usuario normal
            'id_persona'        => $persona->id,
            'name'              => $username,
            'email'             => $email,
            'password'          => Hash::make(Str::random(16)), // contraseña aleatoria
            'descripcion_perfil'=> null
        ]);
    }

    // Crear token Sanctum
    $token = $usuario->createToken('googleLogin')->plainTextToken;

    return response()->json([
        'success' => true,
        'token'   => $token,
        'usuario' => $usuario->load('persona', 'rol')
    ]);
}
}
