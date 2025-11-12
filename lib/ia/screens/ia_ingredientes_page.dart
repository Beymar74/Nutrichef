import 'package:flutter/material.dart';
import '../widgets/dialogo_alerta.dart';
import '../widgets/dialogo_eliminar.dart';
import '../widgets/input_ingrediente.dart';
import '../widgets/card_ingrediente.dart';
import 'ia_recetas_page.dart';

class IaIngredientesPage extends StatefulWidget {
  const IaIngredientesPage({super.key});

  @override
  State<IaIngredientesPage> createState() => _IaIngredientesPageState();
}

class _IaIngredientesPageState extends State<IaIngredientesPage> {
  bool _alertaMostrada = false;
  bool _mostrarInput = false;

  List<Map<String, String>> ingredientes = [
    {'unidad': '100g', 'nombre': 'Harina'},
    {'unidad': '2', 'nombre': 'Huevos'},
    {'unidad': '200ml', 'nombre': 'Leche'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_alertaMostrada) {
      _alertaMostrada = true;
      Future.delayed(const Duration(milliseconds: 400), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => DialogoAlerta(
            ingrediente: 'Almendra',
            onContinuar: () => Navigator.pop(context),
          ),
        );
      });
    }
  }

  void _mostrarDialogoEliminar(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DialogoEliminar(
        onConfirmar: () {
          setState(() {
            ingredientes.removeAt(index);
          });
          Navigator.pop(context);
        },
        onCancelar: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ingredientes',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF8C21),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hemos identificado los siguientes ingredientes. '
              'Si falta alguno añádelo, si hay alguno erróneo edítalo:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 15),

            // --- Lista de ingredientes ---
            Expanded(
              child: ListView.builder(
                itemCount: ingredientes.length,
                itemBuilder: (context, index) {
                  final item = ingredientes[index];
                  return CardIngrediente(
                    unidad: item['unidad']!,
                    nombre: item['nombre']!,
                    onEditar: (nuevoTexto) {
                      setState(() {
                        ingredientes[index]['nombre'] = nuevoTexto;
                      });
                    },
                    onEliminar: () => _mostrarDialogoEliminar(index),
                  );
                },
              ),
            ),

            // --- Input para añadir ingredientes ---
            if (_mostrarInput)
              InputIngrediente(
                onAgregar: (unidad, nombre) {
                  setState(() {
                    ingredientes.add({'unidad': unidad, 'nombre': nombre});
                    _mostrarInput = false;
                  });
                },
                onEliminar: () {
                  setState(() {
                    _mostrarInput = false;
                  });
                },
              ),

            // --- Botón Añadir Ingrediente ---
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _mostrarInput = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 12),
                ),
                child: const Text(
                  '+ Añadir Ingrediente',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // --- Botón confirmar ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IaRecetasPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
