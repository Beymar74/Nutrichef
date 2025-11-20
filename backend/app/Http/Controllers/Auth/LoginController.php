<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    /**
     * Procesa el formulario de login.
     */
    public function login(Request $request)
    {
        // 1. Validar que los campos no estén vacíos
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        // 2. Intentar autenticar (Laravel busca en la tabla usuarios automáticamente si el Modelo está bien configurado)
        // El 'remember' verifica si el checkbox "Mantener sesión" fue marcado
        if (Auth::attempt($credentials, $request->boolean('remember'))) {
            
            // 3. Si es correcto: Regenerar sesión por seguridad
            $request->session()->regenerate();

            // 4. Redirigir al Dashboard Administrativo
            return redirect()->intended(route('admin.dashboard'));
        }

        // 5. Si falla: Regresar con un error
        return back()->withErrors([
            'email' => 'Las credenciales no coinciden con nuestros registros.',
        ])->onlyInput('email');
    }

    /**
     * Cerrar sesión.
     */
    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/login');
    }
}