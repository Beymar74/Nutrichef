<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AlergiaPersona extends Model
{
    use HasFactory;

    protected $table = 'alergia_persona';
    protected $guarded = [];

    public function persona()
    {
        return $this->belongsTo(Persona::class, 'id_persona');
    }

    public function alergeno()
    {
        return $this->belongsTo(Subdominio::class, 'id_alergeno');
    }
}
