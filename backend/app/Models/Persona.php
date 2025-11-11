<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Persona extends Model
{
    use HasFactory;

    protected $table = 'personas';
    protected $guarded = [];

    public function usuario()
    {
        return $this->hasOne(Usuario::class, 'id_persona');
    }

    public function alergias()
    {
        return $this->hasMany(AlergiaPersona::class, 'id_persona');
    }
}
