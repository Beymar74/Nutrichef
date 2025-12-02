import 'package:flutter/material.dart';
import 'models/chef_receta_model.dart';
import 'services/chef_service.dart';
import 'crear_receta.dart';
import 'editar_receta.dart';
import 'ver_receta_chef.dart';
import 'estadisticas_chef_screen.dart'; // ✅ Importante
import 'perfil_chef_screen.dart';
import 'receta_card_widget.dart';

class HomeChef extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const HomeChef({super.key, required this.usuario});

  @override
  State<HomeChef> createState() => _HomeChefState();
}

class _HomeChefState extends State<HomeChef> {
  final ChefService _chefService = ChefService();
  
  late String nombreChef;
  late int chefId;
  String? fotoPerfil;
  
  List<Receta> _misRecetas = [];
  bool _isLoading = true;
  String _filtroActual = 'Todas';
  
  // Stats Calculadas
  int _totalVistas = 0;
  double _promedioCalif = 0.0;
  int _totalComentarios = 0;
  int _totalFavoritos = 0; // ✅ Agregamos esta variable

  @override
  void initState() {
    super.initState();
    _extraerDatosUsuario();
    _cargarMisRecetas();
  }

  void _extraerDatosUsuario() {
    nombreChef = widget.usuario['name']?.toString() ?? 'Chef';
    chefId = int.tryParse(widget.usuario['id'].toString()) ?? 0;
    fotoPerfil = widget.usuario['profile_photo_url']?.toString();
  }

  Future<void> _cargarMisRecetas() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final recetas = await _chefService.obtenerMisRecetas(chefId);
      if (!mounted) return;
      
      _misRecetas = recetas;
      _calcularEstadisticas(); // ✅ Calcula todo al cargar
      
      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _calcularEstadisticas() {
    // Sumamos los valores de todas las recetas
    _totalVistas = _misRecetas.fold(0, (sum, r) => sum + (r.visualizaciones ?? 0));
    _totalComentarios = _misRecetas.fold(0, (sum, r) => sum + (r.totalComentarios ?? 0));
    _totalFavoritos = _misRecetas.fold(0, (sum, r) => sum + (r.totalFavoritos ?? 0)); // ✅ Suma favoritos

    final conCalif = _misRecetas.where((r) => (r.calificacion ?? 0) > 0);
    _promedioCalif = conCalif.isNotEmpty 
        ? conCalif.fold(0.0, (sum, r) => sum + r.calificacion!) / conCalif.length 
        : 0.0;
  }

  List<Receta> get _recetasFiltradas {
    if (_filtroActual == 'Todas') return _misRecetas;
    return _misRecetas.where((r) => r.estado.contains(_filtroActual.toUpperCase().substring(0, 4))).toList();
  }

  // --- NAVEGACIÓN ---
  void _irACrear() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrearRecetaScreen(chefId: chefId)))
        .then((v) { if (v == true) _cargarMisRecetas(); });
  }

  void _irAEditar(Receta r) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => EditarRecetaScreen(receta: r)))
        .then((v) { if (v == true) _cargarMisRecetas(); });
  }

  void _irADetalle(Receta r) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => VerRecetaChefScreen(receta: r)));
  }

  // ✅ BOTÓN ESTADÍSTICAS FUNCIONAL
  void _irAEstadisticas() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => EstadisticasChefScreen(
      misRecetas: _misRecetas,
      recetasPublicadas: _misRecetas.where((r) => r.estado.contains('PUBLIC')).toList(),
      totalVisualizaciones: _totalVistas,
      calificacionPromedio: _promedioCalif,
      totalComentarios: _totalComentarios,
      totalFavoritos: _totalFavoritos, // Pasamos el dato real
    )));
  }

  void _irAPerfil() async {
    final resultado = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => PerfilChefScreen(
        nombreChef: nombreChef,
        chefId: chefId,
        emailChef: widget.usuario['email']?.toString() ?? '',
        totalRecetas: _misRecetas.length,
        recetasPublicadas: _misRecetas.where((r) => r.estado.contains('PUBLIC')).length,
        calificacionPromedio: _promedioCalif,
      ))
    );

    if (resultado != null && resultado is Map) {
      setState(() {
        if (resultado.containsKey('nombre')) nombreChef = resultado['nombre'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _cargarMisRecetas,
          color: const Color(0xFFFF8C21),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 30, 
                          backgroundColor: Colors.white,
                          backgroundImage: fotoPerfil != null ? NetworkImage(fotoPerfil!) : null,
                          child: fotoPerfil == null ? const Icon(Icons.person, color: Colors.orange) : null
                        ),
                        const SizedBox(width: 15),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Hola $nombreChef!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFEC888D))),
                          const Text('Panel de Chef', style: TextStyle(color: Colors.grey)),
                        ])
                      ]),
                      const SizedBox(height: 20),
                      
                      _buildStatsRow(),
                      const SizedBox(height: 20),
                      
                      Row(children: [
                        Expanded(child: _buildQuickBtn(Icons.add_circle, 'Crear', const Color(0xFF4CAF50), _irACrear)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildQuickBtn(Icons.analytics, 'Stats', const Color(0xFF2196F3), _irAEstadisticas)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildQuickBtn(Icons.person, 'Perfil', const Color(0xFFFF8C21), _irAPerfil)),
                      ]),
                      const SizedBox(height: 20),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: ['Todas', 'Publicadas', 'Pendientes', 'Borradores'].map((f) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: _filtroActual == f,
                            onSelected: (b) => setState(() => _filtroActual = f),
                            selectedColor: const Color(0xFFFF8C21),
                            labelStyle: TextStyle(color: _filtroActual == f ? Colors.white : Colors.black),
                            backgroundColor: Colors.white,
                          ),
                        )).toList()),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              _isLoading
                ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Color(0xFFFF8C21))))
                : _recetasFiltradas.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState())
                    : SliverList(delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: RecetaCardWidget(
                            receta: _recetasFiltradas[index],
                            onEditar: () => _irAEditar(_recetasFiltradas[index]),
                            onEliminar: () => _mostrarDialogoEliminar(_recetasFiltradas[index]),
                            onTap: () => _irADetalle(_recetasFiltradas[index]),
                          ),
                        ),
                        childCount: _recetasFiltradas.length,
                      )),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irACrear,
        backgroundColor: const Color(0xFFFF8C21),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsRow() {
    return GestureDetector( // Hacer clic en el resumen también lleva a stats
      onTap: _irAEstadisticas,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _statItem(Icons.visibility, '$_totalVistas', 'Vistas'),
          _statItem(Icons.star, _promedioCalif.toStringAsFixed(1), 'Rating'),
          _statItem(Icons.comment, '$_totalComentarios', 'Comentarios'),
        ]),
      ),
    );
  }

  Widget _statItem(IconData i, String v, String l) => Column(children: [
    Icon(i, color: Colors.white),
    Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    Text(l, style: const TextStyle(color: Colors.white70, fontSize: 10)),
  ]);

  Widget _buildQuickBtn(IconData i, String l, Color c, VoidCallback f) => GestureDetector(
    onTap: f,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.3))),
      child: Column(children: [Icon(i, color: c), const SizedBox(height: 4), Text(l, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 12))]),
    ),
  );

  Widget _buildEmptyState() => Padding(
    padding: const EdgeInsets.all(40),
    child: Column(children: [
      const Icon(Icons.restaurant_menu, size: 60, color: Colors.grey),
      const SizedBox(height: 10),
      Text('No hay recetas $_filtroActual', style: const TextStyle(color: Colors.grey)),
    ]),
  );

  void _mostrarDialogoEliminar(Receta r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar Receta"),
        content: Text("¿Deseas eliminar '${r.titulo}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              bool exito = await _chefService.eliminarReceta(r.id!);
              if (mounted && exito) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eliminado"), backgroundColor: Colors.red));
                _cargarMisRecetas();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Eliminar", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}