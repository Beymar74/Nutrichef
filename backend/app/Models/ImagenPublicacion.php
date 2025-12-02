<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ImagenPublicacion extends Model
{
    protected $table = 'imagenes_publicacion';
    
    // ✅ Deshabilitar timestamps si tu tabla no los tiene
    public $timestamps = false;

    protected $fillable = [
        'id_publicacion',
        'ruta',
    ];

    // ✅ Relación inversa
    public function publicacion()
    {
        return $this->belongsTo(Publicacion::class, 'id_publicacion');
    }
}
