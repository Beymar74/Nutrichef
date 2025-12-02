import 'package:flutter/material.dart';
import 'services/chef_service.dart';

class EditarPerfilChefScreen extends StatefulWidget {
  final int chefId;
  final String nombreChef;
  final String emailChef;
  final String? telefono;
  final String? biografia;
  final String? especialidad;

  const EditarPerfilChefScreen({
    Key? key,
    required this.chefId,
    required this.nombreChef,
    required this.emailChef,
    this.telefono,
    this.biografia,
    this.especialidad,
  }) : super(key: key);

  @override
  State<EditarPerfilChefScreen> createState() => _EditarPerfilChefScreenState();
}

class _EditarPerfilChefScreenState extends State<EditarPerfilChefScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChefService _chefService = ChefService();

  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _biografiaController;
  late TextEditingController _especialidadController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreChef);
    _emailController = TextEditingController(text: widget.emailChef);
    _telefonoController = TextEditingController(text: widget.telefono ?? '');
    _biografiaController = TextEditingController(text: widget.biografia ?? '');
    _especialidadController = TextEditingController(text: widget.especialidad ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _biografiaController.dispose();
    _especialidadController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final datos = {
        'nombre': _nombreController.text,
        'email': _emailController.text,
        'telefono': _telefonoController.text,
        'biografia': _biografiaController.text,
        'especialidad': _especialidadController.text,
      };

      bool exito = await _chefService.actualizarPerfil(widget.chefId, datos);

      if (mounted) {
        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Perfil actualizado correctamente'), backgroundColor: Color(0xFF4CAF50)),
          );
          // ✅ AQUÍ EL CAMBIO: Devolvemos los datos nuevos a la pantalla anterior
          Navigator.pop(context, datos); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Error al actualizar perfil'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ... (El resto de tu método build y widgets _buildTextField se mantienen IGUALES)
  // COPIA AQUÍ EL RESTO DEL ARCHIVO QUE YA TENÍAS PARA NO PERDER EL DISEÑO
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF8C21),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))))
          else
            TextButton.icon(onPressed: _guardarCambios, icon: const Icon(Icons.check, color: Colors.white), label: const Text('Guardar', style: TextStyle(color: Colors.white))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(radius: 60, backgroundColor: Colors.orange, child: Icon(Icons.person, size: 60, color: Colors.white)),
              const SizedBox(height: 30),
              
              _buildSeccionTitulo('Información Personal'),
              const SizedBox(height: 15),
              _buildTextField(controller: _nombreController, label: 'Nombre completo', icon: Icons.person),
              const SizedBox(height: 15),
              _buildTextField(controller: _emailController, label: 'Email', icon: Icons.email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildTextField(controller: _telefonoController, label: 'Teléfono', icon: Icons.phone, keyboardType: TextInputType.phone),
              
              const SizedBox(height: 30),
              _buildSeccionTitulo('Información Profesional'),
              const SizedBox(height: 15),
              _buildTextField(controller: _especialidadController, label: 'Especialidad', icon: Icons.restaurant),
              const SizedBox(height: 15),
              _buildTextField(controller: _biografiaController, label: 'Biografía', icon: Icons.description, maxLines: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionTitulo(String t) => Align(alignment: Alignment.centerLeft, child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC888D))));
  
  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller, maxLines: maxLines, keyboardType: keyboardType,
      validator: (v) => v!.isEmpty ? 'Requerido' : null,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: Colors.orange), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
    );
  }
}