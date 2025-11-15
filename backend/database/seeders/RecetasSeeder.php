<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class RecetasSeeder extends Seeder
{
    public function run()
    {
        $now = Carbon::now();

        /* ============================================================
           0) ROLES
        ============================================================ */
        DB::table('roles')->insertOrIgnore([
            [
                'id' => 1,
                'descripcion' => 'Administrador',
                'estado' => true,
                'created_at' => $now,
                'updated_at' => $now
            ]
        ]);

        /* ============================================================
           0.1) PERSONAS
        ============================================================ */
        DB::table('personas')->insertOrIgnore([
            [
                'id' => 1,
                'nombres' => 'Admin',
                'apellido_paterno' => 'Nutrichef',
                'estado' => true,
                'created_at' => $now,
                'updated_at' => $now
            ]
        ]);

        /* ============================================================
           0.2) USUARIO ADMIN
        ============================================================ */
        DB::table('usuarios')->insertOrIgnore([
            [
                'id' => 1,
                'id_rol' => 1,
                'id_persona' => 1,
                'name' => 'Admin Nutrichef',
                'descripcion_perfil' => 'Administrador del sistema',
                'email' => 'admin@nutrichef.local',
                'password' => Hash::make('secret123'),
                'estado' => true,
                'created_at' => $now,
                'updated_at' => $now
            ]
        ]);

        /* ============================================================
           1) DOMINIOS (ESTADO, TIPO_ALIMENTO, UNIDAD_MEDIDA, DIETA)
        ============================================================ */

        DB::table('dominios')->insertOrIgnore([
            ['id' => 1, 'descripcion' => 'ESTADO', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 2, 'descripcion' => 'TIPO_ALIMENTO', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 3, 'descripcion' => 'UNIDAD_MEDIDA', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 4, 'descripcion' => 'DIETA', 'created_at' => $now, 'updated_at' => $now],
        ]);

        /* ============================================================
           1.1) SUBDOMINIOS – ESTADOS
        ============================================================ */
        DB::table('subdominios')->insertOrIgnore([
            ['id' => 1, 'id_dominio' => 1, 'descripcion' => 'Publicado', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 2, 'id_dominio' => 1, 'descripcion' => 'Borrador',  'created_at' => $now, 'updated_at' => $now],
        ]);

        /* ============================================================
           1.2) SUBDOMINIOS – TIPO ALIMENTO
        ============================================================ */
        DB::table('subdominios')->insertOrIgnore([
            ['id' => 3, 'id_dominio' => 2, 'descripcion' => 'Principal', 'created_at' => $now, 'updated_at' => $now],
        ]);

        /* ============================================================
           1.3) SUBDOMINIOS – UNIDAD MEDIDA
        ============================================================ */
        DB::table('subdominios')->insertOrIgnore([
            ['id' => 4, 'id_dominio' => 3, 'descripcion' => 'gramos', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 5, 'id_dominio' => 3, 'descripcion' => 'unidad', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 6, 'id_dominio' => 3, 'descripcion' => 'mililitros', 'created_at' => $now, 'updated_at' => $now],
        ]);

        /* ============================================================
           1.4) SUBDOMINIOS – DIETAS
        ============================================================ */
        DB::table('subdominios')->insertOrIgnore([
            ['id' => 7, 'id_dominio' => 4, 'descripcion' => 'Vegana', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 8, 'id_dominio' => 4, 'descripcion' => 'Energética', 'created_at' => $now, 'updated_at' => $now],
        ]);

        /* ============================================================
           2) INGREDIENTES
        ============================================================ */
        DB::table('ingredientes')->insertOrIgnore([
            ['id'=>1, 'descripcion'=>'Quinoa'],
            ['id'=>2, 'descripcion'=>'Tomate'],
            ['id'=>3, 'descripcion'=>'Pepino'],
            ['id'=>4, 'descripcion'=>'Aceite de oliva'],
            ['id'=>5, 'descripcion'=>'Sal'],
            ['id'=>6, 'descripcion'=>'Pimienta'],
            ['id'=>7, 'descripcion'=>'Pechuga de pollo'],
            ['id'=>8, 'descripcion'=>'Zanahoria'],
            ['id'=>9, 'descripcion'=>'Brócoli'],
            ['id'=>10,'descripcion'=>'Plátano'],
            ['id'=>11,'descripcion'=>'Fresas'],
            ['id'=>12,'descripcion'=>'Leche de almendra'],
            ['id'=>13,'descripcion'=>'Avena'],
            ['id'=>14,'descripcion'=>'Miel'],
            ['id'=>15,'descripcion'=>'Yogur natural'],
            ['id'=>16,'descripcion'=>'Ajo'],
            ['id'=>17,'descripcion'=>'Cebolla'],
            ['id'=>18,'descripcion'=>'Perejil'],
            ['id'=>19,'descripcion'=>'Limón'],
            ['id'=>20,'descripcion'=>'Pimiento rojo'],
            ['id'=>21,'descripcion'=>'Espinaca'],
            ['id'=>22,'descripcion'=>'Aguacate'],
            ['id'=>23,'descripcion'=>'Arroz integral'],
            ['id'=>24,'descripcion'=>'Lentejas'],
            ['id'=>25,'descripcion'=>'Garbanzos'],
            ['id'=>26,'descripcion'=>'Salmón'],
            ['id'=>27,'descripcion'=>'Huevo'],
            ['id'=>28,'descripcion'=>'Atún'],
            ['id'=>29,'descripcion'=>'Papa'],
            ['id'=>30,'descripcion'=>'Camote'],
            ['id'=>31,'descripcion'=>'Almendras'],
            ['id'=>32,'descripcion'=>'Nueces'],
            ['id'=>33,'descripcion'=>'Chía'],
            ['id'=>34,'descripcion'=>'Jengibre'],
            ['id'=>35,'descripcion'=>'Cilantro'],
            ['id'=>36,'descripcion'=>'Pimiento verde'],
            ['id'=>37,'descripcion'=>'Calabacín'],
            ['id'=>38,'descripcion'=>'Berenjena'],
            ['id'=>39,'descripcion'=>'Mango'],
            ['id'=>40,'descripcion'=>'Piña'],
            ['id'=>41,'descripcion'=>'Kiwi'],
            ['id'=>42,'descripcion'=>'Arándanos'],
            ['id'=>43,'descripcion'=>'Pasta integral'],
            ['id'=>44,'descripcion'=>'Queso ricotta'],
            ['id'=>45,'descripcion'=>'Pavo molido'],
            ['id'=>46,'descripcion'=>'Caldo de vegetales'],
            ['id'=>47,'descripcion'=>'Vino blanco'],
            ['id'=>48,'descripcion'=>'Albahaca'],
            ['id'=>49,'descripcion'=>'Orégano'],
            ['id'=>50,'descripcion'=>'Comino'],
        ]);

        /* ============================================================
           3) RECETAS
        ============================================================ */
        DB::table('recetas')->insertOrIgnore([
            // RECETAS ORIGINALES (1-4)
            [
                'id'=>1,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Ensalada de Quinoa Vegana',
                'resumen'=>'Ensalada fresca con quinoa y vegetales.',
                'tiempo_preparacion'=>20,
                'preparacion'=>'1. Cocinar la quinoa. 2. Mezclar con vegetales. 3. Servir fría.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>2,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Pollo a la Plancha con Verduras',
                'resumen'=>'Pollo marinado y verduras salteadas.',
                'tiempo_preparacion'=>30,
                'preparacion'=>'1. Sazonar pollo. 2. Cocinar. 3. Saltear verduras.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>3,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Smoothie Energético',
                'resumen'=>'Batido nutritivo y refrescante.',
                'tiempo_preparacion'=>5,
                'preparacion'=>'1. Licuar todos los ingredientes. 2. Servir frío.',
                'porciones_estimadas'=>1,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>4,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Sopa de Verduras',
                'resumen'=>'Sopa ligera y reconfortante.',
                'tiempo_preparacion'=>40,
                'preparacion'=>'1. Cortar verduras. 2. Cocer. 3. Condimentar.',
                'porciones_estimadas'=>4,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            
            // NUEVAS RECETAS (5-24)
            [
                'id'=>5,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Bowl de Arroz Integral con Salmón',
                'resumen'=>'Bowl nutritivo con salmón y vegetales frescos.',
                'tiempo_preparacion'=>35,
                'preparacion'=>'1. Cocinar arroz integral. 2. Hornear salmón con limón. 3. Cortar aguacate y vegetales. 4. Ensamblar el bowl.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>6,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Ensalada de Lentejas',
                'resumen'=>'Ensalada proteica con lentejas y vegetales.',
                'tiempo_preparacion'=>25,
                'preparacion'=>'1. Cocer lentejas. 2. Picar tomate, pepino y cebolla. 3. Mezclar con vinagreta. 4. Refrigerar.',
                'porciones_estimadas'=>3,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>7,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Tacos de Garbanzos Especiados',
                'resumen'=>'Tacos veganos con garbanzos crujientes.',
                'tiempo_preparacion'=>20,
                'preparacion'=>'1. Tostar garbanzos con especias. 2. Preparar vegetales. 3. Calentar tortillas. 4. Armar tacos.',
                'porciones_estimadas'=>3,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>8,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Tortilla de Espinacas',
                'resumen'=>'Tortilla esponjosa con espinaca fresca.',
                'tiempo_preparacion'=>15,
                'preparacion'=>'1. Saltear espinaca. 2. Batir huevos. 3. Mezclar y cocinar. 4. Servir caliente.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>9,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Ensalada de Atún Mediterránea',
                'resumen'=>'Ensalada fresca con atún y aceitunas.',
                'tiempo_preparacion'=>10,
                'preparacion'=>'1. Mezclar atún con vegetales. 2. Agregar aceite de oliva. 3. Sazonar. 4. Servir.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>10,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Camote Horneado con Especias',
                'resumen'=>'Camote asado con hierbas aromáticas.',
                'tiempo_preparacion'=>45,
                'preparacion'=>'1. Cortar camote. 2. Sazonar con especias. 3. Hornear a 200°C. 4. Servir.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>11,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Granola Casera con Frutos Secos',
                'resumen'=>'Granola crujiente con miel y almendras.',
                'tiempo_preparacion'=>30,
                'preparacion'=>'1. Mezclar avena, frutos secos y miel. 2. Hornear. 3. Enfriar. 4. Almacenar.',
                'porciones_estimadas'=>8,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>12,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Pudding de Chía con Mango',
                'resumen'=>'Postre saludable con semillas de chía.',
                'tiempo_preparacion'=>125,
                'preparacion'=>'1. Mezclar chía con leche de almendra. 2. Refrigerar 2 horas. 3. Agregar mango. 4. Servir frío.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>13,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Wrap de Pollo con Aguacate',
                'resumen'=>'Wrap saludable con pollo y vegetales.',
                'tiempo_preparacion'=>15,
                'preparacion'=>'1. Cocinar pollo. 2. Preparar aguacate. 3. Calentar tortilla. 4. Armar wrap.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>14,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Sopa de Lentejas con Vegetales',
                'resumen'=>'Sopa reconfortante y nutritiva.',
                'tiempo_preparacion'=>50,
                'preparacion'=>'1. Saltear cebolla y ajo. 2. Agregar lentejas y caldo. 3. Cocer vegetales. 4. Servir caliente.',
                'porciones_estimadas'=>4,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>15,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Berenjena a la Parmesana Light',
                'resumen'=>'Berenjena horneada con queso bajo en grasa.',
                'tiempo_preparacion'=>55,
                'preparacion'=>'1. Cortar berenjena. 2. Hornear. 3. Agregar salsa de tomate. 4. Gratinar.',
                'porciones_estimadas'=>3,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>16,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Bowl Tropical de Frutas',
                'resumen'=>'Bowl refrescante con frutas tropicales.',
                'tiempo_preparacion'=>10,
                'preparacion'=>'1. Cortar frutas. 2. Agregar yogur. 3. Añadir granola. 4. Servir frío.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>17,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Pasta Integral con Vegetales',
                'resumen'=>'Pasta saludable con salsa de vegetales.',
                'tiempo_preparacion'=>25,
                'preparacion'=>'1. Cocer pasta. 2. Saltear vegetales. 3. Preparar salsa. 4. Mezclar y servir.',
                'porciones_estimadas'=>3,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>18,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Albóndigas de Pavo al Horno',
                'resumen'=>'Albóndigas saludables con salsa de tomate.',
                'tiempo_preparacion'=>40,
                'preparacion'=>'1. Formar albóndigas. 2. Hornear. 3. Preparar salsa. 4. Combinar y servir.',
                'porciones_estimadas'=>4,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>19,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Risotto de Calabacín Light',
                'resumen'=>'Risotto cremoso con calabacín.',
                'tiempo_preparacion'=>35,
                'preparacion'=>'1. Saltear cebolla. 2. Agregar arroz. 3. Añadir caldo gradualmente. 4. Incorporar calabacín.',
                'porciones_estimadas'=>3,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>20,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Smoothie Bowl de Arándanos',
                'resumen'=>'Bowl cremoso con arándanos y toppings.',
                'tiempo_preparacion'=>10,
                'preparacion'=>'1. Licuar arándanos con plátano. 2. Verter en bowl. 3. Agregar toppings. 4. Servir inmediato.',
                'porciones_estimadas'=>1,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>21,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Ensalada César Light',
                'resumen'=>'Versión saludable de la ensalada César.',
                'tiempo_preparacion'=>15,
                'preparacion'=>'1. Preparar aderezo light. 2. Tostar pollo. 3. Mezclar con lechuga. 4. Servir.',
                'porciones_estimadas'=>2,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>22,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Hamburguesa de Garbanzos',
                'resumen'=>'Hamburguesa vegana de garbanzos.',
                'tiempo_preparacion'=>30,
                'preparacion'=>'1. Triturar garbanzos. 2. Formar hamburguesas. 3. Cocinar a la plancha. 4. Servir en pan integral.',
                'porciones_estimadas'=>4,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>23,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Ceviche de Salmón',
                'resumen'=>'Ceviche fresco con salmón y limón.',
                'tiempo_preparacion'=>130,
                'preparacion'=>'1. Cortar salmón en cubos. 2. Marinar con limón. 3. Agregar cebolla y cilantro. 4. Refrigerar 2 horas.',
                'porciones_estimadas'=>3,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
            [
                'id'=>24,
                'id_usuario_creador'=>1,
                'id_estado'=>1,
                'id_tipo_alimento'=>3,
                'titulo'=>'Rollos de Calabacín con Ricotta',
                'resumen'=>'Rollos de calabacín rellenos de queso.',
                'tiempo_preparacion'=>45,
                'preparacion'=>'1. Cortar calabacín en láminas. 2. Preparar relleno. 3. Enrollar. 4. Hornear.',
                'porciones_estimadas'=>3,
                'created_at'=>$now,
                'updated_at'=>$now
            ],
        ]);

        /* ============================================================
           4) RECETA – DIETA
        ============================================================ */
        DB::table('receta_dieta')->insertOrIgnore([
            // Recetas originales
            ['id_receta'=>1,'id_dieta'=>7],  // Vegana
            ['id_receta'=>3,'id_dieta'=>8],  // Energética
            
            // Nuevas recetas
            ['id_receta'=>5,'id_dieta'=>8],  // Energética
            ['id_receta'=>6,'id_dieta'=>7],  // Vegana
            ['id_receta'=>7,'id_dieta'=>7],  // Vegana
            ['id_receta'=>8,'id_dieta'=>8],  // Energética
            ['id_receta'=>10,'id_dieta'=>7], // Vegana
            ['id_receta'=>11,'id_dieta'=>8], // Energética
            ['id_receta'=>12,'id_dieta'=>7], // Vegana
            ['id_receta'=>16,'id_dieta'=>8], // Energética
            ['id_receta'=>20,'id_dieta'=>8], // Energética
            ['id_receta'=>22,'id_dieta'=>7], // Vegana
        ]);

        /* ============================================================
           5) INGREDIENTES POR RECETA
        ============================================================ */
        DB::table('ingrediente_receta')->insertOrIgnore([
            // RECETAS ORIGINALES
            ['id_unidad_medida'=>4,'id_ingrediente'=>1,'id_receta'=>1,'cantidad'=>100],
            ['id_unidad_medida'=>4,'id_ingrediente'=>2,'id_receta'=>1,'cantidad'=>1],
            ['id_unidad_medida'=>4,'id_ingrediente'=>3,'id_receta'=>1,'cantidad'=>1],

            ['id_unidad_medida'=>4,'id_ingrediente'=>7,'id_receta'=>2,'cantidad'=>250],
            ['id_unidad_medida'=>4,'id_ingrediente'=>8,'id_receta'=>2,'cantidad'=>80],
            ['id_unidad_medida'=>4,'id_ingrediente'=>9,'id_receta'=>2,'cantidad'=>80],

            ['id_unidad_medida'=>5,'id_ingrediente'=>10,'id_receta'=>3,'cantidad'=>1],
            ['id_unidad_medida'=>6,'id_ingrediente'=>11,'id_receta'=>3,'cantidad'=>100],
            ['id_unidad_medida'=>6,'id_ingrediente'=>12,'id_receta'=>3,'cantidad'=>200],

            ['id_unidad_medida'=>4,'id_ingrediente'=>8,'id_receta'=>4,'cantidad'=>100],
            ['id_unidad_medida'=>4,'id_ingrediente'=>9,'id_receta'=>4,'cantidad'=>100],
            
            // RECETA 5: Bowl de Arroz Integral con Salmón
            ['id_unidad_medida'=>4,'id_ingrediente'=>23,'id_receta'=>5,'cantidad'=>150],
            ['id_unidad_medida'=>4,'id_ingrediente'=>26,'id_receta'=>5,'cantidad'=>200],
            ['id_unidad_medida'=>5,'id_ingrediente'=>22,'id_receta'=>5,'cantidad'=>1],
            ['id_unidad_medida'=>4,'id_ingrediente'=>21,'id_receta'=>5,'cantidad'=>50],
            
            // RECETA 6: Ensalada de Lentejas
            ['id_unidad_medida'=>4,'id_ingrediente'=>24,'id_receta'=>6,'cantidad'=>200],
            ['id_unidad_medida'=>5,'id_ingrediente'=>2,'id_receta'=>6,'cantidad'=>2],
            ['id_unidad_medida'=>5,'id_ingrediente'=>3,'id_receta'=>6,'cantidad'=>1],
            ['id_unidad_medida'=>4,'id_ingrediente'=>4,'id_receta'=>6,'cantidad'=>30],
            
            // RECETA 7: Tacos de Garbanzos
            ['id_unidad_medida'=>4,'id_ingrediente'=>25,'id_receta'=>7,'cantidad'=>300],
            ['id_unidad_medida'=>4,'id_ingrediente'=>50,'id_receta'=>7,'cantidad'=>5],
            ['id_unidad_medida'=>5,'id_ingrediente'=>2,'id_receta'=>7,'cantidad'=>2],
            ['id_unidad_medida'=>5,'id_ingrediente'=>22,'id_receta'=>7,'cantidad'=>1],
            
            // RECETA 8: Tortilla de Espinacas
            ['id_unidad_medida'=>4,'id_ingrediente'=>21,'id_receta'=>8,'cantidad'=>100],
            ['id_unidad_medida'=>5,'id_ingrediente'=>27,'id_receta'=>8,'cantidad'=>3],
            ['id_unidad_medida'=>4,'id_ingrediente'=>17,'id_receta'=>8,'cantidad'=>50],
            
            // RECETA 9: Ensalada de Atún
            ['id_unidad_medida'=>4,'id_ingrediente'=>28,'id_receta'=>9,'cantidad'=>150],
            ['id_unidad_medida'=>5,'id_ingrediente'=>2,'id_receta'=>9,'cantidad'=>2],
            ['id_unidad_medida'=>5,'id_ingrediente'=>19,'id_receta'=>9,'cantidad'=>1],
            ['id_unidad_medida'=>4,'id_ingrediente'=>4,'id_receta'=>9,'cantidad'=>20],
            
            // RECETA 10: Camote Horneado
            ['id_unidad_medida'=>4,'id_ingrediente'=>30,'id_receta'=>10,'cantidad'=>400],
            ['id_unidad_medida'=>4,'id_ingrediente'=>4,'id_receta'=>10,'cantidad'=>20],
            ['id_unidad_medida'=>4,'id_ingrediente'=>49,'id_receta'=>10,'cantidad'=>5],
            
            // RECETA 11: Granola Casera
            ['id_unidad_medida'=>4,'id_ingrediente'=>13,'id_receta'=>11,'cantidad'=>300],
            ['id_unidad_medida'=>4,'id_ingrediente'=>31,'id_receta'=>11,'cantidad'=>100],
            ['id_unidad_medida'=>4,'id_ingrediente'=>32,'id_receta'=>11,'cantidad'=>80],
            ['id_unidad_medida'=>4,'id_ingrediente'=>14,'id_receta'=>11,'cantidad'=>50],
            
            // RECETA 12: Pudding de Chía
            ['id_unidad_medida'=>4,'id_ingrediente'=>33,'id_receta'=>12,'cantidad'=>40],
            ['id_unidad_medida'=>6,'id_ingrediente'=>12,'id_receta'=>12,'cantidad'=>250],
            ['id_unidad_medida'=>4,'id_ingrediente'=>39,'id_receta'=>12,'cantidad'=>150],
            
            // RECETA 13: Wrap de Pollo
            ['id_unidad_medida'=>4,'id_ingrediente'=>7,'id_receta'=>13,'cantidad'=>200],
            ['id_unidad_medida'=>5,'id_ingrediente'=>22,'id_receta'=>13,'cantidad'=>1],
            ['id_unidad_medida'=>5,'id_ingrediente'=>2,'id_receta'=>13,'cantidad'=>1],
            ['id_unidad_medida'=>4,'id_ingrediente'=>21,'id_receta'=>13,'cantidad'=>50],
            
            // RECETA 14: Sopa de Lentejas
            ['id_unidad_medida'=>4,'id_ingrediente'=>24,'id_receta'=>14,'cantidad'=>250],
            ['id_unidad_medida'=>4,'id_ingrediente'=>8,'id_receta'=>14,'cantidad'=>100],
            ['id_unidad_medida'=>4,'id_ingrediente'=>17,'id_receta'=>14,'cantidad'=>80],
            ['id_unidad_medida'=>6,'id_ingrediente'=>46,'id_receta'=>14,'cantidad'=>1000],
            
            // RECETA 15: Berenjena a la Parmesana
            ['id_unidad_medida'=>4,'id_ingrediente'=>38,'id_receta'=>15,'cantidad'=>500],
            ['id_unidad_medida'=>5,'id_ingrediente'=>2,'id_receta'=>15,'cantidad'=>3],
            ['id_unidad_medida'=>4,'id_ingrediente'=>48,'id_receta'=>15,'cantidad'=>10],
            
            // RECETA 16: Bowl Tropical
            ['id_unidad_medida'=>5,'id_ingrediente'=>39,'id_receta'=>16,'cantidad'=>1],
            ['id_unidad_medida'=>4,'id_ingrediente'=>40,'id_receta'=>16,'cantidad'=>150],
            ['id_unidad_medida'=>5,'id_ingrediente'=>41,'id_receta'=>16,'cantidad'=>2],
            ['id_unidad_medida'=>4,'id_ingrediente'=>15,'id_receta'=>16,'cantidad'=>200],
            
            // RECETA 17: Pasta Integral
            ['id_unidad_medida'=>4,'id_ingrediente'=>43,'id_receta'=>17,'cantidad'=>300],
            ['id_unidad_medida'=>4,'id_ingrediente'=>9,'id_receta'=>17,'cantidad'=>100],
            ['id_unidad_medida'=>5,'id_ingrediente'=>2,'id_receta'=>17,'cantidad'=>3],
            ['id_unidad_medida'=>4,'id_ingrediente'=>16,'id_receta'=>17,'cantidad'=>10],
            
            // RECETA 18: Albóndigas de Pavo
            ['id_unidad_medida'=>4,'id_ingrediente'=>45,'id_receta'=>18,'cantidad'=>500],
            ['id_unidad_medida'=>5,'id_ingrediente'=>27,'id_receta'=>18,'cantidad'=>1],
            ['id_unidad_medida'=>4,'id_ingrediente'=>17,'id_receta'=>18,'cantidad'=>50],
            ['id_unidad_medida'=>5,'id_ingrediente'=>2,'id_receta'=>18,'cantidad'=>3],
            
            // RECETA 19: Risotto de Calabacín
            ['id_unidad_medida'=>4,'id_ingrediente'=>23,'id_receta'=>19,'cantidad'=>250],
            ['id_unidad_medida'=>4,'id_ingrediente'=>37,'id_receta'=>19,'cantidad'=>200],
            ['id_unidad_medida'=>6,'id_ingrediente'=>46,'id_receta'=>19,'cantidad'=>800],
            ['id_unidad_medida'=>4,'id_ingrediente'=>17,'id_receta'=>19,'cantidad'=>50],
            
            // RECETA 20: Smoothie Bowl
            ['id_unidad_medida'=>4,'id_ingrediente'=>42,'id_receta'=>20,'cantidad'=>150],
            ['id_unidad_medida'=>5,'id_ingrediente'=>10,'id_receta'=>20,'cantidad'=>1],
            ['id_unidad_medida'=>6,'id_ingrediente'=>12,'id_receta'=>20,'cantidad'=>100],
            ['id_unidad_medida'=>4,'id_ingrediente'=>13,'id_receta'=>20,'cantidad'=>30],
            
            // RECETA 21: Ensalada César
            ['id_unidad_medida'=>4,'id_ingrediente'=>7,'id_receta'=>21,'cantidad'=>200],
            ['id_unidad_medida'=>4,'id_ingrediente'=>15,'id_receta'=>21,'cantidad'=>50],
            ['id_unidad_medida'=>5,'id_ingrediente'=>19,'id_receta'=>21,'cantidad'=>1],
            
            // RECETA 22: Hamburguesa de Garbanzos
            ['id_unidad_medida'=>4,'id_ingrediente'=>25,'id_receta'=>22,'cantidad'=>400],
            ['id_unidad_medida'=>4,'id_ingrediente'=>17,'id_receta'=>22,'cantidad'=>50],
            ['id_unidad_medida'=>4,'id_ingrediente'=>50,'id_receta'=>22,'cantidad'=>10],
            ['id_unidad_medida'=>4,'id_ingrediente'=>18,'id_receta'=>22,'cantidad'=>20],
            
            // RECETA 23: Ceviche de Salmón
            ['id_unidad_medida'=>4,'id_ingrediente'=>26,'id_receta'=>23,'cantidad'=>300],
            ['id_unidad_medida'=>5,'id_ingrediente'=>19,'id_receta'=>23,'cantidad'=>3],
            ['id_unidad_medida'=>4,'id_ingrediente'=>17,'id_receta'=>23,'cantidad'=>100],
            ['id_unidad_medida'=>4,'id_ingrediente'=>35,'id_receta'=>23,'cantidad'=>20],
            
            // RECETA 24: Rollos de Calabacín
            ['id_unidad_medida'=>4,'id_ingrediente'=>37,'id_receta'=>24,'cantidad'=>300],
            ['id_unidad_medida'=>4,'id_ingrediente'=>44,'id_receta'=>24,'cantidad'=>200],
            ['id_unidad_medida'=>4,'id_ingrediente'=>21,'id_receta'=>24,'cantidad'=>50],
            ['id_unidad_medida'=>4,'id_ingrediente'=>48,'id_receta'=>24,'cantidad'=>10],
        ]);

        /* ============================================================
           6) MULTIMEDIA
        ============================================================ */
        DB::table('multimedia_recetas')->insertOrIgnore([
            // Receta 1: Ensalada de Quinoa Vegana
            ['id_receta'=>1,'archivo'=>'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 2: Pollo a la Plancha con Verduras
            ['id_receta'=>2,'archivo'=>'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 3: Smoothie Energético
            ['id_receta'=>3,'archivo'=>'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 4: Sopa de Verduras
            ['id_receta'=>4,'archivo'=>'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 5: Bowl de Arroz Integral con Salmón
            ['id_receta'=>5,'archivo'=>'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 6: Ensalada de Lentejas
            ['id_receta'=>6,'archivo'=>'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 7: Tacos de Garbanzos Especiados
            ['id_receta'=>7,'archivo'=>'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 8: Tortilla de Espinacas
            ['id_receta'=>8,'archivo'=>'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 9: Ensalada de Atún Mediterránea
            ['id_receta'=>9,'archivo'=>'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 10: Camote Horneado con Especias
            ['id_receta'=>10,'archivo'=>'https://images.unsplash.com/photo-1518779578993-ec3579fee39f?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 11: Granola Casera con Frutos Secos
            ['id_receta'=>11,'archivo'=>'https://images.unsplash.com/photo-1526413232644-8a40f03cc03b?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 12: Pudding de Chía con Mango
            ['id_receta'=>12,'archivo'=>'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 13: Wrap de Pollo con Aguacate
            ['id_receta'=>13,'archivo'=>'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 14: Sopa de Lentejas con Vegetales
            ['id_receta'=>14,'archivo'=>'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 15: Berenjena a la Parmesana Light
            ['id_receta'=>15,'archivo'=>'https://images.unsplash.com/photo-1572695157849-e08abf59ebf6?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 16: Bowl Tropical de Frutas
            ['id_receta'=>16,'archivo'=>'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 17: Pasta Integral con Vegetales
            ['id_receta'=>17,'archivo'=>'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 18: Albóndigas de Pavo al Horno
            ['id_receta'=>18,'archivo'=>'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 19: Risotto de Calabacín Light
            ['id_receta'=>19,'archivo'=>'https://images.unsplash.com/photo-1476124369491-c4384d8b2a2e?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 20: Smoothie Bowl de Arándanos
            ['id_receta'=>20,'archivo'=>'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 21: Ensalada César Light
            ['id_receta'=>21,'archivo'=>'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 22: Hamburguesa de Garbanzos
            ['id_receta'=>22,'archivo'=>'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 23: Ceviche de Salmón
            ['id_receta'=>23,'archivo'=>'https://images.unsplash.com/photo-1534604973900-c43ab4c2e0ab?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
            // Receta 24: Rollos de Calabacín con Ricotta
            ['id_receta'=>24,'archivo'=>'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800','tipo_archivo'=>'image/jpeg','orden'=>1],
        ]);
    }
}