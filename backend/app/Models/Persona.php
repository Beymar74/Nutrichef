<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Persona extends Model
{
    use HasFactory;

    protected $table = 'personas';

    protected $fillable = [
        'id_dieta',
        'id_nivel_cocina',
        'nombres',
        'apellido_paterno',
        'apellido_materno',
        'telefono',
        'altura',
        'peso',
        'fecha_nacimiento',
        'estado'
    ];

    // Relación: Una persona está asociada a un usuario (generalmente 1 a 1 en lógica de negocio)
    public function usuario()
    {
        return $this->hasOne(Usuario::class, 'id_persona');
    }
    
    // Nombre completo helper
    public function getNombreCompletoAttribute()
    {
        return "{$this->nombres} {$this->apellido_paterno} {$this->apellido_materno}";
    }
}