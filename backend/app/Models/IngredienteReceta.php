<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class IngredienteReceta extends Model
{
    use HasFactory;

    protected $table = 'ingrediente_receta';
    protected $guarded = [];

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }

    public function ingrediente()
    {
        return $this->belongsTo(Ingrediente::class, 'id_ingrediente');
    }

    public function unidadMedida()
    {
        return $this->belongsTo(Subdominio::class, 'id_unidad_medida');
    }
}
