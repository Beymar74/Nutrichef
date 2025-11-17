<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class IngredienteReceta extends Model
{
    use HasFactory;

    // Importante: Definir el nombre exacto de la tabla en la BD (singular según tu seeder)
    protected $table = 'ingrediente_receta';

    protected $fillable = [
        'id_receta',
        'id_ingrediente',
        'id_unidad_medida',
        'cantidad',
    ];

    // Relación con el Ingrediente (para obtener el nombre: "Pollo", "Arroz"...)
    public function ingrediente()
    {
        return $this->belongsTo(Ingrediente::class, 'id_ingrediente');
    }

    // Relación con la Unidad de Medida (para obtener: "gramos", "tazas"...)
    public function unidadMedida()
    {
        return $this->belongsTo(Subdominio::class, 'id_unidad_medida');
    }

    // Relación inversa con Receta (opcional, pero buena práctica)
    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }
}