<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ListaCompra extends Model
{
    use HasFactory;

    protected $table = 'lista_compras';
    protected $guarded = [];

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function items()
    {
        return $this->hasMany(ListaCompraItem::class, 'id_lista_compra');
    }
}
