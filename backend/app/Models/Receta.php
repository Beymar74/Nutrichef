<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Receta extends Model
{
    use HasFactory;

    protected $table = 'recetas';
    protected $guarded = [];

    // ====================
    // 🔗 RELACIONES
    // ====================

    public function creador()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario_creador');
    }

    public function estado()
    {
        return $this->belongsTo(Subdominio::class, 'id_estado');
    }

    public function tipoAlimento()
    {
        return $this->belongsTo(Subdominio::class, 'id_tipo_alimento');
    }

    public function ingredientesReceta()
    {
        return $this->hasMany(IngredienteReceta::class, 'id_receta');
    }

    public function publicaciones()
    {
        return $this->hasMany(Publicacion::class, 'id_receta');
    }

    public function dietas()
    {
        return $this->hasMany(RecetaDieta::class, 'id_receta');
    }

    public function multimedia()
    {
        return $this->hasMany(MultimediaReceta::class, 'id_receta');
    }

    // ====================
    // 🆕 ACCESORIOS ÚTILES (Virtuales)
    // ====================

    /**
     * Calcula el rating promedio basado en las publicaciones de esta receta.
     * Uso: $receta->rating_promedio
     */
    public function getRatingPromedioAttribute()
    {
        // 1. Obtenemos las publicaciones de esta receta
        // 2. De esas publicaciones, obtenemos sus calificaciones
        // Nota: Esto asume que tienes un modelo Calificacion
        
        $promedio = 0;
        $total = 0;

        foreach ($this->publicaciones as $pub) {
            // Asumiendo que Publicacion tiene hasMany(Calificacion::class)
            // Si no quieres cargar todo en memoria, puedes optimizar esto con query raw en el controller
            $avg = $pub->calificaciones()->avg('calificacion'); 
            if ($avg) {
                $promedio += $avg;
                $total++;
            }
        }

        return $total > 0 ? round($promedio / $total, 1) : 0.0;
    }
}