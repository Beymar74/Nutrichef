import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart'; // para conectarte al backend Laravel
class ComunidadPage extends StatefulWidget {
  const ComunidadPage({Key? key}) : super(key: key);

  @override
  State<ComunidadPage> createState() => _ComunidadPageState();
}

class _ComunidadPageState extends State<ComunidadPage> {
  List recetas = [];
  bool loading = true;
  String filtro = 'top'; // top, nuevo, antiguo

  @override
  void initState() {
    super.initState();
    cargarRecetas();
  }

  Future<void> cargarRecetas() async {
    setState(() => loading = true);
    final data = await ApiService.obtenerRecetas(filtro);
    setState(() {
      recetas = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Comunidad', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.orange),
          SizedBox(width: 12),
          Icon(Icons.settings_outlined, color: Colors.orange),
          SizedBox(width: 12),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                _buildFiltroBar(),
                Expanded(
                  child: ListView.builder(
                    itemCount: recetas.length,
                    itemBuilder: (context, index) => _buildRecetaCard(recetas[index]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildFiltroBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _filtroButton('Top Recetas', 'top'),
        _filtroButton('Mas Nuevo', 'nuevo'),
        _filtroButton('Antiguo', 'antiguo'),
      ],
    );
  }

  Widget _filtroButton(String label, String value) {
    final activo = filtro == value;
    return GestureDetector(
      onTap: () {
        setState(() => filtro = value);
        cargarRecetas();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: activo ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: activo ? Colors.white : Colors.orange, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRecetaCard(dynamic receta) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(receta['autor_imagen'] ?? '')),
            title: Text('@${receta['autor'] ?? 'Usuario'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(receta['fecha'] ?? '', style: const TextStyle(color: Colors.orange)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(receta['imagen'], height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(receta['titulo'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 5),
                Text(receta['descripcion'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text('${receta['tiempo']} min'),
                    ]),
                    Row(children: [
                      const Icon(Icons.visibility, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text('${receta['vistas']}'),
                    ]),
                    const Icon(Icons.favorite_border, color: Colors.pinkAccent),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.layers), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
