<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Receta extends Model
{
    use HasFactory;

    protected $table = 'recetas';
    protected $guarded = [];

    public function creador()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario_creador');
    }

    public function estado()
    {
        return $this->belongsTo(Subdominio::class, 'id_estado');
    }

    public function tipoAlimento()
    {
        return $this->belongsTo(Subdominio::class, 'id_tipo_alimento');
    }

    public function ingredientesReceta()
    {
        return $this->hasMany(IngredienteReceta::class, 'id_receta');
    }

    public function publicaciones()
    {
        return $this->hasMany(Publicacion::class, 'id_receta');
    }

    public function dietas()
    {
        return $this->hasMany(RecetaDieta::class, 'id_receta');
    }

    public function multimedia()
    {
        return $this->hasMany(MultimediaReceta::class, 'id_receta');
    }
}
