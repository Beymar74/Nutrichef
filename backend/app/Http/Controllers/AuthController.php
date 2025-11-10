<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    /**
     * Registrar nuevo usuario
     */
    public function register(Request $request)
    {
        // Validar datos
        $validator = Validator::make($request->all(), [
            'nombre_completo' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'celular' => 'required|string|max:20',
            'fecha_nacimiento' => 'required|date',
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Error de validación',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Crear usuario
            $user = User::create([
                'nombre_completo' => $request->nombre_completo,
                'email' => $request->email,
                'celular' => $request->celular,
                'fecha_nacimiento' => $request->fecha_nacimiento,
                'password' => Hash::make($request->password),
            ]);

            return response()->json([
                'success' => true,
                'message' => '¡Registro exitoso!',
                'user' => [
                    'id' => $user->id,
                    'nombre_completo' => $user->nombre_completo,
                    'email' => $user->email,
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al registrar usuario',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Iniciar sesión
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Completa todos los campos',
                'errors' => $validator->errors()
            ], 422);
        }

        // Buscar usuario
        $user = User::where('email', $request->email)->first();

        // Verificar usuario y contraseña
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Credenciales incorrectas'
            ], 401);
        }

        return response()->json([
            'success' => true,
            'message' => '¡Bienvenido!',
            'user' => [
                'id' => $user->id,
                'nombre_completo' => $user->nombre_completo,
                'email' => $user->email,
            ]
        ], 200);
    }
}