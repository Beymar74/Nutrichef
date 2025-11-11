<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class MenuItem extends Model
{
    use HasFactory;

    protected $table = 'menu_items';
    protected $guarded = [];

    public function padre()
    {
        return $this->belongsTo(MenuItem::class, 'id_padre');
    }

    public function hijos()
    {
        return $this->hasMany(MenuItem::class, 'id_padre');
    }

    public function roles()
    {
        return $this->belongsToMany(Rol::class, 'menu_item_rol', 'id_menu_item', 'id_rol');
    }
}
