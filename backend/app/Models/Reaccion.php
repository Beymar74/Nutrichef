<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Reaccion extends Model
{
    use HasFactory;

    protected $table = 'reacciones';
    protected $guarded = [];

    public function publicacion()
    {
        return $this->belongsTo(Publicacion::class, 'id_publicacion');
    }

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function tipoReaccion()
    {
        return $this->belongsTo(Subdominio::class, 'id_tipo_reaccion');
    }
}
