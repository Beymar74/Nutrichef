import 'package:flutter/material.dart';

class InputIngrediente extends StatefulWidget {
  final Function(String unidad, String nombre) onAgregar;
  final VoidCallback onEliminar;
  
  // Listas que vienen del Backend (o vacías si falló)
  final List<String> catalogoIngredientes;
  final List<String> catalogoUnidades;

  const InputIngrediente({
    super.key,
    required this.onAgregar,
    required this.onEliminar,
    required this.catalogoIngredientes,
    required this.catalogoUnidades,
  });

  @override
  State<InputIngrediente> createState() => _InputIngredienteState();
}

class _InputIngredienteState extends State<InputIngrediente> {
  final TextEditingController cantidadCtrl = TextEditingController();
  final TextEditingController unidadCtrl = TextEditingController();
  final TextEditingController ingredienteCtrl = TextEditingController();

  // Helper para construir el campo de texto del Autocomplete con tu estilo exacto
  Widget _buildField(
    BuildContext context, 
    TextEditingController controller, 
    FocusNode focusNode, 
    String hint,
    {VoidCallback? onFieldSubmitted}
  ) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hint,
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
      onSubmitted: (_) => onFieldSubmitted?.call(),
    );
  }

  // Helper para construir las opciones del Autocomplete
  Widget _buildOptionsView(
    BuildContext context, 
    AutocompleteOnSelected<String> onSelected, 
    Iterable<String> options
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final String option = options.elementAt(index);
              return InkWell(
                onTap: () => onSelected(option),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    option, 
                    style: const TextStyle(fontFamily: 'Poppins')
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
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
          // CANTIDAD (solo números) - Sin Autocomplete
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
          // UNIDAD (Autocomplete con datos reales)
          // ----------------------------------------------------
          LayoutBuilder(
            builder: (context, constraints) {
              return Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return widget.catalogoUnidades.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  unidadCtrl.text = selection;
                },
                fieldViewBuilder: (context, textCtrl, focusNode, onSubmitted) {
                  // Sincronizamos controladores
                  textCtrl.text = unidadCtrl.text;
                  // Escuchamos cambios manuales
                  textCtrl.addListener(() {
                    unidadCtrl.text = textCtrl.text;
                  });
                  
                  return _buildField(context, textCtrl, focusNode, "Unidad (g, ml, u...)");
                },
                optionsViewBuilder: (context, onSelected, options) {
                   // Ajustamos el ancho del dropdown al ancho del padre
                   return Align(
                     alignment: Alignment.topLeft,
                     child: Material(
                       elevation: 4.0,
                       borderRadius: BorderRadius.circular(15),
                       child: SizedBox(
                         width: constraints.maxWidth, // Ancho exacto del input
                         height: 200,
                         child: ListView.builder(
                           padding: EdgeInsets.zero,
                           itemCount: options.length,
                           itemBuilder: (BuildContext context, int index) {
                             final String option = options.elementAt(index);
                             return ListTile(
                               title: Text(option, style: const TextStyle(fontFamily: 'Poppins')),
                               onTap: () => onSelected(option),
                             );
                           },
                         ),
                       ),
                     ),
                   );
                },
              );
            }
          ),

          const SizedBox(height: 10),

          // ----------------------------------------------------
          // INGREDIENTE (Autocomplete con datos reales)
          // ----------------------------------------------------
          LayoutBuilder(
            builder: (context, constraints) {
              return Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return widget.catalogoIngredientes.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  ingredienteCtrl.text = selection;
                },
                fieldViewBuilder: (context, textCtrl, focusNode, onSubmitted) {
                  textCtrl.text = ingredienteCtrl.text;
                  textCtrl.addListener(() {
                    ingredienteCtrl.text = textCtrl.text;
                  });
                  return _buildField(context, textCtrl, focusNode, "Ingrediente (Buscar...)");
                },
                optionsViewBuilder: (context, onSelected, options) {
                   return Align(
                     alignment: Alignment.topLeft,
                     child: Material(
                       elevation: 4.0,
                       borderRadius: BorderRadius.circular(15),
                       child: SizedBox(
                         width: constraints.maxWidth,
                         height: 200,
                         child: ListView.builder(
                           padding: EdgeInsets.zero,
                           itemCount: options.length,
                           itemBuilder: (BuildContext context, int index) {
                             final String option = options.elementAt(index);
                             return ListTile(
                               title: Text(option, style: const TextStyle(fontFamily: 'Poppins')),
                               onTap: () => onSelected(option),
                             );
                           },
                         ),
                       ),
                     ),
                   );
                },
              );
            }
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