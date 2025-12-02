<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Receta extends Model
{
    use HasFactory;

    protected $table = 'recetas';
    protected $guarded = [];

    // Campos que se agregarán automáticamente al JSON
    protected $appends = [
        'calificacion_promedio', 
        'total_comentarios', 
        'total_favoritos', 
        'visualizaciones',
        'estado_descripcion', // Para facilitar acceso en Flutter
        'tipo_alimento_descripcion'
    ];

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
    
    // Relación con Favoritos (Asumiendo modelo UsuarioFavorito)
    public function favoritos()
    {
        return $this->hasMany(UsuarioFavorito::class, 'id_receta');
    }

    // ====================
    // 🆕 ACCESORIOS (Virtuales para Flutter)
    // ====================

    // Alias para compatibilidad con Flutter (calificacion_promedio)
    public function getCalificacionPromedioAttribute()
    {
        return $this->rating_promedio; // Reusa tu lógica existente
    }

    // Tu lógica original de rating
    public function getRatingPromedioAttribute()
    {
        $promedio = 0;
        $total = 0;

        foreach ($this->publicaciones as $pub) {
            // Asumiendo relación 'calificaciones' en Publicacion
            // Usamos rescue para evitar errores si la relación no existe aún
            $avg = $pub->calificaciones()->avg('calificacion'); 
            if ($avg) {
                $promedio += $avg;
                $total++;
            }
        }

        return $total > 0 ? round($promedio / $total, 1) : 0.0;
    }

    public function getTotalComentariosAttribute()
    {
        // Suma de comentarios de todas las publicaciones de esta receta
        $total = 0;
        foreach ($this->publicaciones as $pub) {
            $total += $pub->comentarios()->count();
        }
        return $total;
    }

    public function getTotalFavoritosAttribute()
    {
        return $this->favoritos()->count();
    }

    public function getVisualizacionesAttribute()
    {
        // Retornamos 0 por defecto si no hay campo en BD
        return $this->attributes['visualizaciones'] ?? 0;
    }

    // Helpers para obtener nombres directos de subdominios
    public function getEstadoDescripcionAttribute()
    {
        return $this->estado ? $this->estado->descripcion : 'BORRADOR';
    }

    public function getTipoAlimentoDescripcionAttribute()
    {
        return $this->tipoAlimento ? $this->tipoAlimento->descripcion : 'OTRO';
    }
}