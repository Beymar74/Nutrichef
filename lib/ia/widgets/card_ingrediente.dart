import 'package:flutter/material.dart';

class CardIngrediente extends StatefulWidget {
  final String unidad;
  final String nombre;
  final String cantidad;
  final Function(String nuevaCantidad, String nuevaUnidad, String nuevoNombre) onEditar;
  final VoidCallback onEliminar;

  const CardIngrediente({
    super.key,
    required this.unidad,
    required this.nombre,
    required this.cantidad,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  State<CardIngrediente> createState() => _CardIngredienteState();
}

class _CardIngredienteState extends State<CardIngrediente> {
  bool _editando = false;

  late TextEditingController cantidadCtrl;
  late TextEditingController unidadCtrl;
  late TextEditingController ingredienteCtrl;

  // ---------------------------------------------------------
  //   LISTAS PARA AUTOCOMPLETADO
  // ---------------------------------------------------------

  final List<String> unidades = [
    "g",
    "kg",
    "ml",
    "l",
    "cucharadas",
    "cucharaditas",
    "pizca",
    "taza",
    "u",  // unidades enteras
  ];

  final List<String> ingredientesLista = [
    "Harina",
    "Azúcar",
    "Leche",
    "Huevos",
    "Queso",
    "Quesillo",
    "Pollo",
    "Carne",
    "Sal",
    "Aceite",
    "Tomate",
    "Cebolla",
  ];

  @override
  void initState() {
    super.initState();
    cantidadCtrl = TextEditingController(text: widget.cantidad);
    unidadCtrl = TextEditingController(text: widget.unidad);
    ingredienteCtrl = TextEditingController(text: widget.nombre);
  }

  @override
  void dispose() {
    cantidadCtrl.dispose();
    unidadCtrl.dispose();
    ingredienteCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------
  //   WIDGET AUTOCOMPLETE (FILTRABLE)
  // ---------------------------------------------------------
  Widget _comboEditable({
    required TextEditingController controller,
    required List<String> opciones,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) return opciones;
        return opciones
            .where((item) => item.toLowerCase().contains(value.text.toLowerCase()))
            .toList();
      },
      fieldViewBuilder: (context, textCtrl, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textCtrl,
          focusNode: focusNode,
          style: const TextStyle(fontFamily: "Poppins"),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
          ),
        );
      },
      onSelected: (value) {
        controller.text = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFC48A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // ---------------------------------------------------------
          //    MODO EDICIÓN
          // ---------------------------------------------------------
          if (_editando)
            Expanded(
              child: Row(
                children: [
                  // Cantidad numérica
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: cantidadCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontFamily: "Poppins"),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),

                  // Unidad (autocomplete)
                  Expanded(
                    flex: 1,
                    child: _comboEditable(
                      controller: unidadCtrl,
                      opciones: unidades,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Ingrediente (autocomplete)
                  Expanded(
                    flex: 2,
                    child: _comboEditable(
                      controller: ingredienteCtrl,
                      opciones: ingredientesLista,
                    ),
                  ),
                ],
              ),
            )
          else
            // ---------------------------------------------------------
            //    MODO NORMAL (TEXTO FIJO)
            // ---------------------------------------------------------
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 65,
                    child: Text(
                      widget.cantidad,
                      style: const TextStyle(fontFamily: "Poppins"),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      widget.unidad,
                      style: const TextStyle(fontFamily: "Poppins"),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.nombre,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ---------------------------------------------------------
          //   BOTÓN GUARDAR / EDITAR
          // ---------------------------------------------------------
          IconButton(
            icon: Icon(
              _editando ? Icons.check_circle : Icons.edit,
              color: _editando ? Colors.green : const Color(0xFFFF8C21),
            ),
            onPressed: () {
              if (_editando) {
                widget.onEditar(
                  cantidadCtrl.text,
                  unidadCtrl.text,
                  ingredienteCtrl.text,
                );
              }
              setState(() => _editando = !_editando);
            },
          ),

          // ---------------------------------------------------------
          //   BOTÓN ELIMINAR
          // ---------------------------------------------------------
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.orange),
            onPressed: widget.onEliminar,
          ),
        ],
      ),
    );
  }
}
