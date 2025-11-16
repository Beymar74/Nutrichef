import 'package:flutter/material.dart';
import 'services/perfil_service.dart';
import 'alergias.dart';

class TipoDieta extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const TipoDieta({super.key, required this.usuario});

  @override
  State<TipoDieta> createState() => _TipoDietaState();
}

class _TipoDietaState extends State<TipoDieta> {
  int? _dietaSeleccionada; // ⬅️ Ahora es ID

  // 🟢 Lista de dietas con ID y nombre según tu BD
  final List<Map<String, dynamic>> dietas = [
    {"id": 32, "nombre": "OMNIVORA"},
    {"id": 33, "nombre": "VEGETARIANA"},
    {"id": 34, "nombre": "VEGANA"},
    {"id": 35, "nombre": "SIN_GLUTEN"},
    {"id": 36, "nombre": "SIN_LACTOSA"},
    {"id": 37, "nombre": "KETO"},
    {"id": 38, "nombre": "HIPOCALORICA"},
    {"id": 39, "nombre": "HIPERCALORICA"},
  ];

  Future<void> _continuar() async {
    if (_dietaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Selecciona una dieta"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final token = widget.usuario["token"];
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Token no encontrado"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 🛠 Enviar la dieta como ID
    final res = await PerfilService.actualizarDieta(
      token: token,
      dietaId: _dietaSeleccionada!,
    );

    if (res["success"] == true) {
      widget.usuario["id_dieta"] = _dietaSeleccionada;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dieta guardada 🥗"),
          backgroundColor: Colors.green,
        ),
      );

      // 👉 SIGUIENTE PANTALLA
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Alergias(usuario: widget.usuario),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res["message"] ?? "❌ Error al guardar dieta"),
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
            const SizedBox(height: 25),

            const Text(
              "Seleccione Su Tipo De Dieta",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Esto permitirá que NutriChef recomiende recetas adecuadas.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                itemCount: dietas.length,
                itemBuilder: (_, i) {
                  final dieta = dietas[i];
                  final activo = _dietaSeleccionada == dieta["id"];

                  return GestureDetector(
                    onTap: () => setState(() {
                      _dietaSeleccionada = dieta["id"];
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: activo ? Colors.orange : Colors.grey[300]!,
                          width: activo ? 2.5 : 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dieta["nombre"],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: activo ? Colors.orange : Colors.black87,
                            ),
                          ),
                          if (activo)
                            const Icon(Icons.check_circle,
                                color: Colors.orange, size: 24)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    "Continuar ➜",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
