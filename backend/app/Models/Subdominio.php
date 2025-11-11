<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Subdominio extends Model
{
    use HasFactory;

    protected $table = 'subdominios';
    protected $guarded = [];

    public function dominio()
    {
        return $this->belongsTo(Dominio::class, 'id_dominio');
    }
}
