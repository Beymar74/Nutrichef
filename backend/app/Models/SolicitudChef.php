<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SolicitudChef extends Model
{
    protected $table = 'solicitudes_chef';

    protected $fillable = [
        'id_usuario',
        'motivo',
        'experiencia',
        'id_estado',
        'revisado_por',
        'comentario_admin',
        'fecha_revision',
    ];

    protected $casts = [
        'fecha_revision' => 'datetime',
    ];

    // ====================
    // 🔗 RELACIONES
    // ====================

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(Usuario::class, 'id_usuario', 'id');
    }

    public function estado(): BelongsTo
    {
        return $this->belongsTo(Subdominio::class, 'id_estado', 'id');
    }

    public function revisor(): BelongsTo
    {
        return $this->belongsTo(Usuario::class, 'revisado_por', 'id');
    }

    // ====================
    // 📊 SCOPES
    // ====================

    public function scopePendientes($query)
    {
        return $query->whereHas('estado', function($q) {
            $q->whereRaw('UPPER(descripcion) = ?', ['PENDIENTE']);
        });
    }

    public function scopeAprobadas($query)
    {
        return $query->whereHas('estado', function($q) {
            $q->whereRaw('UPPER(descripcion) = ?', ['APROBADA']);
        });
    }

    public function scopeRechazadas($query)
    {
        return $query->whereHas('estado', function($q) {
            $q->whereRaw('UPPER(descripcion) = ?', ['RECHAZADA']);
        });
    }

    // ====================
    // 🛠️ MÉTODOS AUXILIARES
    // ====================

    /**
     * Verifica si la solicitud está pendiente
     */
    public function estaPendiente(): bool
    {
        return strtoupper($this->estado->descripcion ?? '') === 'PENDIENTE';
    }

    /**
     * Verifica si fue aprobada
     */
    public function fueAprobada(): bool
    {
        return strtoupper($this->estado->descripcion ?? '') === 'APROBADA';
    }

    /**
     * Verifica si fue rechazada
     */
    public function fueRechazada(): bool
    {
        return strtoupper($this->estado->descripcion ?? '') === 'RECHAZADA';
    }
}