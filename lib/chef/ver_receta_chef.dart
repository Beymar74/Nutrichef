import 'package:flutter/material.dart';
import 'models/chef_receta_model.dart'; // ✅ Importa el modelo correcto
import 'editar_receta.dart';

class VerRecetaChefScreen extends StatelessWidget {
  final Receta receta;
  const VerRecetaChefScreen({super.key, required this.receta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250, pinned: true, backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(receta.titulo, style: const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 2)])),
              background: Image.network(receta.imagenUrl ?? 'https://i.imgur.com/Xqg9f05.png', fit: BoxFit.cover),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EditarRecetaScreen(receta: receta)))),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(receta.resumen ?? '', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)),
                const Divider(height: 30),
                const Text("Preparación", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(receta.preparacion, style: const TextStyle(fontSize: 16, height: 1.5)),
              ]),
            ),
          )
        ],
      ),
    );
  }
}