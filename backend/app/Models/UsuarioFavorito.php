<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class UsuarioFavorito extends Model
{
    use HasFactory;

    protected $table = 'usuario_favorito';
    protected $guarded = [];

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }
}
