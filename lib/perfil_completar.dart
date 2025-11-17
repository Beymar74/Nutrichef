import 'package:flutter/material.dart';
import 'services/perfil_service.dart';
import 'nivel_cocina.dart';

class CompletarPerfil extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const CompletarPerfil({super.key, required this.usuario});

  @override
  State<CompletarPerfil> createState() => _CompletarPerfilState();
}

class _CompletarPerfilState extends State<CompletarPerfil> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final persona = widget.usuario["persona"] ?? {};

    _nombreController.text = widget.usuario["name"] ?? "";
    _descripcionController.text =
        widget.usuario["descripcion_perfil"] ??
            widget.usuario["descripcion"] ??
            "";
    _alturaController.text = persona["altura"]?.toString() ?? "";
    _pesoController.text = persona["peso"]?.toString() ?? "";
  }

  Future<void> _continuar() async {
    if (_nombreController.text.trim().isEmpty ||
        _descripcionController.text.trim().isEmpty ||
        _alturaController.text.trim().isEmpty ||
        _pesoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 💡 TOKEN
    final token = widget.usuario["token"];
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ No se encontró token, inicia sesión de nuevo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 🔄 ACTUALIZAR EN BACKEND
    final res = await PerfilService.actualizarPerfil(
      token: token,
      name: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      altura: _alturaController.text.trim(),
      peso: _pesoController.text.trim(),
    );

    if (res["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Perfil actualizado con éxito'),
          backgroundColor: Colors.green,
        ),
      );

      // 🔄 ACTUALIZAR LOCALMENTE
      widget.usuario["name"] = _nombreController.text.trim();
      widget.usuario["descripcion_perfil"] =
          _descripcionController.text.trim();

      widget.usuario["persona"] ??= {};
      widget.usuario["persona"]["altura"] =
          _alturaController.text.trim();
      widget.usuario["persona"]["peso"] =
          _pesoController.text.trim();

      // ⚠ AHORA NAVEGA A LA SIGUIENTE PANTALLA
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NivelCocina(usuario: widget.usuario),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res["message"] ?? '❌ Error al actualizar'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8C21),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Completa Tu Perfil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Personaliza tu experiencia para descubrir recetas recomendadas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // FOTO (NO FUNCIONAL AÚN)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD54F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        size: 60, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF8C21),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit,
                          size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 45),

              campoTexto(
                  "Nombre De Usuario:", _nombreController, "usuario123"),
              campoTexto(
                  "Descripción:", _descripcionController, "Cuéntanos sobre ti"),
              campoTexto("Altura (cm):", _alturaController, "170",
                  tipo: TextInputType.number),
              campoTexto("Peso (Kg):", _pesoController, "65",
                  tipo: TextInputType.number),

              const SizedBox(height: 40),

              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C21),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    'Continuar ➜',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget campoTexto(String label, TextEditingController controller, String hint,
      {TextInputType tipo = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFD54F),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: controller,
            keyboardType: tipo,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
