import 'package:flutter/material.dart';
import '../../services/receta_service.dart';
import '../../models/receta_model.dart';
import '../../perfil_completar.dart';
import '../../perfil_view.dart';
import '../../recetas.dart';
import 'home_content.dart';
import 'widgets/custom_bottom_nav.dart';

// --- IMPORTANTE: Importa tu módulo de IA ---
import '../../ia/screens/ia_inicio_page.dart'; 

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;
  
  const HomeScreen({super.key, required this.usuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Set<String> _favoritos = {};
  
  // API Service
  final RecetaService _recetaService = RecetaService();
  List<Receta> _todasLasRecetas = [];
  List<Receta> _recetasFiltradas = [];
  Receta? _recetaDestacada;
  bool _isLoading = true;
  
  // Categoría seleccionada
  String _categoriaSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();
    _cargarRecetas();
  }

  Future<void> _cargarRecetas() async {
    try {
      setState(() => _isLoading = true);
      
      final recetas = await _recetaService.obtenerRecetas();
      
      setState(() {
        _todasLasRecetas = recetas;
        _recetasFiltradas = recetas;
        _recetaDestacada = recetas.isNotEmpty ? recetas.first : null;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error al cargar recetas: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filtrarPorCategoria(String categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
      
      if (categoria == 'Todas') {
        _recetasFiltradas = _todasLasRecetas;
      } else if (categoria == 'Vegano') {
        _recetasFiltradas = _todasLasRecetas.where((receta) {
          return receta.dietas.any((dieta) => 
            dieta.toLowerCase().contains('vegan'));
        }).toList();
      } else {
        // Para otras categorías, mostrar todas por ahora
        _recetasFiltradas = _todasLasRecetas;
      }
      
      // Actualizar receta destacada
      _recetaDestacada = _recetasFiltradas.isNotEmpty 
          ? _recetasFiltradas.first 
          : null;
    });
  }

  void _toggleFavorito(String recetaId) {
    setState(() {
      if (_favoritos.contains(recetaId)) {
        _favoritos.remove(recetaId);
      } else {
        _favoritos.add(recetaId);
      }
    });
  }

  void _abrirPerfil() {
    final u = widget.usuario;
    final p = u["persona"];

    bool perfilIncompleto =
        (u["descripcion_perfil"] == null || u["descripcion_perfil"].toString().isEmpty) ||
        (p == null) ||
        (p["altura"] == null || p["altura"].toString().isEmpty) ||
        (p["peso"] == null || p["peso"].toString().isEmpty);

    if (perfilIncompleto) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CompletarPerfil(usuario: widget.usuario),
        ),
      );
    } else {
      setState(() => _selectedIndex = 3);
    }
  }

  // ------------------------------------------------------------
  // ✅ MÉTODO MODIFICADO: Conexión con Módulo IA
  // ------------------------------------------------------------
  void _onCameraPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IaInicioPage(),
      ),
    );
  }

  void _onNavBarTap(int index) {
    switch (index) {
      case 0:
        setState(() => _selectedIndex = 0);
        break;

      case 1:
        // TODO: Implementar chat
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecetasModaScreen()),
        );
        break;

      case 3:
        _abrirPerfil();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, 
      body: SafeArea(
        child: _selectedIndex == 3
            ? PerfilView(usuario: widget.usuario)
            : _buildHomeContent(),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onNavBarTap,
        onCameraPressed: _onCameraPressed,
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF8C21),
        ),
      );
    }

    return HomeContent(
      nombreUsuario: widget.usuario['name'] ?? 'Usuario',
      categoriaSeleccionada: _categoriaSeleccionada,
      recetasFiltradas: _recetasFiltradas,
      recetaDestacada: _recetaDestacada,
      favoritos: _favoritos,
      onCategoriaSeleccionada: _filtrarPorCategoria,
      onToggleFavorito: _toggleFavorito,
      onRefresh: _cargarRecetas,
    );
  }
}