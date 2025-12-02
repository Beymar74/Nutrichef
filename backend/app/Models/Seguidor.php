<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Seguidor extends Model
{
    use HasFactory;

    protected $table = 'seguidores';
    
    // IMPORTANTE: Estos campos deben ser 'fillable' para poder usar Seguidor::create()
    protected $fillable = [
        'id_usuario',        // El que sigue
        'id_usuario_seguido' // Al que siguen
    ];

    // Relaciones (ya las tenías bien, solo confírmalas)
    public function seguidor()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function seguido()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario_seguido');
    }
}