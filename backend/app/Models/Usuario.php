<?php

namespace App\Models;

use Laravel\Sanctum\HasApiTokens; 
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class Usuario extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;  

    protected $table = 'usuarios';

    protected $fillable = [
        'id_rol',
        'id_persona',
        'name',
        'email',
        'password',
        'descripcion_perfil',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    // ====================
    // 🔗 RELACIONES
    // ====================

    public function rol()
    {
        return $this->belongsTo(Rol::class, 'id_rol');
    }
    public function alergiasPersona()
{
    return $this->hasManyThrough(
        AlergiaPersona::class,
        Persona::class,
        'id',           // Persona.id (local key en personas)
        'id_persona',   // AlergiaPersona.id_persona (FK)
        'id_persona',   // Usuario.id_persona (FK)
        'id'            // Persona.id (PK)
    );
}
public function alergenos()
{
    return $this->hasManyThrough(
        Subdominio::class,     // Modelo objetivo final
        AlergiaPersona::class, // Modelo intermedio
        'id_persona',          // FK en alergias_persona que apunta a persona
        'id',                  // PK en subdominios
        'id_persona',          // usuario.id_persona → personas.id
        'id_alergeno'          // alergia_persona.id_alergeno → subdominios.id
    );
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
