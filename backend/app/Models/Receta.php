<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Receta extends Model
{
    use HasFactory;

    protected $table = 'recetas';
    protected $guarded = [];

    // Relación con el Usuario Creador
    public function creador()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario_creador');
    }

    // Relación con el Estado (Subdominio)
    public function estado()
    {
        return $this->belongsTo(Subdominio::class, 'id_estado');
    }

    // Relación con el Tipo de Alimento (Subdominio)
    public function tipoAlimento()
    {
        return $this->belongsTo(Subdominio::class, 'id_tipo_alimento');
    }

    // Relación con Ingredientes intermedios
    public function ingredientesReceta()
    {
        return $this->hasMany(IngredienteReceta::class, 'id_receta');
    }

    // Relación con Publicaciones
    public function publicaciones()
    {
        return $this->hasMany(Publicacion::class, 'id_receta');
    }

    // Relación con Dietas
    public function dietas()
    {
        return $this->hasMany(RecetaDieta::class, 'id_receta');
    }

    // Relación con Multimedia
    public function multimedia()
    {
        return $this->hasMany(MultimediaReceta::class, 'id_receta');
    }
}