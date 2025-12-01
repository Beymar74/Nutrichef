<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MultimediaReceta extends Model
{
    use HasFactory;

    protected $table = 'multimedia_recetas'; // Tabla correcta

    protected $fillable = [
        'id_receta',
        'archivo',
        'tipo_archivo',
        'orden'
    ];
}