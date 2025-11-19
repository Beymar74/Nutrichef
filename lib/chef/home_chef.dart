import 'package:flutter/material.dart';
import '../services/receta_service.dart';
import '../models/receta_model.dart';
import 'crear_receta.dart';
import 'editar_receta.dart';
import 'ver_receta_chef.dart';
import '../screens/catalogo_recetas.dart';

// Incluir una implementación simple del screen de detalles aquí para evitar
// el error "Target of URI doesn't exist". Si luego se crea el archivo
// detalles_receta.dart, se puede revertir a la importación original.
class DetallesRecetaScreen extends StatelessWidget {
  final Map<String, dynamic> receta;

  const DetallesRecetaScreen({Key? key, required this.receta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titulo = receta['titulo'] ?? 'Receta';
    final resumen = receta['resumen'] ?? '';
    final imagen = receta['imagen'] ??
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800';

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: const Color(0xFFFF8C21),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagen,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              resumen,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            // Puedes mostrar más detalles de la receta si están disponibles en el mapa
          ],
        ),
      ),
    );
  }
}

class HomeChef extends StatefulWidget {
  final String nombreChef;
  final int chefId;

  const HomeChef({
    super.key,
    required this.nombreChef,
    required this.chefId,
  });

  @override
  State<HomeChef> createState() => _HomeChefState();
}

class _HomeChefState extends State<HomeChef> {
  int _selectedIndex = 0;
  final RecetaService _recetaService = RecetaService();
  
  // Listas de recetas
  List<Receta> _misRecetas = [];
  List<Receta> _recetasPublicadas = [];
  List<Receta> _recetasPendientes = [];
  List<Receta> _recetasRechazadas = [];
  List<Receta> _recetasBorrador = [];
  
  bool _isLoading = true;
  
  // Estadísticas
  int _totalVisualizaciones = 0;
  double _calificacionPromedio = 0.0;
  int _totalComentarios = 0;
  int _totalFavoritos = 0;
  
  // Filtro actual
  String _filtroActual = 'Todas';

  @override
  void initState() {
    super.initState();
    _cargarMisRecetas();
  }

  Future<void> _cargarMisRecetas() async {
    try {
      setState(() => _isLoading = true);
      
      // Simular carga de recetas del chef
      // En producción, esto vendría del API con filtro por chef_id
      final todasLasRecetas = await _recetaService.obtenerRecetas();
      
      // Filtrar por chef (simulado)
      _misRecetas = todasLasRecetas;
      
      // Clasificar por estado
      _recetasPublicadas = _misRecetas.where((r) => 
        r.estado == 'PUBLICADA').toList();
      _recetasPendientes = _misRecetas.where((r) => 
        r.estado == 'PENDIENTE_REVISION').toList();
      _recetasRechazadas = _misRecetas.where((r) => 
        r.estado == 'RECHAZADA').toList();
      _recetasBorrador = _misRecetas.where((r) => 
        r.estado == 'BORRADOR').toList();
      
      // Calcular estadísticas
      _calcularEstadisticas();
      
      setState(() => _isLoading = false);
    } catch (e) {
      print('❌ Error al cargar recetas del chef: $e');
      setState(() => _isLoading = false);
    }
  }

  void _calcularEstadisticas() {
    _totalVisualizaciones = _misRecetas.fold(0, 
      (sum, receta) => sum + (receta.visualizaciones ?? 0));
    
    if (_misRecetas.isNotEmpty) {
      _calificacionPromedio = _misRecetas
        .where((r) => r.calificacion != null)
        .fold(0.0, (sum, r) => sum + r.calificacion) / 
        _misRecetas.where((r) => r.calificacion != null).length;
    }
    
    _totalComentarios = _misRecetas.fold(0, 
      (sum, receta) => sum + (receta.totalComentarios ?? 0));
    _totalFavoritos = _misRecetas.fold(0, 
      (sum, receta) => sum + (receta.totalFavoritos ?? 0));
  }

  List<Receta> _obtenerRecetasFiltradas() {
    switch (_filtroActual) {
      case 'Publicadas':
        return _recetasPublicadas;
      case 'Pendientes':
        return _recetasPendientes;
      case 'Rechazadas':
        return _recetasRechazadas;
      case 'Borradores':
        return _recetasBorrador;
      default:
        return _misRecetas;
    }
  }

  void _navegarACrearReceta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearRecetaScreen(chefId: widget.chefId),
      ),
    ).then((_) => _cargarMisRecetas());
  }

  void _navegarAEditarReceta(Receta receta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarRecetaScreen(receta: receta),
      ),
    ).then((_) => _cargarMisRecetas());
  }

  void _onNavBarTap(int index) {
  setState(() {
    _selectedIndex = index;
  });

  switch (index) {
      case 0:
        // Ya estamos en Home Chef
        break;
      case 1:
        // Ver todas las recetas del sistema
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CatalogoRecetasScreen(),
          ),
        );
        break;
      case 2:
        // Estadísticas
        _mostrarEstadisticasCompletas();
        break;
      case 3:
        // Perfil
        break;
    }
  }

  void _mostrarEstadisticasCompletas() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEstadisticasModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF8C21),
                ),
              )
            : RefreshIndicator(
                onRefresh: _cargarMisRecetas,
                color: const Color(0xFFFF8C21),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // HEADER
                        _buildHeader(),
                        
                        const SizedBox(height: 25),

                        // ESTADÍSTICAS RÁPIDAS
                        _buildEstadisticasRapidas(),

                        const SizedBox(height: 25),

                        // ACCIONES RÁPIDAS
                        _buildAccionesRapidas(),

                        const SizedBox(height: 25),

                        // FILTROS DE ESTADO
                        _buildFiltrosEstado(),

                        const SizedBox(height: 20),

                        // TÍTULO SECCIÓN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mis Recetas (${_obtenerRecetasFiltradas().length})',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEC888D),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.sort),
                              color: const Color(0xFFFF8C21),
                              onPressed: () => _mostrarOpcionesOrdenamiento(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // LISTA DE RECETAS
                        if (_obtenerRecetasFiltradas().isEmpty)
                          _buildSinRecetas()
                        else
                          ..._obtenerRecetasFiltradas().map((receta) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _buildRecetaCard(receta),
                          )).toList(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
      ),

      // FLOATING ACTION BUTTON
      
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACrearReceta,
        backgroundColor: const Color(0xFFFF8C21),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar del Chef
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8C21).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant_menu,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 15),
        
        // Saludo y rol
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
              children: [
                Flexible(
                  child: Text(
                    '¡Hola ${widget.nombreChef}!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEC888D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
              const SizedBox(height: 4),
              Text(
                'Panel de Control de Recetas',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        
        // Notificaciones
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: const Color(0xFFFF8C21),
              iconSize: 28,
              onPressed: () {},
            ),
            if (_recetasPendientes.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildEstadisticasRapidas() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C21).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadistica(
                Icons.visibility,
                _totalVisualizaciones.toString(),
                'Vistas',
              ),
              _buildEstadistica(
                Icons.star,
                _calificacionPromedio.toStringAsFixed(1),
                'Rating',
              ),
              _buildEstadistica(
                Icons.comment,
                _totalComentarios.toString(),
                'Comentarios',
              ),
              _buildEstadistica(
                Icons.favorite,
                _totalFavoritos.toString(),
                'Favoritos',
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Barra de progreso de recetas publicadas
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tasa de Publicación',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${_recetasPublicadas.length}/${_misRecetas.length} recetas',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _misRecetas.isEmpty ? 0 : 
                  _recetasPublicadas.length / _misRecetas.length,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadistica(IconData icon, String valor, String titulo) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildAccionesRapidas() {
    return Row(
      children: [
        Expanded(
          child: _buildAccionRapida(
            Icons.add_circle,
            'Nueva\nReceta',
            const Color(0xFF4CAF50),
            _navegarACrearReceta,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAccionRapida(
            Icons.analytics,
            'Ver\nEstadísticas',
            const Color(0xFF2196F3),
            _mostrarEstadisticasCompletas,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAccionRapida(
            Icons.edit_note,
            'Editar\nBorradores',
            const Color(0xFFFFA726),
            () => setState(() => _filtroActual = 'Borradores'),
          ),
        ),
      ],
    );
  }

  Widget _buildAccionRapida(
    IconData icon,
    String texto,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltrosEstado() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFiltroChip('Todas', _misRecetas.length),
          const SizedBox(width: 10),
          _buildFiltroChip('Publicadas', _recetasPublicadas.length, 
            color: const Color(0xFF4CAF50)),
          const SizedBox(width: 10),
          _buildFiltroChip('Pendientes', _recetasPendientes.length,
            color: const Color(0xFFFFA726)),
          const SizedBox(width: 10),
          _buildFiltroChip('Rechazadas', _recetasRechazadas.length,
            color: const Color(0xFFF44336)),
          const SizedBox(width: 10),
          _buildFiltroChip('Borradores', _recetasBorrador.length,
            color: const Color(0xFF9E9E9E)),
        ],
      ),
    );
  }

  Widget _buildFiltroChip(String label, int count, {Color? color}) {
    final isSelected = _filtroActual == label;
    final chipColor = color ?? const Color(0xFFFF8C21);
    
    return GestureDetector(
      onTap: () => setState(() => _filtroActual = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: chipColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : chipColor,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : chipColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? chipColor : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecetaCard(Receta receta) {
    Color estadoColor;
    IconData estadoIcon;
    String estadoTexto = receta.estado ?? 'BORRADOR';
    
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    receta.imagen ?? 
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, size: 30),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                
                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              receta.titulo,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: estadoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  estadoIcon,
                                  size: 14,
                                  color: estadoColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  estadoTexto,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: estadoColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        receta.resumen,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.visibility,
                            '${receta.visualizaciones ?? 0}',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.star,
                            '${receta.calificacion ?? 0}',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.comment,
                            '${receta.totalComentarios ?? 0}',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.favorite,
                            '${receta.totalFavoritos ?? 0}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Acciones
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerRecetaChefScreen(
                          receta: receta,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Ver'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _navegarAEditarReceta(receta),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFFA726),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _mostrarDialogoEliminar(receta),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Eliminar'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF44336),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSinRecetas() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _filtroActual == 'Todas' 
              ? 'No tienes recetas aún'
              : 'No tienes recetas ${_filtroActual.toLowerCase()}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _navegarACrearReceta,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C21),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Crear tu primera receta',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFFFB84D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C00).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, _selectedIndex == 0, 0),
          _buildNavItem(Icons.book, _selectedIndex == 1, 1),
          _buildNavItem(Icons.analytics, _selectedIndex == 2, 2),
          _buildNavItem(Icons.person, _selectedIndex == 3, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, int index) {
    return GestureDetector(
      onTap: () => _onNavBarTap(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEstadisticasModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Contenido
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estadísticas Detalladas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEC888D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Aquí irían gráficos y estadísticas más detalladas
                  _buildEstadisticaDetalle(
                    'Receta más vista',
                    _recetasPublicadas.isNotEmpty ? 
                      _recetasPublicadas.first.titulo : 'N/A',
                    '${_recetasPublicadas.isNotEmpty ? 
                      _recetasPublicadas.first.visualizaciones : 0} vistas',
                    Icons.trending_up,
                    const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 15),
                  _buildEstadisticaDetalle(
                    'Mejor calificada',
                    _recetasPublicadas.isNotEmpty ? 
                      _recetasPublicadas.first.titulo : 'N/A',
                    '⭐ ${_calificacionPromedio.toStringAsFixed(1)}',
                    Icons.star,
                    const Color(0xFFFFA726),
                  ),
                  const SizedBox(height: 15),
                  _buildEstadisticaDetalle(
                    'Más comentada',
                    _recetasPublicadas.isNotEmpty ? 
                      _recetasPublicadas.first.titulo : 'N/A',
                    '${_recetasPublicadas.isNotEmpty ? 
                      _recetasPublicadas.first.totalComentarios : 0} comentarios',
                    Icons.comment,
                    const Color(0xFF2196F3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticaDetalle(
    String titulo,
    String subtitulo,
    String valor,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarOpcionesOrdenamiento() {
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
                'Ordenar por',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Más recientes'),
              onTap: () {
                // Ordenar por fecha
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Más vistas'),
              onTap: () {
                // Ordenar por vistas
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Mejor calificadas'),
              onTap: () {
                // Ordenar por calificación
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text('Más comentadas'),
              onTap: () {
                // Ordenar por comentarios
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar(Receta receta) {
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
            Text('Eliminar Receta'),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${receta.titulo}"?\n\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí iría la lógica de eliminación
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receta eliminada'),
                  backgroundColor: Color(0xFFF44336),
                ),
              );
              _cargarMisRecetas();
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

// Extensión para el modelo Receta
extension RecetaExtensions on Receta {
  // Estados posibles
  String get estado => 'PUBLICADA'; // Simular estado, debería venir del backend
  int? get visualizaciones => 324; // Simular, debería venir del backend
  double? get calificacion => 4.5; // Simular, debería venir del backend
  int? get totalComentarios => 12; // Simular, debería venir del backend
  int? get totalFavoritos => 45; // Simular, debería venir del backend
}