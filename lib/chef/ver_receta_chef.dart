import 'package:flutter/material.dart';
import '../models/receta_model.dart';
import 'editar_receta.dart';

class VerRecetaChefScreen extends StatefulWidget {
  final Receta receta;
  final bool esPropietario;

  const VerRecetaChefScreen({
    Key? key,
    required this.receta,
    this.esPropietario = false,
  }) : super(key: key);

  @override
  State<VerRecetaChefScreen> createState() => _VerRecetaChefScreenState();
}

class _VerRecetaChefScreenState extends State<VerRecetaChefScreen> {
  bool _mostrarIngredientes = true;
  bool _mostrarPasos = true;
  bool _mostrarNutricion = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen
          _buildSliverAppBar(),

          // Contenido
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Header con título y estado
                _buildHeader(),

                // Información básica
                _buildInfoBasica(),

                // Estadísticas del chef
                _buildEstadisticasChef(),

                // Ingredientes
                _buildSeccionIngredientes(),

                // Pasos de preparación
                _buildSeccionPasos(),

                // Información nutricional
                _buildSeccionNutricion(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // Botones de acción flotantes
      bottomNavigationBar: _buildBotonesAccion(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFFFF8C21),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white),
          ),
          onPressed: _compartirReceta,
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_vert, color: Colors.white),
          ),
          onPressed: _mostrarOpciones,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.receta.imagen ??
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant, size: 80),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    Color estadoColor;
    IconData estadoIcon;
    String estadoTexto = widget.receta.estado ?? 'BORRADOR';

    switch (estadoTexto) {
      case 'PUBLICADA':
        estadoColor = const Color(0xFF4CAF50);
        estadoIcon = Icons.check_circle;
        break;
      case 'PENDIENTE_REVISION':
        estadoColor = const Color(0xFFFFA726);
        estadoIcon = Icons.schedule;
        break;
      case 'RECHAZADA':
        estadoColor = const Color(0xFFF44336);
        estadoIcon = Icons.cancel;
        break;
      default:
        estadoColor = const Color(0xFF9E9E9E);
        estadoIcon = Icons.edit;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: estadoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: estadoColor, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(estadoIcon, size: 16, color: estadoColor),
                const SizedBox(width: 6),
                Text(
                  estadoTexto,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: estadoColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Título
          Text(
            widget.receta.titulo,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEC888D),
            ),
          ),
          const SizedBox(height: 8),

          // Descripción/Resumen
          Text(
            widget.receta.resumen,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBasica() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            Icons.access_time,
            '30 min',
            'Tiempo',
            const Color(0xFFFF8C21),
          ),
          _buildInfoItem(
            Icons.restaurant,
            '4 porciones',
            'Porciones',
            const Color(0xFF4CAF50),
          ),
          _buildInfoItem(
            Icons.bar_chart,
            'Media',
            'Dificultad',
            const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String valor, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEstadisticasChef() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C21).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas de la Receta',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadisticaItem(
                Icons.visibility,
                '${widget.receta.visualizaciones ?? 0}',
                'Vistas',
              ),
              _buildEstadisticaItem(
                Icons.star,
                '${widget.receta.calificacion ?? 0}',
                'Rating',
              ),
              _buildEstadisticaItem(
                Icons.comment,
                '${widget.receta.totalComentarios ?? 0}',
                'Comentarios',
              ),
              _buildEstadisticaItem(
                Icons.favorite,
                '${widget.receta.totalFavoritos ?? 0}',
                'Favoritos',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticaItem(IconData icon, String valor, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionIngredientes() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _mostrarIngredientes = !_mostrarIngredientes),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C21).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shopping_basket,
                      color: Color(0xFFFF8C21),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEC888D),
                      ),
                    ),
                  ),
                  Icon(
                    _mostrarIngredientes
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFFFF8C21),
                  ),
                ],
              ),
            ),
          ),
          if (_mostrarIngredientes)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildIngredienteItem('Tomates', '4 unidades'),
                  _buildIngredienteItem('Cebolla', '1 unidad'),
                  _buildIngredienteItem('Ajo', '3 dientes'),
                  _buildIngredienteItem('Aceite de oliva', '2 cucharadas'),
                  _buildIngredienteItem('Sal', 'Al gusto'),
                  _buildIngredienteItem('Pimienta', 'Al gusto'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIngredienteItem(String nombre, String cantidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFF8C21),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nombre,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            cantidad,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionPasos() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _mostrarPasos = !_mostrarPasos),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.format_list_numbered,
                      color: Color(0xFF4CAF50),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pasos de Preparación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEC888D),
                      ),
                    ),
                  ),
                  Icon(
                    _mostrarPasos
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
          ),
          if (_mostrarPasos)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildPasoItem(
                    1,
                    'Picar finamente la cebolla y el ajo.',
                  ),
                  _buildPasoItem(
                    2,
                    'Calentar el aceite en una sartén a fuego medio.',
                  ),
                  _buildPasoItem(
                    3,
                    'Sofreír la cebolla y el ajo hasta que estén dorados.',
                  ),
                  _buildPasoItem(
                    4,
                    'Agregar los tomates picados y cocinar por 10 minutos.',
                  ),
                  _buildPasoItem(
                    5,
                    'Sazonar con sal y pimienta al gusto. Servir caliente.',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPasoItem(int numero, String descripcion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$numero',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                descripcion,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionNutricion() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _mostrarNutricion = !_mostrarNutricion),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.pie_chart,
                      color: Color(0xFF2196F3),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Información Nutricional',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEC888D),
                      ),
                    ),
                  ),
                  Icon(
                    _mostrarNutricion
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF2196F3),
                  ),
                ],
              ),
            ),
          ),
          if (_mostrarNutricion)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildNutricionItem('Calorías', '250 kcal', 0.6),
                  _buildNutricionItem('Proteínas', '12 g', 0.4),
                  _buildNutricionItem('Carbohidratos', '30 g', 0.5),
                  _buildNutricionItem('Grasas', '8 g', 0.3),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutricionItem(String nombre, String valor, double porcentaje) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                valor,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: porcentaje,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion() {
  // Si NO es el propietario, mostrar botones de usuario normal
  // Si NO es el propietario, mostrar botón de favorito
if (!widget.esPropietario) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agregado a favoritos'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      },
      icon: const Icon(Icons.favorite_border, size: 22),
      label: const Text(
        'Agregar a Favoritos',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8C21),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    ),
  );
}

  // Si ES el propietario, mostrar botones de editar/eliminar
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _navegarAEditar,
            icon: const Icon(Icons.edit, size: 20),
            label: const Text(
              'Editar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C21),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _mostrarDialogoEliminar,
          icon: const Icon(Icons.delete, size: 20),
          label: const Text(
            'Eliminar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFF44336),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            side: const BorderSide(
              color: Color(0xFFF44336),
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ),
  );
}
  void _compartirReceta() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de compartir en desarrollo'),
        backgroundColor: Color(0xFFFF8C21),
      ),
    );
  }

  void _mostrarOpciones() {
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
            ListTile(
              leading: const Icon(Icons.copy, color: Color(0xFFFF8C21)),
              title: const Text('Duplicar receta'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive, color: Color(0xFF9E9E9E)),
              title: const Text('Archivar'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Color(0xFFF44336)),
              title: const Text('Reportar problema'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navegarAEditar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarRecetaScreen(receta: widget.receta),
      ),
    ).then((_) {
      // Recargar datos si es necesario
      setState(() {});
    });
  }

  void _mostrarDialogoEliminar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFF44336), size: 28),
            SizedBox(width: 10),
            Text('Eliminar Receta'),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${widget.receta.titulo}"?\n\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Volver a home
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receta eliminada'),
                  backgroundColor: Color(0xFFF44336),
                ),
              );
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
}