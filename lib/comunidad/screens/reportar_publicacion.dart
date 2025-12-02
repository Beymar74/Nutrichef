import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class ReportarPublicacionScreen extends StatefulWidget {
  final int idPublicacion;
  final Map<String, dynamic> usuario;

  const ReportarPublicacionScreen({
    Key? key,
    required this.idPublicacion,
    required this.usuario,
  }) : super(key: key);

  @override
  State<ReportarPublicacionScreen> createState() =>
      _ReportarPublicacionScreenState();
}

class _ReportarPublicacionScreenState extends State<ReportarPublicacionScreen> {
  String? _motivoSeleccionado;
  final TextEditingController _detalleCtrl = TextEditingController();
  bool _reportando = false;

  // ✅ Motivos de reporte
  final List<Map<String, dynamic>> _motivos = [
    {
      'id': 'spam',
      'titulo': 'Spam o publicidad',
      'icono': Icons.campaign,
    },
    {
      'id': 'violencia',
      'titulo': 'Contenido violento',
      'icono': Icons.warning,
    },
    {
      'id': 'acoso',
      'titulo': 'Acoso o bullying',
      'icono': Icons.person_off,
    },
    {
      'id': 'contenido_sexual',
      'titulo': 'Contenido sexual inapropiado',
      'icono': Icons.block,
    },
    {
      'id': 'informacion_falsa',
      'titulo': 'Información falsa',
      'icono': Icons.info_outline,
    },
    {
      'id': 'otro',
      'titulo': 'Otro motivo',
      'icono': Icons.more_horiz,
    },
  ];

  @override
  void dispose() {
    _detalleCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviarReporte() async {
    if (_motivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor selecciona un motivo"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Confirmar antes de reportar
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Confirmar reporte?"),
        content: const Text(
          "Tu reporte será revisado por nuestro equipo de moderación.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Reportar"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _reportando = true);

    final comunidadService =
        Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'];

    // ⚠️ NOTA: El backend solo maneja un contador de reportes
    // Aquí solo llamamos al endpoint, pero idealmente deberías enviar
    // el motivo y detalle al backend para un sistema de moderación completo
    final success = await comunidadService.reportarPublicacion(
      widget.idPublicacion,
      token,
    );

    setState(() => _reportando = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reporte enviado correctamente"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al enviar reporte"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportar Publicación"),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Encabezado
              Row(
                children: [
                  Icon(
                    Icons.report_problem,
                    color: Colors.red[700],
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "¿Por qué reportas esta publicación?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                "Tu reporte es anónimo y será revisado por nuestro equipo.",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              // ✅ Lista de motivos
              ...(_motivos.map((motivo) {
                final isSelected = _motivoSeleccionado == motivo['id'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _motivoSeleccionado = motivo['id'];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.orange : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? Colors.orange[50]
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            motivo['icono'],
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              motivo['titulo'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.orange[900]
                                    : Colors.black,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList()),

              const SizedBox(height: 20),

              // ✅ Campo de detalle opcional
              TextField(
                controller: _detalleCtrl,
                maxLines: 4,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText:
                      "Detalles adicionales (opcional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.edit_note),
                ),
              ),

              const SizedBox(height: 80), // Espacio para el botón flotante
            ],
          ),

          // ✅ Botón flotante para enviar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: _reportando
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _enviarReporte,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Enviar Reporte",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}