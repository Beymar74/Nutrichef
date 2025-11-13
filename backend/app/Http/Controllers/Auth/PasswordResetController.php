<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Usuario;
use App\Models\CodigoVerificacion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class PasswordResetController extends Controller
{
    // ============================================================
    // 📩 1. ENVIAR CÓDIGO
    // ============================================================
    public function enviarCodigo(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        $usuario = Usuario::where('email', $request->email)->first();

        if (!$usuario) {
            return response()->json([
                'success' => false,
                'message' => 'El correo no está registrado.'
            ], 404);
        }

        // Deshabilitar códigos anteriores
        CodigoVerificacion::where('id_usuario', $usuario->id)
            ->update(['habilitado' => false]);

        // Generar código
        $codigo = rand(100000, 999999);

        CodigoVerificacion::create([
            'id_usuario' => $usuario->id,
            'codigo' => $codigo,
            'expira_en' => Carbon::now()->addMinutes(2),
            'habilitado' => true
        ]);

        // Enviar correo
        Mail::raw(
            "Tu código de recuperación NutriChef es: $codigo\n\nExpira en 2 minutos.",
            function ($msg) use ($usuario) {
                $msg->to($usuario->email)
                    ->subject("🔐 Recuperación de contraseña - NutriChef")
                    ->from("p43248441@gmail.com", "NutriChef Soporte");
            }
        );

        return response()->json([
            'success' => true,
            'message' => 'Código enviado correctamente.'
        ]);
    }


    // ============================================================
    // 🔍 2. VERIFICAR CÓDIGO
    // ============================================================
    public function verificarCodigo(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'codigo' => 'required'
        ]);

        $usuario = Usuario::where('email', $request->email)->first();

        if (!$usuario) {
            return response()->json([
                'success' => false,
                'message' => 'Correo inválido'
            ], 404);
        }

        $registro = CodigoVerificacion::where('id_usuario', $usuario->id)
            ->where('codigo', $request->codigo)
            ->where('habilitado', true)
            ->first();

        if (!$registro) {
            return response()->json([
                'success' => false,
                'message' => 'Código incorrecto'
            ], 400);
        }

        // Verificar expiración
        if (Carbon::now()->greaterThan($registro->expira_en)) {

            // inhabilitarlo
            $registro->habilitado = false;
            $registro->save();

            return response()->json([
                'success' => false,
                'message' => 'El código ha expirado, solicita uno nuevo.'
            ], 410);
        }

        return response()->json([
            'success' => true,
            'message' => 'Código válido'
        ]);
    }


    // ============================================================
    // 🔐 3. CAMBIAR CONTRASEÑA
    // ============================================================
    public function cambiarPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6'
        ]);

        $usuario = Usuario::where('email', $request->email)->first();

        if (!$usuario) {
            return response()->json([
                'success' => false,
                'message' => 'Correo no encontrado'
            ], 404);
        }

        // Actualizar contraseña
        $usuario->password = Hash::make($request->password);
        $usuario->save();

        return response()->json([
            'success' => true,
            'message' => 'Contraseña actualizada correctamente'
        ]);
    }
}
