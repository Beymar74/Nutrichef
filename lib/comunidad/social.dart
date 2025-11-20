import 'package:flutter/material.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunidad NutriChef"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.article), text: "Publicaciones"),
            Tab(icon: Icon(Icons.comment), text: "Comentarios"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPublicaciones(),
          _buildComentarios(),
        ],
      ),
    );
  }

  /// Sección Publicaciones
  Widget _buildPublicaciones() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5, // ejemplo
      itemBuilder: (context, index) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text("Publicación #$index"),
          subtitle: const Text(
            "Esta es una publicación de ejemplo en la comunidad de NutriChef.",
          ),
          trailing: const Icon(Icons.favorite_border),
        ),
      );
      },
    );
  }

  /// Sección Comentarios
  Widget _buildComentarios() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5, // ejemplo
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          child: ListTile(
            leading: const Icon(Icons.comment),
            title: Text("Comentario #$index"),
            subtitle: const Text("Este es un comentario de ejemplo."),
          ),
        );
      },
    );
  }
}
