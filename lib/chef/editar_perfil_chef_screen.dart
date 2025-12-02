import 'package:flutter/material.dart';

class EditarPerfilChefScreen extends StatefulWidget {
  final String nombreChef;
  final String emailChef;
  final String? telefono;
  final String? biografia;
  final String? especialidad;

  const EditarPerfilChefScreen({
    Key? key,
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
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _biografiaController = TextEditingController();
  final _especialidadController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.nombreChef;
    _emailController.text = widget.emailChef;
    _telefonoController.text = widget.telefono ?? '';
    _biografiaController.text = widget.biografia ?? '';
    _especialidadController.text = widget.especialidad ?? '';
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simular guardado en API
      await Future.delayed(const Duration(seconds: 2));

      // Aquí iría la llamada al API para actualizar el perfil
      // await _perfilService.actualizarPerfil({
      //   'nombre': _nombreController.text,
      //   'email': _emailController.text,
      //   'telefono': _telefonoController.text,
      //   'biografia': _biografiaController.text,
      //   'especialidad': _especialidadController.text,
      // });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Perfil actualizado exitosamente'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context, true); // Retornar true para indicar que se guardó
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al actualizar perfil: $e'),
            backgroundColor: const Color(0xFFF44336),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF8C21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: _guardarCambios,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar con opción de cambiar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8C21).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _mostrarOpcionesFoto();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8C21),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Sección: Información Personal
              _buildSeccionTitulo('Información Personal'),
              const SizedBox(height: 15),
              
              _buildTextField(
                controller: _nombreController,
                label: 'Nombre completo',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 15),
              
              _buildTextField(
                controller: _emailController,
                label: 'Correo electrónico',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El email es requerido';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 15),
              
              _buildTextField(
                controller: _telefonoController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 30),
              
              // Sección: Información Profesional
              _buildSeccionTitulo('Información Profesional'),
              const SizedBox(height: 15),
              
              _buildTextField(
                controller: _especialidadController,
                label: 'Especialidad culinaria',
                icon: Icons.restaurant,
                hintText: 'Ej: Cocina italiana, Repostería, etc.',
              ),
              
              const SizedBox(height: 15),
              
              _buildTextField(
                controller: _biografiaController,
                label: 'Biografía',
                icon: Icons.description,
                maxLines: 5,
                hintText: 'Cuéntanos sobre tu experiencia como chef...',
              ),
              
              const SizedBox(height: 30),
              
              // Botón de cambiar contraseña
              _buildBotonSecundario(
                icon: Icons.lock,
                texto: 'Cambiar contraseña',
                onTap: _cambiarContrasena,
              ),
              
              const SizedBox(height: 15),
              
              // Botón de eliminar cuenta
              _buildBotonSecundario(
                icon: Icons.delete_forever,
                texto: 'Eliminar cuenta',
                color: const Color(0xFFF44336),
                onTap: _mostrarDialogoEliminarCuenta,
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFEC888D),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFFFF8C21)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF8C21), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF44336)),
        ),
      ),
    );
  }

  Widget _buildBotonSecundario({
    required IconData icon,
    required String texto,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? const Color(0xFFFF8C21);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: buttonColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: buttonColor),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: buttonColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarOpcionesFoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Cambiar foto de perfil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFF8C21)),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                // Implementar toma de foto
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFFF8C21)),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                // Implementar selección de galería
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Color(0xFFF44336)),
              title: const Text('Eliminar foto'),
              onTap: () {
                Navigator.pop(context);
                // Implementar eliminación de foto
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _cambiarContrasena() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.lock,
              color: Color(0xFFFF8C21),
              size: 28,
            ),
            SizedBox(width: 10),
            Text('Cambiar Contraseña'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Contraseña actualizada'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C21),
            ),
            child: const Text(
              'Cambiar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminarCuenta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning,
              color: Color(0xFFF44336),
              size: 28,
            ),
            SizedBox(width: 10),
            Text('Eliminar Cuenta'),
          ],
        ),
        content: const Text(
          '⚠️ Esta acción es permanente e irreversible.\n\n'
          'Se eliminarán todas tus recetas, comentarios y datos.\n\n'
          '¿Estás absolutamente seguro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmarEliminacionCuenta();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminacionCuenta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Escribe "ELIMINAR" para confirmar:'),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: 'ELIMINAR',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí iría la lógica de eliminación
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}