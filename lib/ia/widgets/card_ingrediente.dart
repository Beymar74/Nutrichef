import 'package:flutter/material.dart';

class CardIngrediente extends StatefulWidget {
  final String unidad;
  final String nombre;
  final Function(String nuevoTexto) onEditar;
  final VoidCallback onEliminar;

  const CardIngrediente({
    super.key,
    required this.unidad,
    required this.nombre,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  State<CardIngrediente> createState() => _CardIngredienteState();
}

class _CardIngredienteState extends State<CardIngrediente> {
  bool _editando = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nombre);
  }

  @override
  Widget build(BuildContext context) {
    const Color naranja = Color(0xFFFF8C21);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: naranja.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // --- Unidad ---
          Expanded(
            flex: 2,
            child: Text(
              widget.unidad,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color(0xFF5E5E5E),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // --- Nombre o campo editable ---
          Expanded(
            flex: 4,
            child: _editando
                ? TextField(
                    controller: _controller,
                    autofocus: true,
                    onSubmitted: (value) {
                      setState(() => _editando = false);
                      widget.onEditar(value);
                    },
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Color(0xFF5E5E5E),
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    widget.nombre,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
          ),

          // --- Botón editar ---
          IconButton(
            icon: Icon(
              _editando ? Icons.check_circle_outline : Icons.edit,
              color: naranja,
              size: 20,
            ),
            onPressed: () {
              if (_editando) {
                widget.onEditar(_controller.text);
              }
              setState(() => _editando = !_editando);
            },
          ),

          // --- Botón eliminar ---
          IconButton(
            icon: const Icon(Icons.delete, color: naranja, size: 20),
            onPressed: widget.onEliminar,
          ),
        ],
      ),
    );
  }
}
