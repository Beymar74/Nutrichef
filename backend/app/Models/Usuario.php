<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Usuario extends Authenticatable
{
    use HasFactory;

    protected $table = 'usuarios';
    protected $guarded = [];
    protected $hidden = ['password', 'remember_token'];

    public function rol()
    {
        return $this->belongsTo(Rol::class, 'id_rol');
    }

    public function persona()
    {
        return $this->belongsTo(Persona::class, 'id_persona');
    }

    public function recetasCreadas()
    {
        return $this->hasMany(Receta::class, 'id_usuario_creador');
    }

    public function publicaciones()
    {
        return $this->hasMany(Publicacion::class, 'id_usuario');
    }

    public function listasCompras()
    {
        return $this->hasMany(ListaCompra::class, 'id_usuario');
    }

    public function horarios()
    {
        return $this->hasMany(HorarioUsuario::class, 'id_usuario');
    }

    public function planificadorComidas()
    {
        return $this->hasMany(PlanificadorComida::class, 'id_usuario');
    }
}
