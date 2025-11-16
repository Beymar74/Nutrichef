<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Hash; // Importante para el password

class RecetasdosSeeder extends Seeder
{
    public function run()
    {
        // Desactivar restricciones para inserción fluida
        Schema::disableForeignKeyConstraints();

        $now = Carbon::now();

        /* ============================================================
           0) ASEGURAR ROLES NECESARIOS
        ============================================================ */
        // Creamos el rol de "Chef/Usuario" (ID 2) si no existe, para evitar el error de Foreign Key
        DB::table('roles')->updateOrInsert(['id' => 2], [
            'descripcion' => 'Chef / Usuario',
            'estado' => true,
            'created_at' => $now,
            'updated_at' => $now
        ]);

        // También aseguramos el rol Admin (ID 1) por si acaso
        DB::table('roles')->updateOrInsert(['id' => 1], [
            'descripcion' => 'Administrador',
            'estado' => true,
            'created_at' => $now,
            'updated_at' => $now
        ]);

        /* ============================================================
           0.1) USUARIOS DE PRUEBA
        ============================================================ */
        // Asegurarnos de que exista la persona base para estos usuarios (reutilizamos la persona 1 o creamos nuevas si fuera necesario, aquí simplificamos usando persona 1 para no complicar con otra tabla)
        // NOTA: En un caso real, cada usuario debería tener su propia persona, pero para este test rápido de recetas, reutilizaremos el ID de persona 1 o crearemos una genérica.
        
        // Creemos una persona genérica ID 2 para estos usuarios de prueba
        DB::table('personas')->updateOrInsert(['id' => 2], [
            'nombres' => 'Usuario',
            'apellido_paterno' => 'Prueba',
            'estado' => true,
            'created_at' => $now,
            'updated_at' => $now
        ]);

        $usuariosPrueba = [
            ['id' => 50, 'name' => 'Chef Luigi', 'email' => 'luigi@test.com', 'password' => Hash::make('pass'), 'id_rol' => 2, 'id_persona' => 2, 'estado' => true],
            ['id' => 51, 'name' => 'Maria Fit', 'email' => 'maria@test.com', 'password' => Hash::make('pass'), 'id_rol' => 2, 'id_persona' => 2, 'estado' => true],
            ['id' => 52, 'name' => 'Pedro Panadero', 'email' => 'pedro@test.com', 'password' => Hash::make('pass'), 'id_rol' => 2, 'id_persona' => 2, 'estado' => true],
        ];

        foreach ($usuariosPrueba as $u) {
            DB::table('usuarios')->updateOrInsert(['id' => $u['id']], array_merge($u, ['created_at' => $now, 'updated_at' => $now]));
        }

        /* ============================================================
           RECETAS DE PRUEBA PARA EL ADMIN
           Variedad de estados para probar filtros y colores
        ============================================================ */
        $recetasTest = [
            // 1. Receta PENDIENTE (Para probar el botón de aprobar/rechazar)
            [
                'id' => 101,
                'id_usuario_creador' => 50, // Chef Luigi
                'id_estado' => 2, // Pendiente
                'id_tipo_alimento' => 3, // Principal
                'titulo' => 'Risotto de Champiñones Trufado',
                'resumen' => 'Un risotto cremoso con aceite de trufa blanca, ideal para cenas elegantes.',
                'tiempo_preparacion' => 45,
                'preparacion' => "1. Sofreír cebolla y ajo.\n2. Tostar el arroz arborio.\n3. Agregar vino blanco.\n4. Incorporar caldo poco a poco.\n5. Terminar con mantequilla y parmesano.",
                'porciones_estimadas' => 4,
                'created_at' => $now->copy()->subHours(2), // Creada hace 2 horas
                'updated_at' => $now->copy()->subHours(2)
            ],
            // 2. Receta PUBLICADA (Para ver el badge verde)
            [
                'id' => 102,
                'id_usuario_creador' => 51, // Maria Fit
                'id_estado' => 1, // Publicada
                'id_tipo_alimento' => 4, // Desayuno
                'titulo' => 'Pancakes de Avena y Banano',
                'resumen' => 'Sin harina ni azúcar añadida, perfectos para antes de entrenar.',
                'tiempo_preparacion' => 15,
                'preparacion' => "1. Licuar avena, huevo y banano.\n2. Calentar sartén.\n3. Cocinar vuelta y vuelta.",
                'porciones_estimadas' => 1,
                'created_at' => $now->copy()->subDays(1), // Ayer
                'updated_at' => $now->copy()->subDays(1)
            ],
            // 3. Receta RECHAZADA (Para probar visualización de rechazados)
            // Asumiendo ID 3 para RECHAZADA. Si no existe en subdominios, el seeder debería crearlo o fallará.
            // Asegurémonos de crear el estado RECHAZADA si no existe.
        ];

        // Asegurar estado RECHAZADA (ID 3)
        DB::table('subdominios')->updateOrInsert(['id' => 3], [
            'id_dominio' => 1, // ESTADO
            'descripcion' => 'Rechazada',
            'created_at' => $now,
            'updated_at' => $now
        ]);

        $recetasTest[] = [
            'id' => 103,
            'id_usuario_creador' => 52, // Pedro
            'id_estado' => 3, // Rechazada
            'id_tipo_alimento' => 5, // Cena
            'titulo' => 'Pizza con Piña y Anchoas',
            'resumen' => 'Una combinación controversial pero deliciosa para valientes.',
            'tiempo_preparacion' => 30,
            'preparacion' => "1. Estirar masa.\n2. Poner salsa y queso.\n3. Agregar piña y anchoas.\n4. Hornear.",
            'porciones_estimadas' => 2,
            'created_at' => $now->copy()->subDays(5),
            'updated_at' => $now->copy()->subDays(4) // Rechazada un día después
        ];

        // 4. Receta PENDIENTE SIN FOTO (Para probar el placeholder)
        $recetasTest[] = [
            'id' => 104,
            'id_usuario_creador' => 50,
            'id_estado' => 2, // Pendiente
            'id_tipo_alimento' => 3,
            'titulo' => 'Pasta Carbonara Auténtica',
            'resumen' => 'La verdadera receta italiana sin crema de leche.',
            'tiempo_preparacion' => 20,
            'preparacion' => "1. Cocer pasta.\n2. Mezclar yemas y pecorino.\n3. Dorar guanciale.\n4. Emulsionar todo fuera del fuego.",
            'porciones_estimadas' => 2,
            'created_at' => $now, // Recién creada
            'updated_at' => $now
        ];

        foreach ($recetasTest as $r) {
            DB::table('recetas')->updateOrInsert(['id' => $r['id']], $r);
        }

        /* ============================================================
           IMÁGENES DE PRUEBA (Solo para las que tienen foto)
        ============================================================ */
        // Limpiamos multimedia para evitar duplicados
        DB::table('multimedia_recetas')->whereIn('id_receta', [101, 102, 103])->delete();

        DB::table('multimedia_recetas')->insert([
            // Risotto (Pendiente)
            ['id_receta' => 101, 'archivo' => 'https://images.unsplash.com/photo-1476124369491-c4384d8b2a2e?auto=format&fit=crop&w=800&q=80', 'tipo_archivo' => 'image', 'orden' => 1, 'created_at' => $now, 'updated_at' => $now],
            // Pancakes (Publicada)
            ['id_receta' => 102, 'archivo' => 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?auto=format&fit=crop&w=800&q=80', 'tipo_archivo' => 'image', 'orden' => 1, 'created_at' => $now, 'updated_at' => $now],
            // Pizza (Rechazada)
            ['id_receta' => 103, 'archivo' => 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80', 'tipo_archivo' => 'image', 'orden' => 1, 'created_at' => $now, 'updated_at' => $now],
        ]);

        Schema::enableForeignKeyConstraints();
    }
}