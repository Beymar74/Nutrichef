import 'package:flutter/material.dart';
import 'services/perfil_service.dart';
import 'home.dart';

class Alergias extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const Alergias({super.key, required this.usuario});

  @override
  State<Alergias> createState() => _AlergiasState();
}

class _AlergiasState extends State<Alergias> {
  /// 🔥 Alergenos con IDs reales de tu BD
  final List<Map<String, dynamic>> _alergenos = [
    {'nombre': 'Leche', 'id': 45, 'imagen': 'assets/images/leche.png', 'seleccionado': false},
    {'nombre': 'Huevos', 'id': 46, 'imagen': 'assets/images/huevo.png', 'seleccionado': false},
    {'nombre': 'Maní', 'id': 47, 'imagen': 'assets/images/mani.png', 'seleccionado': false},
    {'nombre': 'Trigo', 'id': 44, 'imagen': 'assets/images/trigo.png', 'seleccionado': false},
    {'nombre': 'Camarones', 'id': 49, 'imagen': 'assets/images/camarones.png', 'seleccionado': false},
    {'nombre': 'Frutos Secos', 'id': 48, 'imagen': 'assets/images/nuez.png', 'seleccionado': false},
  ];

  final TextEditingController _otrosController = TextEditingController();
  bool _noTengoAlergias = false;

  void _toggleAlergeno(int index) {
    setState(() {
      _alergenos[index]['seleccionado'] = !_alergenos[index]['seleccionado'];
      if (_alergenos[index]['seleccionado']) {
        _noTengoAlergias = false;
      }
    });
  }

  void _toggleNoAlergias(bool? value) {
    setState(() {
      _noTengoAlergias = value ?? false;
      if (_noTengoAlergias) {
        for (var a in _alergenos) {
          a['seleccionado'] = false;
        }
        _otrosController.clear();
      }
    });
  }

  Future<void> _continuar() async {
    final token = widget.usuario["token"];

    /// 🧠 Convertimos selección → IDs reales
    List<int> alergiasIds = [];

    if (!_noTengoAlergias) {
      for (var a in _alergenos) {
        if (a['seleccionado']) {
          alergiasIds.add(a["id"]);
        }
      }
    }

    /// ⚠ Validación visual
    if (!_noTengoAlergias && alergiasIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona tus alergias o marca "No tengo alergias"'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    /// 🟢 Enviar al backend
    final res = await PerfilService.actualizarAlergias(
      token: token,
      alergiasIds: alergiasIds,  // 🔄 Lista de IDs
    );

    if (res["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Alergias guardadas correctamente 🧬"),
          backgroundColor: Colors.green,
        ),
      );

      /// 👉 ÚLTIMA PANTALLA → HOME
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Home(usuario: widget.usuario),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res["message"] ?? "❌ Error guardando alergias"),
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

            // 🔙 ATRÁS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color(0xFFFF8C21), size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            /// Progreso e instrucciones
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.75,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFFFF8C21)),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¿Tienes Alguna Alergia?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Selecciona los ingredientes que debes evitar. NutriChef los excluirá automáticamente.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _alergenos.length,
                      itemBuilder: (context, i) => _buildAlergenoCard(i),
                    ),

                    const SizedBox(height: 30),

                    CheckboxListTile(
                      value: _noTengoAlergias,
                      onChanged: _toggleNoAlergias,
                      activeColor: const Color(0xFFFF8C21),
                      title: const Text("No tengo ninguna alergia"),
                    ),

                    const SizedBox(height: 40),
                  ],
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Finalizar',
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

  Widget _buildAlergenoCard(int i) {
    final a = _alergenos[i];
    final sel = a['seleccionado'];

    return GestureDetector(
      onTap: () => _toggleAlergeno(i),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: sel ? const Color(0xFFFF8C21) : Colors.grey,
            width: sel ? 2.5 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(a['imagen'], width: 65, height: 65),
            const SizedBox(height: 8),
            Text(
              a['nombre'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: sel ? const Color(0xFFFF8C21) : Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}
