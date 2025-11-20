<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class AdminUserSeeder extends Seeder
{
    public function run()
    {
        // 1. Crear el Rol de Admin (si no existe)
        $rolId = DB::table('roles')->insertGetId([
            'descripcion' => 'Administrador',
            'estado' => true,
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        // 2. Crear una Persona ficticia (Requisito de tu tabla usuarios)
        $personaId = DB::table('personas')->insertGetId([
            'nombres' => 'Super',
            'apellido_paterno' => 'Admin',
            'estado' => true,
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        // 3. Crear el Usuario Admin
        DB::table('usuarios')->insert([
            'id_rol' => $rolId,
            'id_persona' => $personaId,
            'name' => 'Admin Principal',
            'email' => 'admin@nutrichef.com', // <--- TU USUARIO
            'password' => Hash::make('password123'), // <--- TU CONTRASEÑA
            'descripcion_perfil' => 'Administrador del sistema',
            'estado' => true,
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);
    }
}