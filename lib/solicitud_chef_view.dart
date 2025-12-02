import 'package:flutter/material.dart';
import 'services/solicitud_chef_service.dart';

class SolicitudChefView extends StatefulWidget {
  final Map<String, dynamic> usuario;
  
  const SolicitudChefView({super.key, required this.usuario});

  @override
  State<SolicitudChefView> createState() => _SolicitudChefViewState();
}

class _SolicitudChefViewState extends State<SolicitudChefView> {
  final _formKey = GlobalKey<FormState>();
  final _motivoController = TextEditingController();
  final _experienciaController = TextEditingController();
  
  bool _cargando = false;
  bool _solicitudEnviada = false;

  @override
  void dispose() {
    _motivoController.dispose();
    _experienciaController.dispose();
    super.dispose();
  }

  Future<void> _enviarSolicitud() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    final token = widget.usuario["token"] ?? "";
    final resultado = await SolicitudChefService.enviarSolicitud(
      token: token,
      motivo: _motivoController.text.trim(),
      experiencia: _experienciaController.text.trim(),
    );

    setState(() => _cargando = false);

    if (!mounted) return;

    if (resultado["success"] == true) {
      setState(() => _solicitudEnviada = true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✓ Solicitud enviada correctamente"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // ✅ Esperar 1.5 segundos y volver al flujo normal
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        // Volver al home (dos pops: sale de esta vista Y del perfil)
        Navigator.of(context).popUntil((route) => route.isFirst);
        
        // Opcional: mostrar SnackBar en el home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✓ Solicitud enviada. Te notificaremos cuando sea revisada."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado["message"] ?? "Error al enviar solicitud"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_solicitudEnviada) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 80, color: Colors.green),
              ),
              const SizedBox(height: 25),
              const Text(
                "¡Solicitud Enviada!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF8C21)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Tu solicitud será revisada por un administrador. Te notificaremos cuando sea aprobada.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 30),
              // ✅ Indicador de que está redirigiendo
              const CircularProgressIndicator(
                color: Color(0xFFFF8C21),
                strokeWidth: 3,
              ),
              const SizedBox(height: 15),
              Text(
                "Redirigiendo al inicio...",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C21)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Solicitud de Chef",
          style: TextStyle(color: Color(0xFFFF8C21), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono decorativo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.restaurant_menu, size: 60, color: Color(0xFFFF8C21)),
                ),
              ),

              const SizedBox(height: 25),

              // Título y descripción
              const Text(
                "¡Conviértete en Chef!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFF8C21)),
              ),
              const SizedBox(height: 8),
              Text(
                "Completa este formulario para solicitar tu rol de chef en NutriChef. Podrás compartir tus recetas con toda la comunidad.",
                style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
              ),

              const SizedBox(height: 30),

              // Campo: Motivo
              const Text(
                "¿Por qué quieres ser chef?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _motivoController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: "Ej: Me apasiona cocinar y quiero compartir mis recetas favoritas...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFF8C21), width: 2),
                  ),
                  counterStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Por favor, explica tu motivación";
                  }
                  if (value.trim().length < 20) {
                    return "Escribe al menos 20 caracteres";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              // Campo: Experiencia
              const Text(
                "Cuéntanos tu experiencia culinaria (opcional)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _experienciaController,
                maxLines: 3,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: "Ej: 5 años de experiencia en cocina italiana, he trabajado en...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFF8C21), width: 2),
                  ),
                  counterStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),

              const SizedBox(height: 35),

              // Botón de envío
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _enviarSolicitud,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C21),
                    disabledBackgroundColor: Colors.grey[300],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _cargando
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Enviar Solicitud",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Nota informativa
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Tu solicitud será revisada por un administrador. Este proceso puede tardar hasta 48 horas.",
                        style: TextStyle(fontSize: 13, color: Colors.blue[900], height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}