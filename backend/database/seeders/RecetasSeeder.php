<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Hash;

class RecetasSeeder extends Seeder
{
    public function run()
    {
        Schema::disableForeignKeyConstraints();
        $now = Carbon::now();

        $this->command->info('🌱 Iniciando inserción de datos de prueba unificados...');

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
            ['descripcion' => 'BORRADOR'],
            ['descripcion' => 'PUBLICADA'],
            ['descripcion' => 'OCULTA'],
            ['descripcion' => 'ELIMINADA'],
            ['descripcion' => 'PENDIENTE'],
            ['descripcion' => 'RECHAZADA'],
            ['descripcion' => 'Publicado'],
            ['descripcion' => 'Borrador'],
            ['descripcion' => 'Pendiente'],
        ];

        foreach ($estados as $estado) {
            DB::table('subdominios')->updateOrInsert(
                ['id_dominio' => $estadoDominioId, 'descripcion' => $estado['descripcion']],
                ['id_dominio' => $estadoDominioId, 'descripcion' => $estado['descripcion'], 'created_at' => $now, 'updated_at' => $now]
            );
        }

        // Obtener IDs de estados existentes
        $estadoBorradorId = DB::table('subdominios')
            ->where('id_dominio', $estadoDominioId)
            ->where('descripcion', 'BORRADOR')
            ->value('id');

        $estadoPublicadaId = DB::table('subdominios')
            ->where('id_dominio', $estadoDominioId)
            ->where('descripcion', 'PUBLICADA')
            ->value('id');

        $estadoOcultaId = DB::table('subdominios')
            ->where('id_dominio', $estadoDominioId)
            ->where('descripcion', 'OCULTA')
            ->value('id');

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
            ['descripcion' => 'taza'],
            ['descripcion' => 'cucharada'],
            ['descripcion' => 'cucharadita'],
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
            ['descripcion' => 'Principal'],
            ['descripcion' => 'Cena'],
            ['descripcion' => 'Desayuno'],
            ['descripcion' => 'Almuerzo'],
            ['descripcion' => 'Bebida'],
            ['descripcion' => 'Postre'],
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

        $tipoPrincipalId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Principal')
            ->value('id');
        
        $tipoAlmuerzoId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Almuerzo')
            ->value('id');
        
        $tipoBebidaId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Bebida')
            ->value('id');

        $tipoPostreId = DB::table('subdominios')
            ->where('id_dominio', $tipoAlimentoDominioId)
            ->where('descripcion', 'Postre')
            ->value('id');

        /* ============================================================
           0.4) SUBDOMINIOS - Dietas (idempotente)
        ============================================================ */
        $dietas = [
            ['descripcion' => 'Vegana'],
            ['descripcion' => 'Energética'],
            ['descripcion' => 'Keto'],
            ['descripcion' => 'Vegetariana'],
            ['descripcion' => 'Sin Gluten'],
        ];

        foreach ($dietas as $dieta) {
            DB::table('subdominios')->updateOrInsert(
                ['id_dominio' => $dietaDominioId, 'descripcion' => $dieta['descripcion']],
                ['id_dominio' => $dietaDominioId, 'descripcion' => $dieta['descripcion'], 'created_at' => $now, 'updated_at' => $now]
            );
        }

        $dietaVeganaId = DB::table('subdominios')
            ->where('id_dominio', $dietaDominioId)
            ->where('descripcion', 'Vegana')
            ->value('id');

        $dietaEnergeticaId = DB::table('subdominios')
            ->where('id_dominio', $dietaDominioId)
            ->where('descripcion', 'Energética')
            ->value('id');

        $dietaKetoId = DB::table('subdominios')
            ->where('id_dominio', $dietaDominioId)
            ->where('descripcion', 'Keto')
            ->value('id');

        $dietaVegetarianaId = DB::table('subdominios')
            ->where('id_dominio', $dietaDominioId)
            ->where('descripcion', 'Vegetariana')
            ->value('id');

        $dietaSinGlutenId = DB::table('subdominios')
            ->where('id_dominio', $dietaDominioId)
            ->where('descripcion', 'Sin Gluten')
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

        $rolAdminId = DB::table('roles')->where('descripcion', 'Administrador')->value('id');
        $rolChefId = DB::table('roles')->where('descripcion', 'Chef / Usuario')->value('id');

        /* ============================================================
           2) PERSONAS Y USUARIOS (AMPLIADO CON 5 NUEVOS CHEFS)
        ============================================================ */
        // Persona Admin
        DB::table('personas')->updateOrInsert(
            ['id' => 1],
            ['id' => 1, 'nombres' => 'Admin', 'apellido_paterno' => 'Nutrichef', 'estado' => true, 'created_at' => $now, 'updated_at' => $now]
        );

        // Persona Usuario Prueba
        DB::table('personas')->updateOrInsert(
            ['id' => 2],
            ['id' => 2, 'nombres' => 'Usuario', 'apellido_paterno' => 'Prueba', 'estado' => true, 'created_at' => $now, 'updated_at' => $now]
        );

        // Usuario Admin
        DB::table('usuarios')->updateOrInsert(
            ['email' => 'admin@nutrichef.local'],
            [
                'id_rol' => $rolAdminId,
                'id_persona' => 1,
                'name' => 'Admin Nutrichef',
                'descripcion_perfil' => 'Administrador del sistema',
                'email' => 'admin@nutrichef.local',
                'password' => Hash::make('secret123'),
                'estado' => true,
                'created_at' => $now,
                'updated_at' => $now
            ]
        );

        // Usuarios Chefs (EXPANDIDO - Ahora 8 chefs)
        $usuariosPrueba = [
            // Chefs originales
            ['name' => 'Chef Luigi', 'email' => 'luigi@test.com', 'password' => Hash::make('pass'), 
             'descripcion_perfil' => 'Maestro de la cocina italiana auténtica. Experto en risottos, pastas frescas y salsas tradicionales.'],
            
            ['name' => 'Maria Fit', 'email' => 'maria@test.com', 'password' => Hash::make('pass'),
             'descripcion_perfil' => 'Nutricionista deportiva especializada en recetas altas en proteína para deportistas.'],
            
            ['name' => 'Pedro Panadero', 'email' => 'pedro@test.com', 'password' => Hash::make('pass'),
             'descripcion_perfil' => 'Experto en masas madre, panes artesanales y horneados caseros. La paciencia es mi ingrediente secreto.'],
            
            // NUEVOS CHEFS
            ['name' => 'Chef Sato', 'email' => 'sato@test.com', 'password' => Hash::make('pass'),
             'descripcion_perfil' => 'Chef japonés especializado en cocina nikkei y fusión asiática. Maestro del sushi y ramen casero.'],
            
            ['name' => 'Ana Veggie', 'email' => 'ana@test.com', 'password' => Hash::make('pass'),
             'descripcion_perfil' => 'Defensora de la comida plant-based. Creo recetas veganas creativas que sorprenden hasta a los carnívoros.'],
            
            ['name' => 'Carlos Keto', 'email' => 'carlos@test.com', 'password' => Hash::make('pass'),
             'descripcion_perfil' => 'Especialista en dieta cetogénica y low-carb. Transformo clásicos en versiones keto-friendly sin perder sabor.'],
            
            ['name' => 'Sofia Dulce', 'email' => 'sofia@test.com', 'password' => Hash::make('pass'),
             'descripcion_perfil' => 'Repostera profesional apasionada por los postres saludables con ingredientes naturales y sin azúcar refinada.'],
            
            ['name' => 'Diego Parrilla', 'email' => 'diego@test.com', 'password' => Hash::make('pass'),
             'descripcion_perfil' => 'Rey de las brasas y ahumados. Especialista en BBQ, carnes a la parrilla y marinados secretos.'],
        ];

        foreach ($usuariosPrueba as $u) {
            DB::table('usuarios')->updateOrInsert(
                ['email' => $u['email']],
                array_merge($u, [
                    'id_rol' => $rolChefId,
                    'id_persona' => 2,
                    'estado' => true,
                    'created_at' => $now,
                    'updated_at' => $now
                ])
            );
        }

        // Obtener IDs reales de usuarios
        $usuarioAdminId = DB::table('usuarios')->where('email', 'admin@nutrichef.local')->value('id');
        $usuarioLuigiId = DB::table('usuarios')->where('email', 'luigi@test.com')->value('id');
        $usuarioMariaId = DB::table('usuarios')->where('email', 'maria@test.com')->value('id');
        $usuarioPedroId = DB::table('usuarios')->where('email', 'pedro@test.com')->value('id');
        $usuarioSatoId = DB::table('usuarios')->where('email', 'sato@test.com')->value('id');
        $usuarioAnaId = DB::table('usuarios')->where('email', 'ana@test.com')->value('id');
        $usuarioCarlosId = DB::table('usuarios')->where('email', 'carlos@test.com')->value('id');
        $usuarioSofiaId = DB::table('usuarios')->where('email', 'sofia@test.com')->value('id');
        $usuarioDiegoId = DB::table('usuarios')->where('email', 'diego@test.com')->value('id');

        /* ============================================================
           3) INGREDIENTES BASE - Idempotente por descripción (EXPANDIDO)
        ============================================================ */
        $ingredientesBase = [
            // Proteínas
            'Pollo (pechuga)', 'Pechuga de pollo', 'Huevo', 'Salmón', 'Carne molida', 'Atún enlatado', 'Atún',
            'Pavo molido', 'Carne de res', 'Tocino', 'Cerdo', 'Camarones', 'Tilapia',
            
            // Lácteos y alternativos
            'Queso mozzarella', 'Queso parmesano', 'Queso ricotta', 'Queso cheddar', 'Queso crema',
            'Yogurt griego', 'Yogur natural', 'Leche', 'Leche de almendra', 'Leche de coco', 'Crema de leche',
            
            // Granos y harinas
            'Arroz integral', 'Arroz blanco', 'Pasta integral', 'Avena', 'Pan integral', 'Quinoa', 
            'Harina de almendra', 'Harina de coco', 'Fideos de arroz', 'Fideos soba',
            
            // Vegetales
            'Batata/Camote', 'Camote', 'Brócoli', 'Espinaca', 'Tomate', 'Cebolla', 'Ajo', 
            'Zanahoria', 'Pimiento', 'Pimiento rojo', 'Pimiento verde', 'Champiñones', 'Lechuga',
            'Calabacín', 'Berenjena', 'Papa', 'Pepino', 'Coliflor', 'Apio', 'Jengibre',
            'Kale', 'Rúcula', 'Tomate cherry',
            
            // Frutas
            'Banano/Plátano', 'Plátano', 'Manzana', 'Fresas', 'Arándanos', 'Aguacate',
            'Limón', 'Mango', 'Piña', 'Kiwi', 'Coco', 'Frambuesas',
            
            // Legumbres y frutos secos
            'Lentejas', 'Garbanzos', 'Frijoles negros', 'Mantequilla de maní', 'Nueces', 
            'Almendras', 'Anacardos', 'Pistachos', 'Semillas de chía', 'Semillas de girasol',
            
            // Condimentos y otros
            'Aceite de oliva', 'Aceite de coco', 'Aceite de sésamo', 'Salsa de soja', 'Vinagre balsámico',
            'Cilantro', 'Perejil', 'Albahaca', 'Orégano', 'Comino', 'Miel', 'Sal', 'Pimienta', 
            'Caldo de vegetales', 'Caldo de pollo', 'Vino blanco', 'Cacao en polvo', 'Stevia',
            'Wasabi', 'Alga nori', 'Tofu', 'Tempeh', 'Levadura nutricional'
        ];

        foreach ($ingredientesBase as $ing) {
            DB::table('ingredientes')->updateOrInsert(
                ['descripcion' => $ing],
                ['descripcion' => $ing, 'id_alergeno' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }

        /* ============================================================
           4) RECETAS - Combinadas y EXPANDIDAS con nuevos chefs
        ============================================================ */
        $recetasUnificadas = [
            // ===== RECETAS DEL ADMIN (Mantener las originales) =====
            [
                'email_usuario' => 'admin@nutrichef.local',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Principal',
                'titulo' => 'Ensalada de Quinoa Vegana',
                'resumen' => 'Ensalada fresca con quinoa y vegetales.',
                'tiempo_preparacion' => 20,
                'preparacion' => '1. Cocinar la quinoa. 2. Mezclar con vegetales. 3. Servir fría.',
                'porciones_estimadas' => 2,
                'calorias' => null
            ],
            [
                'email_usuario' => 'admin@nutrichef.local',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Principal',
                'titulo' => 'Pollo a la Plancha con Verduras',
                'resumen' => 'Pollo marinado y verduras salteadas.',
                'tiempo_preparacion' => 30,
                'preparacion' => '1. Sazonar pollo. 2. Cocinar. 3. Saltear verduras.',
                'porciones_estimadas' => 2,
                'calorias' => null
            ],
            [
                'email_usuario' => 'admin@nutrichef.local',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Bebida',
                'titulo' => 'Smoothie Energético',
                'resumen' => 'Batido nutritivo y refrescante.',
                'tiempo_preparacion' => 5,
                'preparacion' => '1. Licuar todos los ingredientes. 2. Servir frío.',
                'porciones_estimadas' => 1,
                'calorias' => null
            ],

            // ===== RECETAS DE CHEF LUIGI (Italiano) =====
            [
                'email_usuario' => 'luigi@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Risotto de Champiñones Trufado',
                'resumen' => 'Un risotto cremoso con aceite de trufa blanca, ideal para cenas elegantes.',
                'tiempo_preparacion' => 45,
                'preparacion' => "1. Sofreír cebolla y ajo.\n2. Tostar el arroz arborio.\n3. Agregar vino blanco.\n4. Incorporar caldo poco a poco.\n5. Terminar con mantequilla y parmesano.",
                'porciones_estimadas' => 4,
                'calorias' => 380
            ],
            [
                'email_usuario' => 'luigi@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Pasta Carbonara Auténtica',
                'resumen' => 'La verdadera receta italiana sin crema de leche.',
                'tiempo_preparacion' => 20,
                'preparacion' => "1. Cocer pasta.\n2. Mezclar yemas y pecorino.\n3. Dorar guanciale.\n4. Emulsionar todo fuera del fuego.",
                'porciones_estimadas' => 2,
                'calorias' => 420
            ],
            [
                'email_usuario' => 'luigi@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Lasaña Boloñesa Tradicional',
                'resumen' => 'Capas de pasta con salsa boloñesa y bechamel casera.',
                'tiempo_preparacion' => 90,
                'preparacion' => "1. Preparar salsa boloñesa.\n2. Hacer bechamel.\n3. Armar capas.\n4. Hornear 40 minutos.",
                'porciones_estimadas' => 6,
                'calorias' => 485
            ],

            // ===== RECETAS DE MARIA FIT (Fitness) =====
            [
                'email_usuario' => 'maria@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Desayuno',
                'titulo' => 'Pancakes de Avena y Banano',
                'resumen' => 'Sin harina ni azúcar añadida, perfectos para antes de entrenar.',
                'tiempo_preparacion' => 15,
                'preparacion' => "1. Licuar avena, huevo y banano.\n2. Calentar sartén.\n3. Cocinar vuelta y vuelta.",
                'porciones_estimadas' => 1,
                'calorias' => 320
            ],
            [
                'email_usuario' => 'maria@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Desayuno',
                'titulo' => 'Bowl Energético de Quinoa y Frutas',
                'resumen' => 'Desayuno completo rico en proteínas y antioxidantes.',
                'tiempo_preparacion' => 20,
                'preparacion' => "1. Cocer quinoa en leche.\n2. Servir en bowl.\n3. Cubrir con frutas frescas.\n4. Agregar frutos secos.",
                'porciones_estimadas' => 2,
                'calorias' => 385
            ],
            [
                'email_usuario' => 'maria@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Bebida',
                'titulo' => 'Batido Post-Entreno Proteico',
                'resumen' => 'Recuperación muscular con proteína natural.',
                'tiempo_preparacion' => 5,
                'preparacion' => "1. Licuar banano, yogurt griego, mantequilla de maní y leche.\n2. Servir frío.",
                'porciones_estimadas' => 1,
                'calorias' => 420
            ],

            // ===== RECETAS DE PEDRO PANADERO =====
            [
                'email_usuario' => 'pedro@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Pizza con Piña y Anchoas',
                'resumen' => 'Una combinación controversial pero deliciosa.',
                'tiempo_preparacion' => 30,
                'preparacion' => "1. Estirar masa.\n2. Poner salsa y queso.\n3. Agregar piña y anchoas.\n4. Hornear.",
                'porciones_estimadas' => 2,
                'calorias' => 450
            ],
            [
                'email_usuario' => 'pedro@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Desayuno',
                'titulo' => 'Pan Integral con Semillas',
                'resumen' => 'Pan artesanal con masa madre y semillas.',
                'tiempo_preparacion' => 180,
                'preparacion' => "1. Preparar masa madre.\n2. Amasar con semillas.\n3. Fermentar 2 horas.\n4. Hornear.",
                'porciones_estimadas' => 8,
                'calorias' => 220
            ],

            // ===== RECETAS DE CHEF SATO (Japonés/Asiático) =====
            [
                'email_usuario' => 'sato@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Ramen Casero con Caldo Tonkotsu',
                'resumen' => 'Ramen auténtico con caldo de cerdo cremoso.',
                'tiempo_preparacion' => 240,
                'preparacion' => "1. Hervir huesos de cerdo 4 horas.\n2. Cocer fideos.\n3. Marinar huevo.\n4. Ensamblar con vegetales.",
                'porciones_estimadas' => 4,
                'calorias' => 520
            ],
            [
                'email_usuario' => 'sato@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Sushi Roll California',
                'resumen' => 'Roll clásico con surimi, aguacate y pepino.',
                'tiempo_preparacion' => 35,
                'preparacion' => "1. Cocer arroz para sushi.\n2. Preparar ingredientes.\n3. Armar rolls.\n4. Cortar y servir con wasabi.",
                'porciones_estimadas' => 3,
                'calorias' => 380
            ],
            [
                'email_usuario' => 'sato@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Pad Thai de Camarones',
                'resumen' => 'Fideos salteados tailandeses con salsa de tamarindo.',
                'tiempo_preparacion' => 25,
                'preparacion' => "1. Hidratar fideos de arroz.\n2. Saltear camarones.\n3. Agregar salsa y huevo.\n4. Servir con maní.",
                'porciones_estimadas' => 2,
                'calorias' => 445
            ],
            [
                'email_usuario' => 'sato@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Gyozas de Pollo y Vegetales',
                'resumen' => 'Dumplings japoneses rellenos al vapor.',
                'tiempo_preparacion' => 50,
                'preparacion' => "1. Preparar relleno de pollo picado.\n2. Rellenar masa.\n3. Cocinar al vapor.\n4. Dorar en sartén.",
                'porciones_estimadas' => 4,
                'calorias' => 320
            ],

            // ===== RECETAS DE ANA VEGGIE (Vegana) =====
            [
                'email_usuario' => 'ana@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Hamburguesa de Lentejas y Quinoa',
                'resumen' => 'Hamburguesa vegana jugosa y llena de proteína.',
                'tiempo_preparacion' => 40,
                'preparacion' => "1. Cocer lentejas y quinoa.\n2. Triturar parcialmente.\n3. Formar medallones.\n4. Cocinar a la plancha.",
                'porciones_estimadas' => 4,
                'calorias' => 280
            ],
            [
                'email_usuario' => 'ana@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Curry de Garbanzos y Espinacas',
                'resumen' => 'Curry cremoso sin lácteos, especiado y reconfortante.',
                'tiempo_preparacion' => 30,
                'preparacion' => "1. Saltear cebolla y especias.\n2. Agregar garbanzos y leche de coco.\n3. Incorporar espinacas.\n4. Servir con arroz.",
                'porciones_estimadas' => 4,
                'calorias' => 350
            ],
            [
                'email_usuario' => 'ana@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Desayuno',
                'titulo' => 'Tofu Revuelto con Vegetales',
                'resumen' => 'Alternativa vegana a los huevos revueltos.',
                'tiempo_preparacion' => 15,
                'preparacion' => "1. Desmenuzar tofu.\n2. Saltear con cúrcuma.\n3. Agregar pimiento y espinaca.\n4. Sazonar y servir.",
                'porciones_estimadas' => 2,
                'calorias' => 220
            ],
            [
                'email_usuario' => 'ana@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Postre',
                'titulo' => 'Mousse de Chocolate Vegano',
                'resumen' => 'Postre cremoso hecho con aguacate y cacao.',
                'tiempo_preparacion' => 120,
                'preparacion' => "1. Licuar aguacate, cacao, leche vegetal.\n2. Endulzar con dátiles.\n3. Refrigerar 2 horas.\n4. Servir frío.",
                'porciones_estimadas' => 4,
                'calorias' => 180
            ],

            // ===== RECETAS DE CARLOS KETO =====
            [
                'email_usuario' => 'carlos@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Desayuno',
                'titulo' => 'Huevos Benedictinos Keto',
                'resumen' => 'Desayuno bajo en carbos con salsa holandesa.',
                'tiempo_preparacion' => 20,
                'preparacion' => "1. Pochear huevos.\n2. Preparar salsa holandesa.\n3. Tostar pan keto.\n4. Ensamblar con tocino.",
                'porciones_estimadas' => 2,
                'calorias' => 520
            ],
            [
                'email_usuario' => 'carlos@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Pizza Keto con Base de Coliflor',
                'resumen' => 'Pizza sin harinas con masa de coliflor crujiente.',
                'tiempo_preparacion' => 45,
                'preparacion' => "1. Triturar coliflor.\n2. Mezclar con huevo y queso.\n3. Hornear base.\n4. Agregar toppings y gratinar.",
                'porciones_estimadas' => 2,
                'calorias' => 380
            ],
            [
                'email_usuario' => 'carlos@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Salmón con Mantequilla de Hierbas',
                'resumen' => 'Salmón jugoso bañado en mantequilla aromática.',
                'tiempo_preparacion' => 25,
                'preparacion' => "1. Sellar salmón.\n2. Preparar mantequilla con perejil y ajo.\n3. Hornear.\n4. Servir con brócoli.",
                'porciones_estimadas' => 2,
                'calorias' => 480
            ],
            [
                'email_usuario' => 'carlos@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Postre',
                'titulo' => 'Fat Bombs de Chocolate y Coco',
                'resumen' => 'Bombas energéticas altas en grasas saludables.',
                'tiempo_preparacion' => 65,
                'preparacion' => "1. Mezclar aceite de coco, cacao y stevia.\n2. Verter en moldes.\n3. Congelar 1 hora.\n4. Conservar en frío.",
                'porciones_estimadas' => 12,
                'calorias' => 95
            ],

            // ===== RECETAS DE SOFIA DULCE (Repostería Saludable) =====
            [
                'email_usuario' => 'sofia@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Postre',
                'titulo' => 'Brownie de Batata y Cacao',
                'resumen' => 'Brownie húmedo sin harina ni azúcar refinada.',
                'tiempo_preparacion' => 50,
                'preparacion' => "1. Hornear batata.\n2. Triturar con cacao y huevos.\n3. Agregar frutos secos.\n4. Hornear 30 minutos.",
                'porciones_estimadas' => 8,
                'calorias' => 185
            ],
            [
                'email_usuario' => 'sofia@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Postre',
                'titulo' => 'Cheesecake de Arándanos Sin Horno',
                'resumen' => 'Cheesecake cremoso con base de dátiles y nueces.',
                'tiempo_preparacion' => 180,
                'preparacion' => "1. Triturar base de nueces.\n2. Mezclar queso crema con yogurt.\n3. Cubrir con arándanos.\n4. Refrigerar 3 horas.",
                'porciones_estimadas' => 10,
                'calorias' => 210
            ],
            [
                'email_usuario' => 'sofia@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Postre',
                'titulo' => 'Muffins de Banano y Avena',
                'resumen' => 'Muffins esponjosos endulzados naturalmente.',
                'tiempo_preparacion' => 35,
                'preparacion' => "1. Triturar banano maduro.\n2. Mezclar con avena y huevo.\n3. Distribuir en moldes.\n4. Hornear 20 minutos.",
                'porciones_estimadas' => 12,
                'calorias' => 140
            ],
            [
                'email_usuario' => 'sofia@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Postre',
                'titulo' => 'Helado de Coco y Mango Sin Azúcar',
                'resumen' => 'Helado cremoso vegano de 2 ingredientes.',
                'tiempo_preparacion' => 240,
                'preparacion' => "1. Congelar mango en cubos.\n2. Licuar con leche de coco.\n3. Congelar 4 horas.\n4. Servir como gelato.",
                'porciones_estimadas' => 4,
                'calorias' => 120
            ],

            // ===== RECETAS DE DIEGO PARRILLA (BBQ y Carnes) =====
            [
                'email_usuario' => 'diego@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Costillas BBQ Ahumadas',
                'resumen' => 'Costillas de cerdo con marinado especial y glaseado.',
                'tiempo_preparacion' => 300,
                'preparacion' => "1. Marinar costillas 2 horas.\n2. Ahumar a fuego lento 4 horas.\n3. Glasear con salsa BBQ.\n4. Terminar en parrilla.",
                'porciones_estimadas' => 4,
                'calorias' => 620
            ],
            [
                'email_usuario' => 'diego@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Brisket de Res a la Texana',
                'resumen' => 'Pecho de res ahumado durante horas hasta perfección.',
                'tiempo_preparacion' => 480,
                'preparacion' => "1. Frotar especias dry rub.\n2. Ahumar 8 horas.\n3. Envolver en papel.\n4. Reposar y cortar.",
                'porciones_estimadas' => 8,
                'calorias' => 550
            ],
            [
                'email_usuario' => 'diego@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Almuerzo',
                'titulo' => 'Pollo a la Brasa Peruano',
                'resumen' => 'Pollo marinado con especias peruanas.',
                'tiempo_preparacion' => 90,
                'preparacion' => "1. Marinar pollo con ají panca.\n2. Cocinar en brasa rotativa.\n3. Servir con papas.\n4. Acompañar con salsas.",
                'porciones_estimadas' => 4,
                'calorias' => 480
            ],
            [
                'email_usuario' => 'diego@test.com',
                'estado' => 'Publicado',
                'tipo_alimento' => 'Cena',
                'titulo' => 'Chorizo Argentino a la Parrilla',
                'resumen' => 'Chorizos criollos con chimichurri casero.',
                'tiempo_preparacion' => 25,
                'preparacion' => "1. Preparar chimichurri.\n2. Asar chorizos a la parrilla.\n3. Cocinar hasta dorar.\n4. Servir con pan.",
                'porciones_estimadas' => 4,
                'calorias' => 520
            ],
        ];

        foreach ($recetasUnificadas as $r) {
            $usuarioId = DB::table('usuarios')->where('email', $r['email_usuario'])->value('id');
            
            $estadoId = DB::table('subdominios')
                ->where('id_dominio', $estadoDominioId)
                ->whereRaw('UPPER(descripcion) = ?', [strtoupper($r['estado'])])
                ->value('id');
            
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

        $this->command->info('✅ Recetas insertadas correctamente - Total: ' . count($recetasUnificadas));

        /* ============================================================
           5) RECETA - DIETA (Expandido)
        ============================================================ */
        $recetaDietas = [
            // Veganas
            ['titulo' => 'Ensalada de Quinoa Vegana', 'dieta' => 'Vegana'],
            ['titulo' => 'Hamburguesa de Lentejas y Quinoa', 'dieta' => 'Vegana'],
            ['titulo' => 'Curry de Garbanzos y Espinacas', 'dieta' => 'Vegana'],
            ['titulo' => 'Tofu Revuelto con Vegetales', 'dieta' => 'Vegana'],
            ['titulo' => 'Mousse de Chocolate Vegano', 'dieta' => 'Vegana'],
            
            // Keto
            ['titulo' => 'Huevos Benedictinos Keto', 'dieta' => 'Keto'],
            ['titulo' => 'Pizza Keto con Base de Coliflor', 'dieta' => 'Keto'],
            ['titulo' => 'Salmón con Mantequilla de Hierbas', 'dieta' => 'Keto'],
            ['titulo' => 'Fat Bombs de Chocolate y Coco', 'dieta' => 'Keto'],
            
            // Energéticas
            ['titulo' => 'Smoothie Energético', 'dieta' => 'Energética'],
            ['titulo' => 'Bowl Energético de Quinoa y Frutas', 'dieta' => 'Energética'],
            ['titulo' => 'Batido Post-Entreno Proteico', 'dieta' => 'Energética'],
            ['titulo' => 'Pancakes de Avena y Banano', 'dieta' => 'Energética'],
        ];

        foreach ($recetaDietas as $rd) {
            $receta = DB::table('recetas')->where('titulo', $rd['titulo'])->first();
            $dieta = DB::table('subdominios')
                ->where('id_dominio', $dietaDominioId)
                ->where('descripcion', $rd['dieta'])
                ->first();
            
            if ($receta && $dieta) {
                DB::table('receta_dieta')->updateOrInsert(
                    ['id_receta' => $receta->id, 'id_dieta' => $dieta->id],
                    ['id_receta' => $receta->id, 'id_dieta' => $dieta->id, 'created_at' => $now]
                );
            }
        }

        $this->command->info('✅ Relaciones receta-dieta creadas');

        /* ============================================================
           6) MULTIMEDIA DE RECETAS (Expandido con nuevas recetas)
        ============================================================ */
        $multimediaCompleta = [
            // Recetas Admin
            ['titulo' => 'Ensalada de Quinoa Vegana', 'url' => 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?w=800'],
            ['titulo' => 'Pollo a la Plancha con Verduras', 'url' => 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800'],
            ['titulo' => 'Smoothie Energético', 'url' => 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=800'],
            
            // Chef Luigi
            ['titulo' => 'Risotto de Champiñones Trufado', 'url' => 'https://images.unsplash.com/photo-1476124369491-c4384d8b2a2e?w=800'],
            ['titulo' => 'Pasta Carbonara Auténtica', 'url' => 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800'],
            ['titulo' => 'Lasaña Boloñesa Tradicional', 'url' => 'https://images.unsplash.com/photo-1574868291534-18cd5700fa9e?w=800'],
            
            // Maria Fit
            ['titulo' => 'Pancakes de Avena y Banano', 'url' => 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=800'],
            ['titulo' => 'Bowl Energético de Quinoa y Frutas', 'url' => 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?w=800'],
            ['titulo' => 'Batido Post-Entreno Proteico', 'url' => 'https://images.unsplash.com/photo-1553530666-cc113c04ef71?w=800'],
            
            // Pedro Panadero
            ['titulo' => 'Pizza con Piña y Anchoas', 'url' => 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800'],
            ['titulo' => 'Pan Integral con Semillas', 'url' => 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800'],
            
            // Chef Sato
            ['titulo' => 'Ramen Casero con Caldo Tonkotsu', 'url' => 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800'],
            ['titulo' => 'Sushi Roll California', 'url' => 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800'],
            ['titulo' => 'Pad Thai de Camarones', 'url' => 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=800'],
            ['titulo' => 'Gyozas de Pollo y Vegetales', 'url' => 'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=800'],
            
            // Ana Veggie
            ['titulo' => 'Hamburguesa de Lentejas y Quinoa', 'url' => 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=800'],
            ['titulo' => 'Curry de Garbanzos y Espinacas', 'url' => 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800'],
            ['titulo' => 'Tofu Revuelto con Vegetales', 'url' => 'https://images.unsplash.com/photo-1546549032-9571cd6b27df?w=800'],
            ['titulo' => 'Mousse de Chocolate Vegano', 'url' => 'https://images.unsplash.com/photo-1541599468348-e96984315921?w=800'],
            
            // Carlos Keto
            ['titulo' => 'Huevos Benedictinos Keto', 'url' => 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=800'],
            ['titulo' => 'Pizza Keto con Base de Coliflor', 'url' => 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800'],
            ['titulo' => 'Salmón con Mantequilla de Hierbas', 'url' => 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800'],
            ['titulo' => 'Fat Bombs de Chocolate y Coco', 'url' => 'https://images.unsplash.com/photo-1481391032119-d89fee407e44?w=800'],
            
            // Sofia Dulce
            ['titulo' => 'Brownie de Batata y Cacao', 'url' => 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=800'],
            ['titulo' => 'Cheesecake de Arándanos Sin Horno', 'url' => 'https://images.unsplash.com/photo-1533134242116-8bbf7adce23c?w=800'],
            ['titulo' => 'Muffins de Banano y Avena', 'url' => 'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=800'],
            ['titulo' => 'Helado de Coco y Mango Sin Azúcar', 'url' => 'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=800'],
            
            // Diego Parrilla
            ['titulo' => 'Costillas BBQ Ahumadas', 'url' => 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=800'],
            ['titulo' => 'Brisket de Res a la Texana', 'url' => 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800'],
            ['titulo' => 'Pollo a la Brasa Peruano', 'url' => 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=800'],
            ['titulo' => 'Chorizo Argentino a la Parrilla', 'url' => 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=800'],
        ];

        foreach ($multimediaCompleta as $media) {
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
           7) SEGUIDORES (Generar relaciones entre chefs)
        ============================================================ */
        $usuariosIds = DB::table('usuarios')->where('id_rol', $rolChefId)->pluck('id')->toArray();
        
        foreach ($usuariosIds as $followerId) {
            foreach ($usuariosIds as $followedId) {
                if ($followerId != $followedId && rand(0, 100) < 60) { // 60% de probabilidad
                    DB::table('seguidores')->updateOrInsert(
                        ['id_usuario' => $followerId, 'id_usuario_seguido' => $followedId],
                        ['created_at' => $now, 'updated_at' => $now]
                    );
                }
            }
        }
        
        $this->command->info('✅ Seguidores generados aleatoriamente');
        
        Schema::enableForeignKeyConstraints();
        
        $this->command->info('🎉 Seeder unificado ejecutado exitosamente');
        $this->command->info('📊 Total de chefs: 8');
        $this->command->info('📊 Total de recetas: ' . count($recetasUnificadas));
    }

    private function sincronizarSecuencias()
    {
        $tablas = [
            'usuarios', 'personas', 'recetas', 'ingredientes', 'ingrediente_receta',
            'publicaciones', 'multimedia_recetas', 'planificador_comidas', 'horarios_usuario',
            'lista_compras', 'lista_compras_items', 'seguidores', 'usuario_favorito',
            'sesiones', 'codigos_verificacion', 'roles', 'menu_items', 'menu_item_rol',
            'alimentos_favoritos', 'alergia_persona', 'calificacion', 'comentarios',
            'reacciones_publicacion', 'notas', 'receta_dieta', 'pista_auditorias',
            'dominios', 'subdominios'
        ];

        foreach ($tablas as $tabla) {
            try {
                DB::statement("SELECT setval('{$tabla}_id_seq', (SELECT COALESCE(MAX(id), 1) FROM {$tabla}), true)");
            } catch (\Exception $e) {
                $this->command->warn("⚠️  Secuencia {$tabla}_id_seq no encontrada");
            }
        }

        $this->command->info('✅ Secuencias sincronizadas');
    }
}