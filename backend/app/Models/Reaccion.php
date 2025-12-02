<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Reaccion extends Model
{
    use HasFactory;

    protected $table = 'reacciones';
    
    // ✅ Cambiado de $guarded a $fillable para ser más explícito
    protected $fillable = [
        'id_publicacion',
        'id_usuario',
        'tipo_reaccion',        // Campo directo (si usas string: 'like', 'love', etc.)
        'id_tipo_reaccion'      // O este si usas FK a subdominios
    ];

    // Relaciones
    public function publicacion()
    {
        return $this->belongsTo(Publicacion::class, 'id_publicacion');
    }

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    // ✅ Solo si usas tabla de subdominios para tipos de reacción
    public function tipoReaccion()
    {
        return $this->belongsTo(Subdominio::class, 'id_tipo_reaccion');
    }
}
```

## ⚠️ IMPORTANTE - Aclaración sobre tu estructura:

Veo que tienes **DOS formas posibles** de manejar el tipo de reacción:

### Opción 1: Campo directo `tipo_reaccion` (string)
```
tabla: reacciones
- id
- id_publicacion
- id_usuario
- tipo_reaccion (VARCHAR: 'like', 'love', 'angry', etc.)
- created_at
- updated_at
```

### Opción 2: Relación con `subdominios` usando `id_tipo_reaccion` (FK)
```
tabla: reacciones
- id
- id_publicacion
- id_usuario
- id_tipo_reaccion (FK a tabla subdominios)
- created_at
- updated_at