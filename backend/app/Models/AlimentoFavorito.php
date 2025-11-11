<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AlimentoFavorito extends Model
{
    use HasFactory;

    protected $table = 'alimentos_favoritos';
    protected $guarded = [];

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function tipoAlimento()
    {
        return $this->belongsTo(Subdominio::class, 'id_tipo_alimento');
    }
}
