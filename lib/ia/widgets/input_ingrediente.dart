import 'package:flutter/material.dart';

class InputIngrediente extends StatefulWidget {
  final Function(String unidad, String nombre) onAgregar;
  final VoidCallback onEliminar;

  const InputIngrediente({
    super.key,
    required this.onAgregar,
    required this.onEliminar,
  });

  @override
  State<InputIngrediente> createState() => _InputIngredienteState();
}

class _InputIngredienteState extends State<InputIngrediente> {
  final TextEditingController cantidadCtrl = TextEditingController();
  final TextEditingController unidadCtrl = TextEditingController();
  final TextEditingController ingredienteCtrl = TextEditingController();

  // -----------------------------
  // LISTA BASE UNIDADES
  // -----------------------------
  final List<String> unidadesBase = [
    'g',
    'kg',
    'ml',
    'l',
    'u',
    'cda',
    'cdta',
    'taza',
    'pizca',
  ];

  // -----------------------------
  // LISTA BASE INGREDIENTES
  // -----------------------------
  final List<String> ingredientesBase = [
    'Harina',
    'Huevo',
    'Leche',
    'Queso',
    'Quesillo',
    'Tomate',
    'Cebolla',
    'Azúcar',
    'Sal',
    'Aceite',
    'Pollo',
    'Carne',
    'Mantequilla',
    'Arroz',
    'Papa',
  ];

  List<String> unidadesFiltradas = [];
  List<String> ingredientesFiltrados = [];

  @override
  void initState() {
    super.initState();
    unidadesFiltradas = unidadesBase;
    ingredientesFiltrados = ingredientesBase;
  }

  // Filtra lista según lo que escribe el usuario
  void filtrarUnidades(String texto) {
    setState(() {
      unidadesFiltradas = unidadesBase
          .where((u) => u.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
  }

  void filtrarIngredientes(String texto) {
    setState(() {
      ingredientesFiltrados = ingredientesBase
          .where((i) => i.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB81C),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        children: [
          // ----------------------------------------------------
          // CANTIDAD (solo números)
          // ----------------------------------------------------
          TextField(
            controller: cantidadCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Cantidad",
              hintStyle: const TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: Colors.orange.shade200,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // ----------------------------------------------------
          // UNIDAD (lista filtrable)
          // ----------------------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: unidadCtrl,
                onChanged: filtrarUnidades,
                decoration: InputDecoration(
                  hintText: "Unidad (g, ml, u...)",
                  hintStyle: const TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: Colors.orange.shade200,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),

              if (unidadCtrl.text.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: unidadesFiltradas.map((u) {
                      return ListTile(
                        dense: true,
                        title: Text(
                          u,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        onTap: () {
                          unidadCtrl.text = u;
                          FocusScope.of(context).unfocus();
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // ----------------------------------------------------
          // INGREDIENTE (lista filtrable)
          // ----------------------------------------------------
          Column(
            children: [
              TextField(
                controller: ingredienteCtrl,
                onChanged: filtrarIngredientes,
                decoration: InputDecoration(
                  hintText: "Ingrediente",
                  hintStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: Colors.orange.shade200,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),

              if (ingredienteCtrl.text.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: ingredientesFiltrados.map((i) {
                      return ListTile(
                        dense: true,
                        title: Text(i, style: const TextStyle(fontFamily: 'Poppins')),
                        onTap: () {
                          ingredienteCtrl.text = i;
                          FocusScope.of(context).unfocus();
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // ----------------------------------------------------
          // BOTÓNES
          // ----------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CANCELAR
              GestureDetector(
                onTap: widget.onEliminar,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              // AÑADIR
              GestureDetector(
                onTap: () {
                  if (cantidadCtrl.text.isEmpty ||
                      unidadCtrl.text.isEmpty ||
                      ingredienteCtrl.text.isEmpty) return;

                  widget.onAgregar(
                    unidadCtrl.text,
                    ingredienteCtrl.text,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C21),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "Añadir",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
