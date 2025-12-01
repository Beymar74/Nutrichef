<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Seguidor extends Model
{
    use HasFactory;

    protected $table = 'seguidores';
    protected $guarded = [];

    // El usuario que DA el follow (El Seguidor)
    public function seguidor()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    // El usuario que RECIBE el follow (El Seguido / El Chef)
    public function seguido()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario_seguido');
    }
}