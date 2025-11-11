<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Ingrediente extends Model
{
    use HasFactory;

    protected $table = 'ingredientes';
    protected $guarded = [];

    public function alergeno()
    {
        return $this->belongsTo(Subdominio::class, 'id_alergeno');
    }
}
