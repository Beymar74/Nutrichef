<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ingrediente extends Model
{
    use HasFactory;

    protected $table = 'ingredientes';

    protected $fillable = [
        'descripcion', 
        'id_alergeno'
    ];

    // Relación inversa: Un ingrediente puede estar en muchas recetas (a través de la tabla pivote)
    public function recetas()
    {
        return $this->hasMany(IngredienteReceta::class, 'id_ingrediente');
    }
    
    // Relación con Alergeno (Subdominio)
    public function alergeno()
    {
        return $this->belongsTo(Subdominio::class, 'id_alergeno');
    }
}