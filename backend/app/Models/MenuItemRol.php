<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class MenuItemRol extends Model
{
    use HasFactory;

    protected $table = 'menu_item_rol';
    protected $guarded = [];

    public function menuItem()
    {
        return $this->belongsTo(MenuItem::class, 'id_menu_item');
    }

    public function rol()
    {
        return $this->belongsTo(Rol::class, 'id_rol');
    }
}
