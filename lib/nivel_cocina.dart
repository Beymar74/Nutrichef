import 'package:flutter/material.dart';
import 'services/perfil_service.dart';
import 'tipo_dieta.dart';

class NivelCocina extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const NivelCocina({super.key, required this.usuario});

  @override
  State<NivelCocina> createState() => _NivelCocinaState();
}

class _NivelCocinaState extends State<NivelCocina> {
  int? _nivelSeleccionado; // 🔄 ID del nivel seleccionado

  // 🔹 Lista de niveles con su ID correspondiente
  final List<Map<String, dynamic>> niveles = [
    {"id": 40, "nombre": "Principiante", "descripcion": "Recetas simples con pasos guiados."},
    {"id": 41, "nombre": "Intermedio", "descripcion": "Quieres mejorar técnicas y variedad."},
    {"id": 42, "nombre": "Avanzado", "descripcion": "Buscas preparaciones complejas y técnicas."},
    {"id": 43, "nombre": "Profesional", "descripcion": "Chef o estudiante de gastronomía."},
  ];

  Future<void> _continuar() async {
    if (_nivelSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Selecciona tu nivel de cocina'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final token = widget.usuario["token"];
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Token no encontrado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 🛠 Enviar al Backend con ID
    final res = await PerfilService.actualizarNivelCocina(
      token: token,
      nivelCocinaId: _nivelSeleccionado!, // 👈 Ahora enviamos ID directamente
    );

    if (res["success"] == true) {
      widget.usuario["id_nivel_cocina"] = _nivelSeleccionado;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nivel de cocina guardado 🧑‍🍳'),
          backgroundColor: Colors.green,
        ),
      );

      // ⏭ SIGUIENTE PANTALLA
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TipoDieta(usuario: widget.usuario),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res["message"] ?? "❌ Error al guardar nivel"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // FLECHA ATRÁS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFFF8C21),
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // PROGRESO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.50,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF8C21),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '¿Cuál Es Tu Nivel De Cocina?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Selecciona tu nivel para obtener mejores recomendaciones.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: niveles.map((nivel) {
                    return Column(
                      children: [
                        _buildOpcionNivel(
                          nivel["id"],
                          nivel["nombre"],
                          nivel["descripcion"],
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C21),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Continuar ➜',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionNivel(int id, String nombre, String descripcion) {
    final bool activo = _nivelSeleccionado == id;

    return GestureDetector(
      onTap: () => setState(() => _nivelSeleccionado = id),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: activo ? const Color(0xFFFF8C21) : Colors.grey[300]!,
            width: activo ? 2.5 : 1.5,
          ),
          boxShadow: activo
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF8C21).withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nombre,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: activo ? const Color(0xFFFF8C21) : Colors.black87,
                  ),
                ),
                if (activo)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8C21),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              descripcion,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
