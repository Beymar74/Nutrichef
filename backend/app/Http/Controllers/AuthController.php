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
    // Registro de usuario
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            // Datos de persona
            'nombres' => 'required|string|max:100',
            'apellido_paterno' => 'required|string|max:100',
            'apellido_materno' => 'nullable|string|max:100',
            'telefono' => 'nullable|string|max:20',
            'fecha_nacimiento' => 'nullable|date',

            // Datos de usuario
            'email' => 'required|email|unique:usuarios,email',
            'password' => 'required|string|min:6|confirmed', // 'password_confirmation'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Crear registro en PERSONAS
        $persona = Persona::create([
            'nombres' => $request->nombres,
            'apellido_paterno' => $request->apellido_paterno,
            'apellido_materno' => $request->apellido_materno,
            'telefono' => $request->telefono,
            'fecha_nacimiento' => $request->fecha_nacimiento,
        ]);

        // ==========================================================
        // 🧠 Generar automáticamente un "name" corto (ej: kiap)
        // ==========================================================

        // Tomar solo el primer nombre (si hay más de uno)
        $primerNombre = explode(' ', trim($request->nombres))[0] ?? '';
        $apellidoPaterno = trim($request->apellido_paterno ?? '');

        // Quitar tildes y caracteres especiales
        $primerNombre = Str::ascii($primerNombre);
        $apellidoPaterno = Str::ascii($apellidoPaterno);

        // Obtener las 2 primeras letras de cada uno
        $parteNombre = strtolower(substr($primerNombre, 0, 2));
        $parteApellido = strtolower(substr($apellidoPaterno, 0, 2));

        // Unirlos → ejemplo: "kiap"
        $nameGenerado = $parteNombre . $parteApellido;

        // Crear registro en USUARIOS
        $usuario = Usuario::create([
            'id_rol' => 2, // Rol por defecto: user
            'id_persona' => $persona->id,
            'name' => $nameGenerado,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'descripcion_perfil' => null,
        ]);

        return response()->json([
            'message' => 'Usuario registrado correctamente',
            'usuario' => $usuario->load('persona', 'rol'),
        ], 201);
    }

    // Login de usuario
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $usuario = Usuario::where('email', $request->email)->first();

        if (!$usuario || !Hash::check($request->password, $usuario->password)) {
            return response()->json(['message' => 'Credenciales incorrectas'], 401);
        }

        return response()->json([
            'message' => 'Inicio de sesión exitoso',
            'usuario' => $usuario->load('persona', 'rol'),
        ], 200);
    }
}
