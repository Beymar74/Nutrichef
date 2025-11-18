<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Hash;

class RecetasdosSeeder extends Seeder
{
    public function run()
    {
        Schema::disableForeignKeyConstraints();
        $now = Carbon::now();

        $this->command->info('🌱 Iniciando inserción de datos de prueba...');

        // ============================================================
        // SINCRONIZAR TODAS LAS SECUENCIAS AL INICIO
        // ============================================================
        $this->sincronizarSecuencias();

        /* ============================================================
           0) DOMINIOS - Idempotente por descripción
        ============================================================ */
        $dominios = [
            ['descripcion' => 'ESTADO'],
            ['descripcion' => 'TIPO_ALIMENTO'],
            ['descripcion' => 'UNIDAD_MEDIDA'],
            ['descripcion' => 'DIETA'],
        ];

        foreach ($dominios as $d) {
            DB::table('dominios')->updateOrInsert(
                ['descripcion' => $d['descripcion']],
                ['descripcion' => $d['descripcion'], 'created_at' => $now, 'updated_at' => $now]
            );
        }

        // Obtener IDs reales de dominios
        $estadoDominioId = DB::table('dominios')->where('descripcion', 'ESTADO')->value('id');
        $tipoAlimentoDominioId = DB::table('dominios')->where('descripcion', 'TIPO_ALIMENTO')->value('id');
        $unidadMedidaDominioId = DB::table('dominios')->where('descripcion', 'UNIDAD_MEDIDA')->value('id');
        $dietaDominioId = DB::table('dominios')->where('descripcion', 'DIETA')->value('id');

        /* ============================================================
        0.1) SUBDOMINIOS - Estados (idempotente)
        ============================================================ */
        $estados = [
            ['descripcion' => 'BORRADOR'],      // Para recetas en borrador
            ['descripcion' => 'PUBLICADA'],     // Para recetas publicadas (aprobadas)
            ['descripcion' => 'OCULTA'],        // Para recetas ocultas
            ['descripcion' => 'ELIMINADA'],     // Para recetas eliminadas
        ];

        foreach ($estados as $estado) {
            DB::table('subdominios')->updateOrInsert(
                ['id_dominio' => $estadoDominioId, 'descripcion' => $estado['descripcion']],
                ['id_dominio' => $estadoDominioId, 'descripcion' => $estado['descripcion'], 'created_at' => $now, 'updated_at' => $now]
            );
        }

        // Agregar estados adicionales para moderación
        $estadosMod = [
            ['descripcion' => 'PENDIENTE'],     // Esperando aprobación
            ['descripcion' => 'RECHAZADA'],     // Rechazada por moderador
        ];

        foreach ($estadosMod as $estado) {
            DB::table('subdominios')->updateOrInsert(
                ['id_dominio' => $estadoDominioId, 'descripcion' => $estado['descripcion']],
                ['id_dominio' => $estadoDominioId, 'descripcion' => $estado['descripcion'], 'created_at' => $now, 'updated_at' => $now]
            );
        }

        // Obtener IDs de estados existentes
$estadoBorradorId = DB::table('subdominios')
    ->where('id_dominio', $estadoDominioId)
    ->where('descripcion', 'BORRADOR')
    ->value('id'); // Este representa "APROBADA"

$estadoOcultaId = DB::table('subdominios')
    ->where('id_dominio', $estadoDominioId)
    ->where('descripcion', 'OCULTA')
    ->value('id'); // Este representa "RECHAZADA"

// Crear o asegurar que existe el estado PENDIENTE
DB::table('subdominios')->updateOrInsert(
    ['id_dominio' => $estadoDominioId, 'descripcion' => 'Pendiente'],
    ['id_dominio' => $estadoDominioId, 'descripcion' => 'Pendiente', 'created_at' => $now, 'updated_at' => $now]
);

$estadoPendienteId = DB::table('subdominios')
    ->where('id_dominio', $estadoDominioId)
    ->where('descripcion', 'Pendiente')
    ->value('id');

        /* ============================================================
           0.2) SUBDOMINIOS - Unidades de Medida (idempotente)
        ============================================================ */
        $unidades = [
            ['descripcion' => 'gramos'],
            ['descripcion' => 'unidad'],
            ['descripcion' => 'mililitros'],
        ];

        foreach ($unidades as $u) {
            DB::table('subdominios')->updateOrInsert(
                ['id_dominio' => $unidadMedidaDominioId, 'descripcion' => $u['descripcion']],
                ['id_dominio' => $unidadMedidaDominioId, 'descripcion' => $u['descripcion'], 'created_at' => $now, 'updated_at' => $now]
            );
        }

        // Obtener IDs reales de unidades
        $unidadGramosId = DB::table('subdominios')
            ->where('id_dominio', $unidadMedidaDominioId)
            ->where('descripcion', 'gramos')
            ->value('id');
        
        $unidadUnidadId = DB::table('subdominios')
            ->where('id_dominio', $unidadMedidaDominioId)
            ->where('descripcion', 'unidad')
            ->value('id');
        
        $unidadMililitrosId = DB::table('subdominios')
            ->where('id_dominio', $unidadMedidaDominioId)
            ->where('descripcion', 'mililitros')
            ->value('id');

        /* ============================================================
           0.3) SUBDOMINIOS - Tipos de Alimento (idempotente)
        ============================================================ */
        $tiposAlimento = [
            ['descripcion' => 'Entrada'],
            ['descripcion' => 'Plato Principal'],
            ['descripcion' => 'Cena'],
            ['descripcion' => 'Desayuno'],
            ['descripcion' => 'Almuerzo'],
            ['descripcion' => 'Bebida'],
        ];

        foreach ($tiposAlimento as $tipo) {
            DB::table('subdominios')->updateOrInsert(
                ['id_dominio' => $tipoAlimentoDominioId, 'descripcion' => $tipo['descripcion']],
                ['id_dominio' => $tipoAlimentoDominioId, 'descripcion' => $tipo['descripcion'], 'created_at' => $now, 'updated_at' => $now]
            );
        }

        // Obtener IDs reales de tipos de alimento
        $tipoDesayunoId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Desayuno')
            ->value('id');
        
        $tipoCenaId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Cena')
            ->value('id');
        
        $tipoPlatoPrincipalId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Plato Principal')
            ->value('id');
        
        $tipoAlmuerzoId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Almuerzo')
            ->value('id');
        
        $tipoBebidaId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Bebida')
            ->value('id');

        /* ============================================================
           1) ROLES - Idempotente por descripción
        ============================================================ */
        DB::table('roles')->updateOrInsert(
            ['descripcion' => 'Administrador'],
            ['descripcion' => 'Administrador', 'estado' => true, 'created_at' => $now, 'updated_at' => $now]
        );

        DB::table('roles')->updateOrInsert(
            ['descripcion' => 'Chef / Usuario'],
            ['descripcion' => 'Chef / Usuario', 'estado' => true, 'created_at' => $now, 'updated_at' => $now]
        );

        $rolChefId = DB::table('roles')->where('descripcion', 'Chef / Usuario')->value('id');

        /* ============================================================
           2) PERSONAS Y USUARIOS - Con reset de secuencia
        ============================================================ */
        DB::table('personas')->updateOrInsert(
            ['id' => 2],
            ['id' => 2, 'nombres' => 'Usuario', 'apellido_paterno' => 'Prueba', 'estado' => true, 'created_at' => $now, 'updated_at' => $now]
        );

        $usuariosPrueba = [
            ['name' => 'Chef Luigi', 'email' => 'luigi@test.com', 'password' => Hash::make('pass')],
            ['name' => 'Maria Fit', 'email' => 'maria@test.com', 'password' => Hash::make('pass')],
            ['name' => 'Pedro Panadero', 'email' => 'pedro@test.com', 'password' => Hash::make('pass')],
        ];

        foreach ($usuariosPrueba as $u) {
            $usuarioExistente = DB::table('usuarios')->where('email', $u['email'])->first();
            
            if ($usuarioExistente) {
                DB::table('usuarios')
                    ->where('email', $u['email'])
                    ->update([
                        'name' => $u['name'],
                        'password' => $u['password'],
                        'id_rol' => $rolChefId,
                        'id_persona' => 2,
                        'estado' => true,
                        'updated_at' => $now
                    ]);
            } else {
                DB::table('usuarios')->insert(array_merge($u, [
                    'id_rol' => $rolChefId,
                    'id_persona' => 2,
                    'estado' => true,
                    'created_at' => $now,
                    'updated_at' => $now
                ]));
            }
        }

        // Obtener IDs reales de usuarios
        $usuarioLuigiId = DB::table('usuarios')->where('email', 'luigi@test.com')->value('id');
        $usuarioMariaId = DB::table('usuarios')->where('email', 'maria@test.com')->value('id');
        $usuarioPedroId = DB::table('usuarios')->where('email', 'pedro@test.com')->value('id');

        /* ============================================================
           3) INGREDIENTES BASE - Idempotente por descripción
        ============================================================ */
        $ingredientesBase = [
            'Pollo (pechuga)', 'Huevo', 'Salmón', 'Carne molida', 'Atún enlatado',
            'Queso mozzarella', 'Queso parmesano', 'Yogurt griego', 'Arroz integral', 'Pasta integral',
            'Avena', 'Pan integral', 'Quinoa', 'Batata/Camote', 'Brócoli',
            'Espinaca', 'Tomate', 'Cebolla', 'Ajo', 'Zanahoria',
            'Pimiento', 'Champiñones', 'Lechuga', 'Banano/Plátano', 'Manzana',
            'Fresas', 'Arándanos', 'Aguacate', 'Limón', 'Aceite de oliva',
            'Mantequilla de maní', 'Nueces', 'Almendras', 'Jengibre', 'Cilantro',
            'Pimiento verde', 'Calabacín', 'Berenjena', 'Mango', 'Piña',
            'Kiwi', 'Queso ricotta', 'Pavo molido', 'Caldo de vegetales', 'Vino blanco',
            'Albahaca', 'Orégano', 'Comino', 'Leche', 'Miel'
        ];

        foreach ($ingredientesBase as $ing) {
            DB::table('ingredientes')->updateOrInsert(
                ['descripcion' => $ing],
                ['descripcion' => $ing, 'id_alergeno' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }

        /* ============================================================
           4) RECETAS - Idempotente por email del usuario + título
        ============================================================ */
       $recetasTest = [
    [
        'email_usuario' => 'luigi@test.com',
        'estado' => 'BORRADOR',  // Aprobada (Verde)
        'tipo_alimento' => 'Cena',
        'titulo' => 'Risotto de Champiñones Trufado',
        'resumen' => 'Un risotto cremoso con aceite de trufa blanca, ideal para cenas elegantes.',
        'tiempo_preparacion' => 45,
        'preparacion' => "1. Sofreír cebolla y ajo.\n2. Tostar el arroz arborio.\n3. Agregar vino blanco.\n4. Incorporar caldo poco a poco.\n5. Terminar con mantequilla y parmesano.",
        'porciones_estimadas' => 4,
        'calorias' => 380
    ],
    [
        'email_usuario' => 'maria@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Desayuno',
        'titulo' => 'Pancakes de Avena y Banano',
        'resumen' => 'Sin harina ni azúcar añadida, perfectos para antes de entrenar.',
        'tiempo_preparacion' => 15,
        'preparacion' => "1. Licuar avena, huevo y banano.\n2. Calentar sartén.\n3. Cocinar vuelta y vuelta.",
        'porciones_estimadas' => 1,
        'calorias' => 320
    ],
    [
        'email_usuario' => 'pedro@test.com',
        'estado' => 'OCULTA',  // Rechazada (Rojo)
        'tipo_alimento' => 'Almuerzo',
        'titulo' => 'Pizza con Piña y Anchoas',
        'resumen' => 'Una combinación controversial pero deliciosa para valientes.',
        'tiempo_preparacion' => 30,
        'preparacion' => "1. Estirar masa.\n2. Poner salsa y queso.\n3. Agregar piña y anchoas.\n4. Hornear.",
        'porciones_estimadas' => 2,
        'calorias' => 450
    ],
    [
        'email_usuario' => 'luigi@test.com',
        'estado' => 'BORRADOR',  // Aprobada (Verde)
        'tipo_alimento' => 'Cena',
        'titulo' => 'Pasta Carbonara Auténtica',
        'resumen' => 'La verdadera receta italiana sin crema de leche.',
        'tiempo_preparacion' => 20,
        'preparacion' => "1. Cocer pasta.\n2. Mezclar yemas y pecorino.\n3. Dorar guanciale.\n4. Emulsionar todo fuera del fuego.",
        'porciones_estimadas' => 2,
        'calorias' => 420
    ],
    [
        'email_usuario' => 'maria@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Desayuno',
        'titulo' => 'Bowl Energético de Quinoa y Frutas',
        'resumen' => 'Desayuno completo rico en proteínas y antioxidantes para empezar el día con energía.',
        'tiempo_preparacion' => 20,
        'preparacion' => "1. Cocer quinoa en leche hasta que esté cremosa.\n2. Servir en bowl.\n3. Cubrir con fresas, arándanos y banano en rodajas.\n4. Agregar almendras picadas y miel.\n5. Opcional: espolvorear canela.",
        'porciones_estimadas' => 2,
        'calorias' => 385
    ],
    [
        'email_usuario' => 'luigi@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Almuerzo',
        'titulo' => 'Salmón al Horno con Vegetales Rostizados',
        'resumen' => 'Plato bajo en carbohidratos, alto en omega-3 y perfecto para una cena saludable.',
        'tiempo_preparacion' => 35,
        'preparacion' => "1. Precalentar horno a 200°C.\n2. Cortar brócoli, zanahoria y pimiento.\n3. Mezclar vegetales con aceite de oliva, sal y pimienta.\n4. Colocar salmón sobre los vegetales.\n5. Hornear 25 minutos.\n6. Servir con limón.",
        'porciones_estimadas' => 3,
        'calorias' => 340
    ],
    [
        'email_usuario' => 'pedro@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Cena',
        'titulo' => 'Tacos de Pollo a la Plancha con Guacamole',
        'resumen' => 'Tacos proteicos con vegetales frescos y guacamole casero.',
        'tiempo_preparacion' => 25,
        'preparacion' => "1. Marinar pollo con limón, ajo y especias.\n2. Cocinar a la plancha hasta dorar.\n3. Preparar guacamole: aplastar aguacate con tomate, cebolla y limón.\n4. Calentar tortillas.\n5. Armar tacos con pollo, lechuga, guacamole.\n6. Servir caliente.",
        'porciones_estimadas' => 4,
        'calorias' => 395
    ],
    [
        'email_usuario' => 'maria@test.com',
        'estado' => 'BORRADOR',  // Aprobada (Verde)
        'tipo_alimento' => 'Cena',
        'titulo' => 'Ensalada Mediterránea con Atún',
        'resumen' => 'Ensalada fresca y completa, ideal para días calurosos.',
        'tiempo_preparacion' => 15,
        'preparacion' => "1. Picar lechuga, tomate, cebolla y pimiento.\n2. Agregar atún escurrido.\n3. Añadir aceitunas y queso mozzarella en cubos.\n4. Preparar vinagreta: aceite de oliva, limón, sal, pimienta.\n5. Mezclar todo y servir fresco.",
        'porciones_estimadas' => 2,
        'calorias' => 280
    ],
    [
        'email_usuario' => 'maria@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Bebida',
        'titulo' => 'Batido Post-Entreno de Banana y Mantequilla de Maní',
        'resumen' => 'Recuperación muscular con proteína y carbohidratos naturales.',
        'tiempo_preparacion' => 5,
        'preparacion' => "1. Congelar el banano en rodajas.\n2. Licuar banano congelado, yogurt griego, mantequilla de maní y leche.\n3. Agregar hielo si se desea más frío.\n4. Servir inmediatamente.",
        'porciones_estimadas' => 1,
        'calorias' => 420
    ],
    [
        'email_usuario' => 'luigi@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Cena',
        'titulo' => 'Wrap Integral de Pollo con Vegetales Salteados',
        'resumen' => 'Lunch rápido y nutritivo, fácil de llevar.',
        'tiempo_preparacion' => 20,
        'preparacion' => "1. Saltear pollo en tiras con aceite de oliva.\n2. Agregar pimiento y cebolla cortados.\n3. Sazonar con salsa de soja y pimienta.\n4. Calentar tortilla integral.\n5. Rellenar con pollo, vegetales y espinaca fresca.\n6. Enrollar y servir.",
        'porciones_estimadas' => 2,
        'calorias' => 365
    ],
    [
        'email_usuario' => 'pedro@test.com',
        'estado' => 'BORRADOR',  // Aprobada (Verde)
        'tipo_alimento' => 'Almuerzo',
        'titulo' => 'Hamburguesa de Carne con Pan Integral',
        'resumen' => 'Hamburguesa casera con ingredientes frescos y pan integral.',
        'tiempo_preparacion' => 30,
        'preparacion' => "1. Mezclar carne molida con ajo picado, sal y pimienta.\n2. Formar medallones.\n3. Cocinar a la plancha 4-5 min por lado.\n4. Tostar pan integral.\n5. Armar con lechuga, tomate, cebolla y queso.\n6. Servir con batata al horno.",
        'porciones_estimadas' => 3,
        'calorias' => 485
    ],
    [
        'email_usuario' => 'maria@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Desayuno',
        'titulo' => 'Tostadas de Aguacate con Huevo Pochado',
        'resumen' => 'Desayuno trendy, saludable y muy instagrameable.',
        'tiempo_preparacion' => 15,
        'preparacion' => "1. Tostar pan integral.\n2. Aplastar aguacate con limón, sal y pimienta.\n3. Pochear huevos en agua hirviendo.\n4. Untar aguacate en tostadas.\n5. Colocar huevo pochado encima.\n6. Decorar con pimienta y chile.",
        'porciones_estimadas' => 2,
        'calorias' => 340
    ],
    [
        'email_usuario' => 'luigi@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Almuerzo',
        'titulo' => 'Pollo Salteado Estilo Asiático con Arroz',
        'resumen' => 'Plato con sabores orientales, rápido de preparar.',
        'tiempo_preparacion' => 25,
        'preparacion' => "1. Cocer arroz integral.\n2. Saltear pollo en tiras con aceite.\n3. Agregar brócoli, zanahoria y pimiento.\n4. Añadir salsa de soja, ajo y jengibre.\n5. Cocinar 5 minutos más.\n6. Servir sobre arroz.",
        'porciones_estimadas' => 3,
        'calorias' => 410
    ],
    [
        'email_usuario' => 'maria@test.com',
        'estado' => 'Pendiente',  // Pendiente (Naranja)
        'tipo_alimento' => 'Desayuno',
        'titulo' => 'Bowl de Yogurt Griego con Granola y Berries',
        'resumen' => 'Desayuno ligero pero nutritivo, rico en probióticos.',
        'tiempo_preparacion' => 5,
        'preparacion' => "1. Servir yogurt griego en un bowl.\n2. Agregar fresas y arándanos frescos.\n3. Espolvorear avena y almendras.\n4. Rociar con miel.\n5. Opcional: agregar semillas de chía.",
        'porciones_estimadas' => 1,
        'calorias' => 280
    ],
];

        foreach ($recetasTest as $r) {
    // Obtener IDs dinámicamente
    $usuarioId = DB::table('usuarios')->where('email', $r['email_usuario'])->value('id');
    
    // Buscar el estado por descripción (sin importar mayúsculas/minúsculas)
    $estadoId = DB::table('subdominios')
        ->where('id_dominio', $estadoDominioId)
        ->whereRaw('UPPER(descripcion) = ?', [strtoupper($r['estado'])])
        ->value('id');
    
    // Si no se encuentra el estado, usar PENDIENTE por defecto
    if (!$estadoId) {
        $estadoId = DB::table('subdominios')
            ->where('id_dominio', $estadoDominioId)
            ->whereRaw('UPPER(descripcion) = ?', ['PENDIENTE'])
            ->value('id');
    }
    
    $tipoAlimentoId = DB::table('subdominios')
        ->where('id_dominio', $tipoAlimentoDominioId)
        ->where('descripcion', $r['tipo_alimento'])
        ->value('id');

    DB::table('recetas')->updateOrInsert(
        ['id_usuario_creador' => $usuarioId, 'titulo' => $r['titulo']],
        [
            'id_usuario_creador' => $usuarioId,
            'id_estado' => $estadoId,
            'id_tipo_alimento' => $tipoAlimentoId,
            'titulo' => $r['titulo'],
            'resumen' => $r['resumen'],
            'tiempo_preparacion' => $r['tiempo_preparacion'],
            'preparacion' => $r['preparacion'],
            'porciones_estimadas' => $r['porciones_estimadas'],
            'calorias' => $r['calorias'],
            'created_at' => $now,
            'updated_at' => $now
        ]
    );
}

$this->command->info('✅ Recetas insertadas con estados correctos');
        /* ============================================================
   5) MULTIMEDIA DE RECETAS - Imágenes de Unsplash
============================================================ */
$this->command->info('📸 Insertando imágenes de recetas...');

// Primero, obtener los IDs reales de las recetas por título
$multimediaData = [
    ['titulo' => 'Risotto de Champiñones Trufado', 'url' => 'https://images.unsplash.com/photo-1476124369491-c4384d8b2a2e?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Pancakes de Avena y Banano', 'url' => 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Pizza con Piña y Anchoas', 'url' => 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Pasta Carbonara Auténtica', 'url' => 'https://images.unsplash.com/photo-1612874742237-6526221588e3?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Bowl Energético de Quinoa y Frutas', 'url' => 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Salmón al Horno con Vegetales Rostizados', 'url' => 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Tacos de Pollo a la Plancha con Guacamole', 'url' => 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Ensalada Mediterránea con Atún', 'url' => 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Batido Post-Entreno de Banana y Mantequilla de Maní', 'url' => 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Wrap Integral de Pollo con Vegetales Salteados', 'url' => 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Hamburguesa de Carne con Pan Integral', 'url' => 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Tostadas de Aguacate con Huevo Pochado', 'url' => 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Pollo Salteado Estilo Asiático con Arroz', 'url' => 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?auto=format&fit=crop&w=800&q=80'],
    ['titulo' => 'Bowl de Yogurt Griego con Granola y Berries', 'url' => 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=800&q=80'],
];

foreach ($multimediaData as $media) {
    // Buscar la receta por título
    $receta = DB::table('recetas')->where('titulo', $media['titulo'])->first();
    
    if ($receta) {
        DB::table('multimedia_recetas')->updateOrInsert(
            ['id_receta' => $receta->id, 'orden' => 1],
            [
                'id_receta' => $receta->id,
                'archivo' => $media['url'],
                'tipo_archivo' => 'image',
                'orden' => 1,
                'created_at' => $now,
                'updated_at' => $now
            ]
        );
    }
}

$this->command->info('✅ Imágenes insertadas');

/* ============================================================
   6) INGREDIENTES POR RECETA
============================================================ */
$this->command->info('🥗 Vinculando ingredientes a recetas...');

$recetaIngredientes = [
    // Risotto de Champiñones Trufado
    ['receta' => 'Risotto de Champiñones Trufado', 'ingrediente' => 'Arroz integral', 'cantidad' => 300, 'unidad' => 'gramos'],
    ['receta' => 'Risotto de Champiñones Trufado', 'ingrediente' => 'Champiñones', 'cantidad' => 200, 'unidad' => 'gramos'],
    ['receta' => 'Risotto de Champiñones Trufado', 'ingrediente' => 'Cebolla', 'cantidad' => 1, 'unidad' => 'unidad'],
    ['receta' => 'Risotto de Champiñones Trufado', 'ingrediente' => 'Ajo', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Risotto de Champiñones Trufado', 'ingrediente' => 'Vino blanco', 'cantidad' => 100, 'unidad' => 'mililitros'],
    ['receta' => 'Risotto de Champiñones Trufado', 'ingrediente' => 'Queso parmesano', 'cantidad' => 50, 'unidad' => 'gramos'],

    // Pancakes de Avena y Banano
    ['receta' => 'Pancakes de Avena y Banano', 'ingrediente' => 'Avena', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Pancakes de Avena y Banano', 'ingrediente' => 'Huevo', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Pancakes de Avena y Banano', 'ingrediente' => 'Banano/Plátano', 'cantidad' => 1, 'unidad' => 'unidad'],

    // Salmón al Horno
    ['receta' => 'Salmón al Horno con Vegetales Rostizados', 'ingrediente' => 'Salmón', 'cantidad' => 300, 'unidad' => 'gramos'],
    ['receta' => 'Salmón al Horno con Vegetales Rostizados', 'ingrediente' => 'Brócoli', 'cantidad' => 200, 'unidad' => 'gramos'],
    ['receta' => 'Salmón al Horno con Vegetales Rostizados', 'ingrediente' => 'Zanahoria', 'cantidad' => 150, 'unidad' => 'gramos'],
    ['receta' => 'Salmón al Horno con Vegetales Rostizados', 'ingrediente' => 'Pimiento', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Salmón al Horno con Vegetales Rostizados', 'ingrediente' => 'Aceite de oliva', 'cantidad' => 30, 'unidad' => 'mililitros'],
    ['receta' => 'Salmón al Horno con Vegetales Rostizados', 'ingrediente' => 'Limón', 'cantidad' => 1, 'unidad' => 'unidad'],

    // Tacos de Pollo
    ['receta' => 'Tacos de Pollo a la Plancha con Guacamole', 'ingrediente' => 'Pollo (pechuga)', 'cantidad' => 400, 'unidad' => 'gramos'],
    ['receta' => 'Tacos de Pollo a la Plancha con Guacamole', 'ingrediente' => 'Aguacate', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Tacos de Pollo a la Plancha con Guacamole', 'ingrediente' => 'Tomate', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Tacos de Pollo a la Plancha con Guacamole', 'ingrediente' => 'Cebolla', 'cantidad' => 1, 'unidad' => 'unidad'],
    ['receta' => 'Tacos de Pollo a la Plancha con Guacamole', 'ingrediente' => 'Lechuga', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Tacos de Pollo a la Plancha con Guacamole', 'ingrediente' => 'Limón', 'cantidad' => 2, 'unidad' => 'unidad'],

    // Ensalada Mediterránea
    ['receta' => 'Ensalada Mediterránea con Atún', 'ingrediente' => 'Atún enlatado', 'cantidad' => 200, 'unidad' => 'gramos'],
    ['receta' => 'Ensalada Mediterránea con Atún', 'ingrediente' => 'Lechuga', 'cantidad' => 150, 'unidad' => 'gramos'],
    ['receta' => 'Ensalada Mediterránea con Atún', 'ingrediente' => 'Tomate', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Ensalada Mediterránea con Atún', 'ingrediente' => 'Cebolla', 'cantidad' => 1, 'unidad' => 'unidad'],
    ['receta' => 'Ensalada Mediterránea con Atún', 'ingrediente' => 'Pimiento', 'cantidad' => 1, 'unidad' => 'unidad'],
    ['receta' => 'Ensalada Mediterránea con Atún', 'ingrediente' => 'Queso mozzarella', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Ensalada Mediterránea con Atún', 'ingrediente' => 'Aceite de oliva', 'cantidad' => 30, 'unidad' => 'mililitros'],

    // Batido Post-Entreno
    ['receta' => 'Batido Post-Entreno de Banana y Mantequilla de Maní', 'ingrediente' => 'Banano/Plátano', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Batido Post-Entreno de Banana y Mantequilla de Maní', 'ingrediente' => 'Yogurt griego', 'cantidad' => 200, 'unidad' => 'gramos'],
    ['receta' => 'Batido Post-Entreno de Banana y Mantequilla de Maní', 'ingrediente' => 'Mantequilla de maní', 'cantidad' => 30, 'unidad' => 'gramos'],
    ['receta' => 'Batido Post-Entreno de Banana y Mantequilla de Maní', 'ingrediente' => 'Leche', 'cantidad' => 200, 'unidad' => 'mililitros'],

    // Bowl de Yogurt
    ['receta' => 'Bowl de Yogurt Griego con Granola y Berries', 'ingrediente' => 'Yogurt griego', 'cantidad' => 250, 'unidad' => 'gramos'],
    ['receta' => 'Bowl de Yogurt Griego con Granola y Berries', 'ingrediente' => 'Fresas', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Bowl de Yogurt Griego con Granola y Berries', 'ingrediente' => 'Arándanos', 'cantidad' => 50, 'unidad' => 'gramos'],
    ['receta' => 'Bowl de Yogurt Griego con Granola y Berries', 'ingrediente' => 'Avena', 'cantidad' => 50, 'unidad' => 'gramos'],
    ['receta' => 'Bowl de Yogurt Griego con Granola y Berries', 'ingrediente' => 'Almendras', 'cantidad' => 30, 'unidad' => 'gramos'],
    ['receta' => 'Bowl de Yogurt Griego con Granola y Berries', 'ingrediente' => 'Miel', 'cantidad' => 20, 'unidad' => 'gramos'],

    // Hamburguesa
    ['receta' => 'Hamburguesa de Carne con Pan Integral', 'ingrediente' => 'Carne molida', 'cantidad' => 400, 'unidad' => 'gramos'],
    ['receta' => 'Hamburguesa de Carne con Pan Integral', 'ingrediente' => 'Pan integral', 'cantidad' => 3, 'unidad' => 'unidad'],
    ['receta' => 'Hamburguesa de Carne con Pan Integral', 'ingrediente' => 'Lechuga', 'cantidad' => 50, 'unidad' => 'gramos'],
    ['receta' => 'Hamburguesa de Carne con Pan Integral', 'ingrediente' => 'Tomate', 'cantidad' => 1, 'unidad' => 'unidad'],
    ['receta' => 'Hamburguesa de Carne con Pan Integral', 'ingrediente' => 'Cebolla', 'cantidad' => 1, 'unidad' => 'unidad'],
    ['receta' => 'Hamburguesa de Carne con Pan Integral', 'ingrediente' => 'Queso mozzarella', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Hamburguesa de Carne con Pan Integral', 'ingrediente' => 'Batata/Camote', 'cantidad' => 200, 'unidad' => 'gramos'],

    // Tostadas de Aguacate
    ['receta' => 'Tostadas de Aguacate con Huevo Pochado', 'ingrediente' => 'Pan integral', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Tostadas de Aguacate con Huevo Pochado', 'ingrediente' => 'Aguacate', 'cantidad' => 1, 'unidad' => 'unidad'],
    ['receta' => 'Tostadas de Aguacate con Huevo Pochado', 'ingrediente' => 'Huevo', 'cantidad' => 2, 'unidad' => 'unidad'],
    ['receta' => 'Tostadas de Aguacate con Huevo Pochado', 'ingrediente' => 'Limón', 'cantidad' => 1, 'unidad' => 'unidad'],

    // Pollo Asiático
    ['receta' => 'Pollo Salteado Estilo Asiático con Arroz', 'ingrediente' => 'Pollo (pechuga)', 'cantidad' => 400, 'unidad' => 'gramos'],
    ['receta' => 'Pollo Salteado Estilo Asiático con Arroz', 'ingrediente' => 'Arroz integral', 'cantidad' => 200, 'unidad' => 'gramos'],
    ['receta' => 'Pollo Salteado Estilo Asiático con Arroz', 'ingrediente' => 'Brócoli', 'cantidad' => 150, 'unidad' => 'gramos'],
    ['receta' => 'Pollo Salteado Estilo Asiático con Arroz', 'ingrediente' => 'Zanahoria', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Pollo Salteado Estilo Asiático con Arroz', 'ingrediente' => 'Pimiento', 'cantidad' => 100, 'unidad' => 'gramos'],
    ['receta' => 'Pollo Salteado Estilo Asiático con Arroz', 'ingrediente' => 'Ajo', 'cantidad' => 3, 'unidad' => 'unidad'],
    ['receta' => 'Pollo Salteado Estilo Asiático con Arroz', 'ingrediente' => 'Jengibre', 'cantidad' => 20, 'unidad' => 'gramos'],
];

foreach ($recetaIngredientes as $ri) {
    // Buscar IDs
    $receta = DB::table('recetas')->where('titulo', $ri['receta'])->first();
    $ingrediente = DB::table('ingredientes')->where('descripcion', $ri['ingrediente'])->first();
    $unidad = DB::table('subdominios')
        ->where('id_dominio', $unidadMedidaDominioId)
        ->where('descripcion', $ri['unidad'])
        ->first();
    
    if ($receta && $ingrediente && $unidad) {
        DB::table('ingrediente_receta')->updateOrInsert(
            [
                'id_receta' => $receta->id,
                'id_ingrediente' => $ingrediente->id
            ],
            [
                'id_receta' => $receta->id,
                'id_ingrediente' => $ingrediente->id,
                'id_unidad_medida' => $unidad->id,
                'cantidad' => $ri['cantidad'],
                'created_at' => $now,
                'updated_at' => $now
            ]
        );
    }
}

$this->command->info('✅ Ingredientes vinculados');
        Schema::enableForeignKeyConstraints();
        
        $this->command->info('✅ Seeder ejecutado: 14 recetas idempotentes creadas');
    }

    /**
     * Sincroniza todas las secuencias de PostgreSQL con los máximos IDs actuales
     */
    private function sincronizarSecuencias()
    {
        $tablas = [
            'usuarios',
            'personas',
            'recetas',
            'ingredientes',
            'ingrediente_receta',
            'publicaciones',
            'multimedia_recetas',
            'planificador_comidas',
            'horarios_usuario',
            'lista_compras',
            'lista_compras_items',
            'seguidores',
            'usuario_favorito',
            'sesiones',
            'codigos_verificacion',
            'roles',
            'menu_items',
            'menu_item_rol',
            'alimentos_favoritos',
            'alergia_persona',
            'calificacion',
            'comentarios',
            'reacciones_publicacion',
            'notas',
            'receta_dieta',
            'pista_auditorias',
            'dominios',
            'subdominios'
        ];

        foreach ($tablas as $tabla) {
            try {
                DB::statement("SELECT setval('{$tabla}_id_seq', (SELECT COALESCE(MAX(id), 1) FROM {$tabla}), true)");
            } catch (\Exception $e) {
                // Si la secuencia no existe, continuar
                $this->command->warn("⚠️  Secuencia {$tabla}_id_seq no encontrada");
            }
        }

        $this->command->info('✅ Secuencias sincronizadas');
    }
}