import 'package:flutter/material.dart';
import '../../models/receta_model.dart';
import 'widgets/home_header.dart';
import 'widgets/categoria_chips.dart';
import 'widgets/receta_destacada.dart';
import 'widgets/receta_card.dart';
import 'widgets/receta_horizontal.dart';
import 'widgets/top_chef_section.dart';

class HomeContent extends StatelessWidget {
  final String nombreUsuario;
  final String categoriaSeleccionada;
  final List<Receta> recetasFiltradas;
  final Receta? recetaDestacada;
  final Set<String> favoritos;
  final Function(String) onCategoriaSeleccionada;
  final Function(String) onToggleFavorito;
  final Future<void> Function() onRefresh;

  const HomeContent({
    super.key,
    required this.nombreUsuario,
    required this.categoriaSeleccionada,
    required this.recetasFiltradas,
    required this.recetaDestacada,
    required this.favoritos,
    required this.onCategoriaSeleccionada,
    required this.onToggleFavorito,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
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
              HomeHeader(nombreUsuario: nombreUsuario),

              const SizedBox(height: 25),

              // CATEGORÍAS
              CategoriaChips(
                categoriaSeleccionada: categoriaSeleccionada,
                onCategoriaSeleccionada: onCategoriaSeleccionada,
              ),

              const SizedBox(height: 15),

              // CONTADOR DE RECETAS
              Text(
                '${recetasFiltradas.length} recetas disponibles',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 15),

              // RECETA DE MODA
              const Text(
                'Receta De Moda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEC888D),
                ),
              ),

              const SizedBox(height: 15),

              RecetaDestacada(
                receta: recetaDestacada,
                esFavorito: recetaDestacada != null 
                    ? favoritos.contains(recetaDestacada!.id.toString())
                    : false,
                onToggleFavorito: recetaDestacada != null
                    ? () => onToggleFavorito(recetaDestacada!.id.toString())
                    : () {},
              ),

              const SizedBox(height: 25),

              // MÁS RECETAS
              if (recetasFiltradas.length > 1)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C21),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Más Recetas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          if (recetasFiltradas.length > 1)
                            Expanded(
                              child: RecetaCard(
                                receta: recetasFiltradas[1],
                                esFavorito: favoritos.contains(
                                    recetasFiltradas[1].id.toString()),
                                onToggleFavorito: () => onToggleFavorito(
                                    recetasFiltradas[1].id.toString()),
                              ),
                            ),
                          if (recetasFiltradas.length > 2)
                            const SizedBox(width: 15),
                          if (recetasFiltradas.length > 2)
                            Expanded(
                              child: RecetaCard(
                                receta: recetasFiltradas[2],
                                esFavorito: favoritos.contains(
                                    recetasFiltradas[2].id.toString()),
                                onToggleFavorito: () => onToggleFavorito(
                                    recetasFiltradas[2].id.toString()),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 25),

              // TOP CHEF
              const TopChefSection(),

              const SizedBox(height: 25),

              // RECETAS RECIENTES
              if (recetasFiltradas.length > 3) ...[
                const Text(
                  'Recetas Recientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEC888D),
                  ),
                ),
                const SizedBox(height: 15),
                ...recetasFiltradas.skip(3).take(3).map(
                      (receta) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RecetaHorizontal(receta: receta),
                      ),
                    ),
              ],

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}