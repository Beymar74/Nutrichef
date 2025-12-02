import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'services/chef_service.dart';
import 'models/chef_receta_model.dart'; // ✅ Importa el modelo correcto

class EditarRecetaScreen extends StatefulWidget {
  final Receta receta;
  const EditarRecetaScreen({super.key, required this.receta});

  @override
  State<EditarRecetaScreen> createState() => _EditarRecetaScreenState();
}

class _EditarRecetaScreenState extends State<EditarRecetaScreen> {
  final _chefService = ChefService();
  late TextEditingController _titulo;
  late TextEditingController _desc;
  late TextEditingController _prep;
  
  File? _newImg;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.receta.titulo);
    _desc = TextEditingController(text: widget.receta.resumen);
    _prep = TextEditingController(text: widget.receta.preparacion);
  }

  void _guardar() async {
    setState(() => _loading = true);
    Receta up = Receta(
      id: widget.receta.id,
      idUsuarioCreador: widget.receta.idUsuarioCreador,
      idEstado: widget.receta.idEstado,
      idTipoAlimento: widget.receta.idTipoAlimento,
      titulo: _titulo.text,
      resumen: _desc.text,
      preparacion: _prep.text,
      // ... otros campos
    );

    bool ok = await _chefService.actualizarReceta(up, _newImg);
    if (mounted) {
      setState(() => _loading = false);
      if (ok) Navigator.pop(context, true);
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al actualizar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Receta"), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _field(_titulo, "Título"),
          const SizedBox(height: 10),
          _field(_desc, "Resumen", lines: 3),
          const SizedBox(height: 10),
          _field(_prep, "Preparación (Pasos)", lines: 10),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _guardar, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), child: const Text("Guardar Cambios", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String l, {int lines=1}) => TextField(controller: c, maxLines: lines, decoration: InputDecoration(labelText: l, border: const OutlineInputBorder()));
}