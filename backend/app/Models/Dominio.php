<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Dominio extends Model
{
    use HasFactory;

    protected $table = 'dominios';
    protected $guarded = [];

    public function subdominios()
    {
        return $this->hasMany(Subdominio::class, 'id_dominio');
    }
}
