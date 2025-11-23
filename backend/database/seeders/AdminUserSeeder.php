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
        // 1. Crear o obtener el Rol de Admin
        $rol = DB::table('roles')->where('descripcion', 'Administrador')->first();
        
        if (!$rol) {
            $rolId = DB::table('roles')->insertGetId([
                'descripcion' => 'Administrador',
                'estado' => true,
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
            ]);
        } else {
            $rolId = $rol->id;
        }

        // Array de usuarios administradores
        $administradores = [
            [
                'nombres' => 'Super',
                'apellido_paterno' => 'Admin',
                'name' => 'Admin Principal',
                'email' => 'admin@nutrichef.com',
                'password' => 'password123',
            ],
            [
                'nombres' => 'Beymar',
                'apellido_paterno' => 'Admin',
                'name' => 'Beymar Admin',
                'email' => 'beymar@nutrichef.com',
                'password' => 'beymar123',
            ],
            [
                'nombres' => 'Kiara',
                'apellido_paterno' => 'Admin',
                'name' => 'Kiara Admin',
                'email' => 'kiara@nutrichef.com',
                'password' => 'kiara123',
            ],
            [
                'nombres' => 'Evelyn',
                'apellido_paterno' => 'Admin',
                'name' => 'Evelyn Admin',
                'email' => 'evelyn@nutrichef.com',
                'password' => 'evelyn123',
            ],
            [
                'nombres' => 'Mike',
                'apellido_paterno' => 'Admin',
                'name' => 'Mike Admin',
                'email' => 'mike@nutrichef.com',
                'password' => 'mike123',
            ],
            [
                'nombres' => 'Reyshel',
                'apellido_paterno' => 'Admin',
                'name' => 'Reyshel Admin',
                'email' => 'reyshel@nutrichef.com',
                'password' => 'reyshel123',
            ],
        ];

        // 2. Crear las Personas y Usuarios para cada administrador
        foreach ($administradores as $admin) {
            // Verificar si el usuario ya existe
            $usuarioExistente = DB::table('usuarios')->where('email', $admin['email'])->first();
            
            if ($usuarioExistente) {
                $this->command->info("El usuario {$admin['email']} ya existe. Omitiendo...");
                continue;
            }

            // Crear la Persona
            $personaId = DB::table('personas')->insertGetId([
                'nombres' => $admin['nombres'],
                'apellido_paterno' => $admin['apellido_paterno'],
                'estado' => true,
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
            ]);

            // Crear el Usuario Admin
            DB::table('usuarios')->insert([
                'id_rol' => $rolId,
                'id_persona' => $personaId,
                'name' => $admin['name'],
                'email' => $admin['email'],
                'password' => Hash::make($admin['password']),
                'descripcion_perfil' => 'Administrador del sistema',
                'estado' => true,
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
            ]);

            $this->command->info("Usuario {$admin['email']} creado exitosamente.");
        }
    }
}