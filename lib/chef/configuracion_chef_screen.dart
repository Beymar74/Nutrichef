import 'package:flutter/material.dart';

class ConfiguracionChefScreen extends StatefulWidget {
  const ConfiguracionChefScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracionChefScreen> createState() => _ConfiguracionChefScreenState();
}

class _ConfiguracionChefScreenState extends State<ConfiguracionChefScreen> {
  // Configuraciones de notificaciones
  bool _notificacionesNuevasRecetas = true;
  bool _notificacionesComentarios = true;
  bool _notificacionesCalificaciones = true;
  bool _notificacionesFavoritos = false;
  bool _notificacionesEmail = true;
  
  // Configuraciones de privacidad
  bool _perfilPublico = true;
  bool _mostrarEmail = false;
  bool _mostrarTelefono = false;
  
  // Configuraciones de la app
  bool _modoOscuro = false;
  String _idioma = 'Español';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF8C21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Notificaciones
            _buildSeccionTitulo(
              'Notificaciones',
              Icons.notifications,
              const Color(0xFFFF8C21),
            ),
            const SizedBox(height: 15),
            _buildSeccionCard([
              _buildSwitchTile(
                'Nuevas recetas',
                'Recibe notificaciones cuando se publiquen nuevas recetas',
                _notificacionesNuevasRecetas,
                (value) => setState(() => _notificacionesNuevasRecetas = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Comentarios',
                'Notificaciones de comentarios en tus recetas',
                _notificacionesComentarios,
                (value) => setState(() => _notificacionesComentarios = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Calificaciones',
                'Notificaciones de nuevas calificaciones',
                _notificacionesCalificaciones,
                (value) => setState(() => _notificacionesCalificaciones = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Favoritos',
                'Cuando alguien marca tu receta como favorita',
                _notificacionesFavoritos,
                (value) => setState(() => _notificacionesFavoritos = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Notificaciones por email',
                'Recibe resumen semanal por correo',
                _notificacionesEmail,
                (value) => setState(() => _notificacionesEmail = value),
              ),
            ]),
            
            const SizedBox(height: 30),
            
            // Sección: Privacidad
            _buildSeccionTitulo(
              'Privacidad y Seguridad',
              Icons.security,
              const Color(0xFF2196F3),
            ),
            const SizedBox(height: 15),
            _buildSeccionCard([
              _buildSwitchTile(
                'Perfil público',
                'Tu perfil será visible para todos los usuarios',
                _perfilPublico,
                (value) => setState(() => _perfilPublico = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Mostrar email',
                'Tu email será visible en tu perfil',
                _mostrarEmail,
                (value) => setState(() => _mostrarEmail = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Mostrar teléfono',
                'Tu teléfono será visible en tu perfil',
                _mostrarTelefono,
                (value) => setState(() => _mostrarTelefono = value),
              ),
              _buildDivider(),
              _buildOpcionTile(
                'Cuentas bloqueadas',
                'Gestionar usuarios bloqueados',
                Icons.block,
                () => _navegarACuentasBloqueadas(),
              ),
              _buildDivider(),
              _buildOpcionTile(
                'Descargar mis datos',
                'Obtén una copia de toda tu información',
                Icons.download,
                () => _descargarDatos(),
              ),
            ]),
            
            const SizedBox(height: 30),
            
            // Sección: Apariencia
            _buildSeccionTitulo(
              'Apariencia',
              Icons.palette,
              const Color(0xFF9C27B0),
            ),
            const SizedBox(height: 15),
            _buildSeccionCard([
              _buildSwitchTile(
                'Modo oscuro',
                'Activa el tema oscuro de la aplicación',
                _modoOscuro,
                (value) => setState(() => _modoOscuro = value),
              ),
              _buildDivider(),
              _buildOpcionTile(
                'Idioma',
                _idioma,
                Icons.language,
                () => _cambiarIdioma(),
              ),
            ]),
            
            const SizedBox(height: 30),
            
            // Sección: Acerca de
            _buildSeccionTitulo(
              'Acerca de',
              Icons.info,
              const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 15),
            _buildSeccionCard([
              _buildOpcionTile(
                'Términos y condiciones',
                'Lee los términos de uso de NutriChef',
                Icons.description,
                () => _abrirTerminos(),
              ),
              _buildDivider(),
              _buildOpcionTile(
                'Política de privacidad',
                'Conoce cómo protegemos tus datos',
                Icons.privacy_tip,
                () => _abrirPrivacidad(),
              ),
              _buildDivider(),
              _buildOpcionTile(
                'Centro de ayuda',
                'Encuentra respuestas a tus preguntas',
                Icons.help,
                () => _abrirAyuda(),
              ),
              _buildDivider(),
              _buildOpcionTile(
                'Reportar un problema',
                'Cuéntanos si algo no funciona bien',
                Icons.bug_report,
                () => _reportarProblema(),
              ),
              _buildDivider(),
              _buildInfoTile(
                'Versión',
                '1.0.0',
                Icons.code,
              ),
            ]),
            
            const SizedBox(height: 30),
            
            // Botón de cerrar sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _cerrarSesion(),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

  Widget _buildSeccionTitulo(String titulo, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEC888D),
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile(
    String titulo,
    String subtitulo,
    bool valor,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: valor,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF8C21),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionTile(
    String titulo,
    String subtitulo,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF8C21)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
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

  Widget _buildInfoTile(String titulo, String valor, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }

  // Métodos de navegación y acciones
  void _navegarACuentasBloqueadas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Cuentas bloqueadas'),
        content: const Text('No tienes cuentas bloqueadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _descargarDatos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(Icons.download, color: Color(0xFFFF8C21)),
            SizedBox(width: 10),
            Text('Descargar datos'),
          ],
        ),
        content: const Text(
          'Recibirás un archivo con toda tu información en tu correo electrónico en las próximas 24-48 horas.',
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
                  content: Text('✅ Solicitud enviada'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C21),
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

  void _cambiarIdioma() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIdiomaOption('Español', 'es'),
            _buildIdiomaOption('English', 'en'),
            _buildIdiomaOption('Português', 'pt'),
          ],
        ),
      ),
    );
  }

  Widget _buildIdiomaOption(String nombre, String codigo) {
    return RadioListTile<String>(
      title: Text(nombre),
      value: nombre,
      groupValue: _idioma,
      activeColor: const Color(0xFFFF8C21),
      onChanged: (value) {
        setState(() => _idioma = value!);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Idioma cambiado a $nombre'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      },
    );
  }

  void _abrirTerminos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí irían los términos y condiciones completos de la aplicación NutriChef...\n\n'
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _abrirPrivacidad() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí iría la política de privacidad completa de la aplicación NutriChef...\n\n'
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _abrirAyuda() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Centro de Ayuda'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preguntas Frecuentes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('• ¿Cómo crear una receta?'),
            Text('• ¿Cómo editar mi perfil?'),
            Text('• ¿Cómo publicar una receta?'),
            Text('• ¿Cómo eliminar mi cuenta?'),
            SizedBox(height: 15),
            Text('Para más información, contacta con soporte@nutrichef.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _reportarProblema() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Reportar Problema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe el problema que encontraste...',
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
                  content: Text('✅ Reporte enviado'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C21),
            ),
            child: const Text(
              'Enviar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.logout,
              color: Color(0xFFF44336),
              size: 28,
            ),
            SizedBox(width: 10),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}