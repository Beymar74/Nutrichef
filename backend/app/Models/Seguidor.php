<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Seguidor extends Model
{
    use HasFactory;

    protected $table = 'seguidores';
    protected $guarded = [];

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function usuarioSeguido()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario_seguido');
    }
}
