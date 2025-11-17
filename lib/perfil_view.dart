import 'package:flutter/material.dart';
import 'perfil_completar.dart';

class PerfilView extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const PerfilView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // ============================
    // 🔹 DATOS DEL USUARIO
    // ============================
    final persona = usuario["persona"] ?? {};

    final String nombre = usuario["name"] ?? "Usuario";
    final String username = usuario["username"] ?? nombre.toLowerCase();

    final String descripcion = usuario["descripcion_perfil"] ??
        usuario["descripcion"] ??
        "Explorando nuevas recetas y sabores";

    // ⚠ Foto aún no funciona → SIEMPRE USAMOS ESTA
    final String foto =
        "https://cdn-icons-png.flaticon.com/512/149/149071.png";

    // 🔹 Datos físicos (sin edad)
    final String altura = persona["altura"]?.toString() ?? "-";
    final String peso = persona["peso"]?.toString() ?? "-";

    // 🔹 Estadísticas (contra backend actual)
    final String recetasGuardadas =
        usuario["recetas_guardadas"]?.toString() ?? "0";
    final String categoriasFav =
        usuario["categorias_fav"]?.toString() ?? "0";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // =================================
              // 🔹 CABECERA DEL PERFIL
              // =================================
              Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(foto),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8C21),
                          ),
                        ),
                        Text(
                          "@$username",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          descripcion,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =================================
              // 🔹 BOTONES
              // =================================
              Row(
                children: [
                  Expanded(
                    child: _btn("Editar Perfil", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CompletarPerfil(usuario: usuario),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _btn(
                      "Hazte Chef",
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Función en desarrollo 👨‍🍳"),
                          duration: Duration(seconds: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // =================================
              // 🔹 ESTADÍSTICAS
              // =================================
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      valor: recetasGuardadas,
                      label: "Recetas\nGuardadas",
                    ),
                  ),
                  Expanded(
                    child: _StatBox(
                      valor: categoriasFav,
                      label: "Categorías\nFavoritas",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // =================================
              // 🔹 INFORMACIÓN FÍSICA
              // =================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MiniInfo("Altura", "$altura cm"),
                  _MiniInfo("Peso", "$peso kg"),
                ],
              ),

              const SizedBox(height: 25),

              // =================================
              // 🔹 TABS (no funcional todavía)
              // =================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "Guardadas",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF8C21),
                    ),
                  ),
                  Text(
                    "Completadas",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.only(left: 8),
                height: 2,
                width: 110,
                color: const Color(0xFFFF8C21),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: Text(
                    "Aquí aparecerán tus recetas guardadas",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // =========================================
  // 🔸 BOTÓN REUSABLE
  // =========================================
  Widget _btn(String text, VoidCallback onTap) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD54F),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// =====================================================
// 🔸 CAJA DE ESTADISTICAS
// =====================================================
class _StatBox extends StatelessWidget {
  final String valor;
  final String label;

  const _StatBox({required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF8C21),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

// =====================================================
// 🔸 MINI INFO (altura / peso)
// =====================================================
class _MiniInfo extends StatelessWidget {
  final String titulo;
  final String valor;

  const _MiniInfo(this.titulo, this.valor);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF8C21),
          ),
        ),
        Text(
          titulo,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        )
      ],
    );
  }
}
