<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Publicacion extends Model
{
    use HasFactory;

    protected $table = 'publicaciones';
    protected $guarded = [];

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function estado()
    {
        return $this->belongsTo(Subdominio::class, 'id_estado');
    }

    public function comentarios()
    {
        return $this->hasMany(Comentario::class, 'id_publicacion');
    }

    public function reacciones()
    {
        return $this->hasMany(Reaccion::class, 'id_publicacion');
    }

    public function calificaciones()
    {
        return $this->hasMany(Calificacion::class, 'id_publicacion');
    }
}
