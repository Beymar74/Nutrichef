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
    {'cantidad': "100", 'unidad': 'g', 'nombre': 'Harina'},
    {'cantidad': "2", 'unidad': 'u', 'nombre': 'Huevos'},
    {'cantidad': "200", 'unidad': 'ml', 'nombre': 'Leche'},
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

  // ------------------------------------------------------------------
  //                MOSTRAR DIALOGO ELIMINAR DESDE ABAJO
  // ------------------------------------------------------------------
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

  // ------------------------------------------------------------------
  //                  VALIDAR INGREDIENTES NUEVOS
  // ------------------------------------------------------------------
  bool _yaExiste(String nombre) {
    return ingredientes.any(
      (item) => item['nombre']!.toLowerCase() == nombre.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double botonAncho = MediaQuery.of(context).size.width * 0.70;

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

      // =====================================================================
      //                                BODY
      // =====================================================================
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

            // ------------------------------------------------------------------
            //                LISTA DE INGREDIENTES
            // ------------------------------------------------------------------
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: ingredientes.length,
                itemBuilder: (context, index) {
                  final item = ingredientes[index];

                  return CardIngrediente(
                    cantidad: item['cantidad']!,
                    unidad: item['unidad']!,
                    nombre: item['nombre']!,
                    onEditar:
                        (nuevoCantidad, nuevaUnidad, nuevoNombre) {
                      setState(() {
                        ingredientes[index]['cantidad'] = nuevoCantidad;
                        ingredientes[index]['unidad'] = nuevaUnidad;
                        ingredientes[index]['nombre'] = nuevoNombre;
                      });
                    },
                    onEliminar: () => _mostrarDialogoEliminar(index),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------------------------
            //             ANIMACIÓN DE INPUT (AÑADIR INGREDIENTE)
            // ------------------------------------------------------------------
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _mostrarInput
                  ? InputIngrediente(
                      key: const ValueKey("inputIngrediente"),
                      onAgregar: (unidad, nombre) {
                        if (_yaExiste(nombre)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Este ingrediente ya existe."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          ingredientes.add({
                            'cantidad': "1",
                            'unidad': unidad,
                            'nombre': nombre,
                          });
                          _mostrarInput = false;
                        });
                      },
                      onEliminar: () {
                        setState(() => _mostrarInput = false);
                      },
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------------------------
            //                   BOTÓN + AÑADIR INGREDIENTE
            // ------------------------------------------------------------------
            Center(
              child: SizedBox(
                width: botonAncho,
                child: ElevatedButton(
                  onPressed: () => setState(() => _mostrarInput = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C21),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '+ Añadir Ingrediente',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------------------------
            //                       BOTÓN CONFIRMAR
            // ------------------------------------------------------------------
            Center(
              child: SizedBox(
                width: botonAncho,
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
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
