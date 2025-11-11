<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class RecetaDieta extends Model
{
    use HasFactory;

    protected $table = 'receta_dieta';
    protected $guarded = [];

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }

    public function dieta()
    {
        return $this->belongsTo(Subdominio::class, 'id_dieta');
    }
}
