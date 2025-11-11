<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ListaCompraItem extends Model
{
    use HasFactory;

    protected $table = 'lista_compras_items';
    protected $guarded = [];

    public function lista()
    {
        return $this->belongsTo(ListaCompra::class, 'id_lista_compra');
    }

    public function ingrediente()
    {
        return $this->belongsTo(Ingrediente::class, 'id_ingrediente');
    }

    public function unidadMedida()
    {
        return $this->belongsTo(Subdominio::class, 'id_unidad_medida');
    }
}
