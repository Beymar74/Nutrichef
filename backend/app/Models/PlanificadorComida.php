<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PlanificadorComida extends Model
{
    use HasFactory;

    protected $table = 'planificador_comidas';
    protected $guarded = [];

    public function horario()
    {
        return $this->belongsTo(HorarioUsuario::class, 'id_horario');
    }

    public function receta()
    {
        return $this->belongsTo(Receta::class, 'id_receta');
    }

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }
}
