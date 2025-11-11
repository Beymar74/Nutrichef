<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Rol extends Model
{
    use HasFactory;

    protected $table = 'roles';
    protected $guarded = [];

    public function usuarios()
    {
        return $this->hasMany(Usuario::class, 'id_rol');
    }

    public function menuItems()
    {
        return $this->belongsToMany(MenuItem::class, 'menu_item_rol', 'id_rol', 'id_menu_item');
    }
}
