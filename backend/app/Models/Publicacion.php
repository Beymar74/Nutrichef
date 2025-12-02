<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Publicacion extends Model
{
    use HasFactory;

    protected $table = 'publicaciones';

    protected $fillable = [
        'descripcion',
        'imagen',
        'id_usuario',
        'id_receta',
        'id_estado',
    ];

    // ✅ CORRECCIÓN: Usar Usuario en lugar de User
    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }

    public function estado()
    {
        return $this->belongsTo(Estado::class, 'id_estado');
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
    public function imagenes()
{
    return $this->hasMany(ImagenPublicacion::class, 'id_publicacion');
}

}