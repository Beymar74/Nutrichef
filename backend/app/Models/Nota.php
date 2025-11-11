<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Nota extends Model
{
    use HasFactory;

    protected $table = 'notas';
    protected $guarded = [];

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }
}
