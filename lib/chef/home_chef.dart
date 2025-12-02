import 'package:flutter/material.dart';
import '../services/receta_service.dart';
import '../models/receta_model.dart';
import 'crear_receta.dart';
import 'editar_receta.dart';
import '../screens/catalogo_recetas.dart';
import 'estadisticas_chef_screen.dart';
import 'perfil_chef_screen.dart';
import 'receta_card_widget.dart';

class HomeChef extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const HomeChef({
    super.key,
    required this.usuario,
  });

  @override
  State<HomeChef> createState() => _HomeChefState();
}

class _HomeChefState extends State<HomeChef> {
  int _selectedIndex = 0;
  final RecetaService _recetaService = RecetaService();
  
  // Variables extraídas del usuario
  late String nombreChef;
  late int chefId;
  late String emailChef;
  
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
    _extraerDatosUsuario();
    _cargarMisRecetas();
  }

  void _extraerDatosUsuario() {
    nombreChef = widget.usuario['name'] ?? 
                 widget.usuario['nombres'] ?? 
                 'Chef';
    chefId = widget.usuario['id'] ?? 0;
    emailChef = widget.usuario['email'] ?? '';
    
    print('🔍 Datos del Chef:');
    print('   Nombre: $nombreChef');
    print('   ID: $chefId');
    print('   Email: $emailChef');
  }

  Future<void> _cargarMisRecetas() async {
    try {
      setState(() => _isLoading = true);
      
      final todasLasRecetas = await _recetaService.obtenerRecetas();
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
        .fold(0.0, (sum, r) => sum + r.calificacion!) / 
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
        builder: (context) => CrearRecetaScreen(chefId: chefId),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EstadisticasChefScreen(
              misRecetas: _misRecetas,
              recetasPublicadas: _recetasPublicadas,
              totalVisualizaciones: _totalVisualizaciones,
              calificacionPromedio: _calificacionPromedio,
              totalComentarios: _totalComentarios,
              totalFavoritos: _totalFavoritos,
            ),
          ),
        );
        break;
      case 3:
        // Perfil
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PerfilChefScreen(
              nombreChef: nombreChef,
              chefId: chefId,
              emailChef: emailChef,
              totalRecetas: _misRecetas.length,
              recetasPublicadas: _recetasPublicadas.length,
              calificacionPromedio: _calificacionPromedio,
            ),
          ),
        );
        break;
    }
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
                        _buildHeader(),
                        const SizedBox(height: 25),
                        _buildEstadisticasRapidas(),
                        const SizedBox(height: 25),
                        _buildAccionesRapidas(),
                        const SizedBox(height: 25),
                        _buildFiltrosEstado(),
                        const SizedBox(height: 20),
                        _buildTituloSeccion(),
                        const SizedBox(height: 15),
                        
                        if (_obtenerRecetasFiltradas().isEmpty)
                          _buildSinRecetas()
                        else
                          ..._obtenerRecetasFiltradas().map((receta) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: RecetaCardWidget(
                              receta: receta,
                              onEditar: () => _navegarAEditarReceta(receta),
                              onEliminar: () => _mostrarDialogoEliminar(receta),
                            ),
                          )).toList(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACrearReceta,
        backgroundColor: const Color(0xFFFF8C21),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
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
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '¡Hola $nombreChef!',
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
                      'CHEF',
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
            () => _onNavBarTap(2),
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

  Widget _buildTituloSeccion() {
    return Row(
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
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Más vistas'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Mejor calificadas'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text('Más comentadas'),
              onTap: () => Navigator.pop(context),
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