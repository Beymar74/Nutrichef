<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - NutriChef Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        calabaza: {
                            500: '#ea580c', // Naranja principal
                            600: '#c2410c',
                            700: '#9a3412',
                        },
                        cafe: {
                            900: '#702e12', // Tono oscuro del sidebar
                        }
                    }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-100 h-screen flex items-center justify-center p-4">

    <div class="bg-white w-full max-w-5xl shadow-2xl rounded-2xl overflow-hidden flex flex-col md:flex-row h-[600px]">
        
        <!-- Sección Visual (Izquierda) -->
        <div class="hidden md:block md:w-1/2 relative bg-cafe-900">
            <!-- Imagen de fondo superpuesta -->
            <img src="https://images.unsplash.com/photo-1543353071-873f17a7a088?q=80&w=2070&auto=format&fit=crop" 
                 alt="Cocina NutriChef" 
                 class="absolute inset-0 w-full h-full object-cover opacity-60">
            
            <!-- Contenido sobre la imagen -->
            <div class="relative z-10 h-full flex flex-col justify-between p-12 text-white">
                <div class="flex items-center space-x-3">
                    <div class="bg-calabaza-500 p-2 rounded-full">
                        <i data-lucide="utensils" class="w-6 h-6 text-white"></i>
                    </div>
                    <span class="text-2xl font-bold tracking-wide">NutriChef</span>
                </div>

                <div>
                    <h2 class="text-3xl font-bold mb-4">Bienvenido al Panel de Control</h2>
                    <p class="text-orange-100 text-lg leading-relaxed">
                        Gestiona recetas, usuarios y la planificación nutricional de miles de personas desde un solo lugar.
                    </p>
                </div>

                <div class="text-sm text-orange-200">
                    &copy; {{ date('Y') }} Escuela Militar de Ingeniería
                </div>
            </div>
        </div>

        <!-- Formulario (Derecha) -->
        <div class="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center bg-white">
            
            <div class="text-center md:text-left mb-10">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Iniciar Sesión</h1>
                <p class="text-gray-500">Ingresa tus credenciales para acceder.</p>
            </div>

            <!-- Formulario Laravel -->
            <!-- Ajusta la ruta 'login' según tu archivo routes/web.php -->
            <form method="POST" action="{{ route('login') }}" class="space-y-6">
                <!-- Token CSRF obligatorio en Laravel -->
                @csrf 

                <!-- Email -->
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Correo Electrónico</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i data-lucide="mail" class="h-5 w-5 text-gray-400"></i>
                        </div>
                        <input type="email" name="email" id="email" required autofocus
                            class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-calabaza-500 focus:border-calabaza-500 transition-colors placeholder-gray-400"
                            placeholder="admin@nutrichef.com"
                            value="{{ old('email') }}">
                    </div>
                    <!-- Mostrar error de validación -->
                    @error('email')
                        <p class="mt-2 text-sm text-red-600">{{ $message }}</p>
                    @enderror
                </div>

                <!-- Contraseña -->
                <div>
                    <div class="flex items-center justify-between mb-2">
                        <label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
                        <!-- Enlace opcional si implementas recuperación -->
                        @if (Route::has('password.request'))
                            <a href="{{ route('password.request') }}" class="text-sm font-medium text-calabaza-600 hover:text-calabaza-500">
                                ¿Olvidaste tu contraseña?
                            </a>
                        @endif
                    </div>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i data-lucide="lock" class="h-5 w-5 text-gray-400"></i>
                        </div>
                        <input type="password" name="password" id="password" required
                            class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-calabaza-500 focus:border-calabaza-500 transition-colors placeholder-gray-400"
                            placeholder="••••••••">
                    </div>
                    @error('password')
                        <p class="mt-2 text-sm text-red-600">{{ $message }}</p>
                    @enderror
                </div>

                <!-- Recordarme -->
                <div class="flex items-center">
                    <input id="remember_me" name="remember" type="checkbox" 
                        class="h-4 w-4 text-calabaza-600 focus:ring-calabaza-500 border-gray-300 rounded">
                    <label for="remember_me" class="ml-2 block text-sm text-gray-900">
                        Mantener sesión iniciada
                    </label>
                </div>

                <!-- Botón Submit -->
                <button type="submit" 
                    class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-calabaza-500 hover:bg-calabaza-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-calabaza-500 transition-all transform hover:scale-[1.02]">
                    Ingresar al Sistema
                </button>
            </form>

            <!-- Footer Móvil -->
            <div class="mt-8 text-center md:hidden">
                <p class="text-xs text-gray-500">&copy; NutriChef Admin</p>
            </div>
        </div>
    </div>

    <script>
        // Inicializar iconos
        lucide.createIcons();
    </script>
</body>
</html>