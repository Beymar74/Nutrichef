<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class MultimediaReceta extends Model
{
    use HasFactory;

    protected $table = 'multimedia_recetas';
    protected $guarded = [];

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }
}
