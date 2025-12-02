import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'services/chef_service.dart';
import 'models/chef_receta_model.dart'; // ✅ Importa el modelo correcto

class CrearRecetaScreen extends StatefulWidget {
  final int chefId;
  const CrearRecetaScreen({super.key, required this.chefId});

  @override
  State<CrearRecetaScreen> createState() => _CrearRecetaScreenState();
}

class _CrearRecetaScreenState extends State<CrearRecetaScreen> {
  // CONFIGURACIÓN DE IDs
  static const int ID_ESTADO_BORRADOR = 1;
  static const int ID_ESTADO_PENDIENTE = 5; 

  final _formKey = GlobalKey<FormState>();
  final ChefService _chefService = ChefService();
  
  final _titulo = TextEditingController();
  final _desc = TextEditingController();
  final _tiempo = TextEditingController();
  final _porciones = TextEditingController();
  
  List<PasoForm> _pasos = [PasoForm(1)];
  String _categoria = 'Desayuno';
  File? _imagen;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  void _guardar(bool esBorrador) async {
    if (!esBorrador && !_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String prep = _pasos.map((p) => "${p.num}. ${p.ctrl.text}").join("\n");
      
      Receta nueva = Receta(
        idUsuarioCreador: widget.chefId,
        idEstado: esBorrador ? ID_ESTADO_BORRADOR : ID_ESTADO_PENDIENTE,
        idTipoAlimento: 1, 
        titulo: _titulo.text,
        resumen: _desc.text,
        tiempoPreparacion: int.tryParse(_tiempo.text),
        porcionesEstimadas: int.tryParse(_porciones.text),
        preparacion: prep,
      );

      bool ok = await _chefService.crearReceta(nueva, _imagen);
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(esBorrador ? 'Borrador guardado' : 'Enviado a revisión'),
            backgroundColor: const Color(0xFF4CAF50)
          ));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar'), backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) setState(() => _imagen = File(xfile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Receta', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton.icon(
            onPressed: () => _guardar(true),
            icon: const Icon(Icons.save_as, color: Colors.grey),
            label: const Text('Borrador', style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.orange)) : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200, width: double.infinity, color: Colors.grey[200],
                  child: _imagen != null 
                    ? Image.file(_imagen!, fit: BoxFit.cover) 
                    : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, size: 50, color: Colors.grey), Text("Toca para añadir foto")]),
                ),
              ),
              const SizedBox(height: 20),
              _field(_titulo, 'Título', Icons.title),
              const SizedBox(height: 10),
              _field(_desc, 'Descripción', Icons.description, lines: 3),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _field(_tiempo, 'Minutos', Icons.timer, num: true)),
                const SizedBox(width: 10),
                Expanded(child: _field(_porciones, 'Porciones', Icons.people, num: true)),
              ]),
              const SizedBox(height: 20),
              
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Pasos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add_circle, color: Colors.green), onPressed: () => setState(() => _pasos.add(PasoForm(_pasos.length + 1))))
              ]),
              ..._pasos.map((p) => ListTile(
                leading: CircleAvatar(backgroundColor: Colors.orange, child: Text("${p.num}", style: const TextStyle(color: Colors.white))),
                title: TextField(controller: p.ctrl, decoration: const InputDecoration(hintText: "Instrucción")),
              )),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () => _guardar(false),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C21)),
                  child: const Text('Publicar Receta', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Se enviará a revisión (Pendiente)", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String l, IconData i, {int lines=1, bool num=false}) => TextFormField(
    controller: c, maxLines: lines, keyboardType: num ? TextInputType.number : TextInputType.text,
    validator: (v) => v!.isEmpty ? 'Requerido' : null,
    decoration: InputDecoration(labelText: l, prefixIcon: Icon(i, color: Colors.orange), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
  );
}

class PasoForm {
  int num;
  TextEditingController ctrl = TextEditingController();
  PasoForm(this.num);
  void dispose() => ctrl.dispose();
}
class IngredienteForm { 
  TextEditingController nombre = TextEditingController();
  TextEditingController cantidad = TextEditingController();
  TextEditingController unidad = TextEditingController();
  void dispose() { nombre.dispose(); cantidad.dispose(); unidad.dispose(); }
}