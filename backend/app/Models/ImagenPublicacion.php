<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ImagenPublicacion extends Model
{
    protected $table = 'imagenes_publicacion';

    protected $fillable = [
        'id_publicacion',
        'ruta',
    ];
}
