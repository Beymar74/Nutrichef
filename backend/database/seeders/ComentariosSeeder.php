<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Usuario;
use App\Models\Receta;
use App\Models\Publicacion;
use App\Models\Comentario;
use App\Models\Subdominio;
use Illuminate\Support\Facades\DB;

class ComentariosSeeder extends Seeder
{
    public function run()
    {
        // 1. Obtener datos base necesarios
        $usuarios = Usuario::all();
        $recetas = Receta::all();
        
        // Buscar Estados necesarios (Asumiendo que corriste DominiosSeeder)
        $estadoPubPublicada = Subdominio::where('descripcion', 'PUBLICADA')
            ->whereHas('dominio', fn($q) => $q->where('descripcion', 'ESTADO_PUBLICACION'))
            ->value('id');

        $estadoComVisible = Subdominio::where('descripcion', 'VISIBLE')
            ->whereHas('dominio', fn($q) => $q->where('descripcion', 'ESTADO_COMENTARIO'))
            ->value('id');
            
        $estadoComReportado = Subdominio::where('descripcion', 'REPORTADO')
            ->value('id');

        // Validar que existan datos mínimos
        if ($usuarios->isEmpty() || $recetas->isEmpty() || !$estadoPubPublicada) {
            $this->command->info('⚠️ No hay suficientes usuarios, recetas o estados para crear comentarios.');
            return;
        }

        $comentariosFalsos = [
            "¡Me encantó esta receta! Súper fácil de hacer.",
            "La intenté hacer ayer y quedó deliciosa, gracias por compartir.",
            "¿Se puede sustituir el azúcar por estevia? Tengo diabetes.",
            "No me gustó mucho, le falta sabor a mi parecer.",
            "Excelente presentación, se ve profesional.",
            "Mis hijos se lo comieron todo, un éxito total en casa.",
            "Demasiado tiempo de cocción para mi gusto, pero buen sabor.",
            "¡Riquísimo! 10/10 definitivamente lo recomiendo.",
            "Creo que las cantidades de los ingredientes están mal calculadas.",
            "Voy a guardarla para la cena de Navidad, se ve increíble.",
            "¿Cuántas calorías tiene aproximadamente esta receta?",
            "La hice para mi esposo y le fascinó, muchas gracias.",
            "¿Funciona con harina integral en lugar de harina blanca?",
            "Quedó un poco seco, tal vez necesita más líquido.",
            "Primera vez que cocino esto y me salió perfecto, gracias.",
            "¿Alguien la ha probado con pollo en vez de carne?",
            "Me recordó a la comida de mi abuela, muy nostálgico.",
            "Perfecto para meal prep de toda la semana.",
            "Los tiempos de cocción no coinciden con mi horno.",
            "Quedó espectacular, la voy a hacer para mi cumpleaños.",
            "¿Es apta para personas con intolerancia a la lactosa?",
            "Muy rica pero un poco cara por los ingredientes.",
            "La prepare siguiendo el paso a paso y salió genial.",
            "¿Se puede hacer en freidora de aire?",
            "Mis invitados preguntaron por la receta, todo un éxito.",
            "Le agregué un poco de ajo y quedó aún mejor.",
            "No encuentro ese ingrediente en mi ciudad, ¿alternativas?",
            "Ideal para los que estamos en régimen, muy saludable.",
            "La textura no me convenció pero el sabor sí.",
            "Ya es la tercera vez que la hago, se volvió mi favorita.",
        ];

        // 2. Iterar sobre recetas para crear publicaciones y comentarios
        foreach ($recetas as $receta) {
            
            // Crear o buscar la Publicación asociada a la receta
            // (Las recetas necesitan estar 'publicadas' en la red social para recibir comentarios)
            $publicacion = Publicacion::firstOrCreate(
                ['id_receta' => $receta->id],
                [
                    'id_usuario' => $receta->id_usuario_creador,
                    'id_estado' => $estadoPubPublicada,
                    'descripcion' => '¡Miren mi nueva creación culinaria: ' . $receta->titulo . '!',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]
            );

            // 3. Crear entre 1 y 4 comentarios por receta
            $numComentarios = rand(1, 4);

            for ($i = 0; $i < $numComentarios; $i++) {
                $usuarioRandom = $usuarios->random();
                $textoRandom = $comentariosFalsos[array_rand($comentariosFalsos)];
                
                // 10% de probabilidad de que nazca como REPORTADO para que tengas qué moderar
                $estadoFinal = (rand(1, 10) > 9) ? $estadoComReportado : $estadoComVisible;

                Comentario::create([
                    'id_usuario' => $usuarioRandom->id,
                    'id_publicacion' => $publicacion->id,
                    'id_estado' => $estadoFinal ?? $estadoComVisible, // Fallback
                    'contenido' => $textoRandom,
                    'created_at' => now()->subMinutes(rand(1, 10000)), // Fechas aleatorias
                ]);
            }
        }
        
        $this->command->info('✅ Comentarios generados exitosamente.');
    }
}