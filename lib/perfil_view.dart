import 'dart:convert';
import 'package:flutter/material.dart';
import 'editar_perfil_view.dart';
import 'services/logout_service.dart';
import 'login.dart'; 
import 'solicitud_chef_view.dart';

class PerfilView extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const PerfilView({super.key, required this.usuario});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  
  // 🔥 FUNCIÓN PARA CERRAR SESIÓN
 Future<void> _cerrarSesion() async {
    // Mostrar diálogo de confirmación
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar Sesión"),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí, cerrar sesión", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    // Cerrar el modal de perfil si está abierto
    Navigator.pop(context);

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Llamar al servicio de logout
    final token = widget.usuario["token"] ?? "";
    final res = await LogoutService.cerrarSesion(token);

    // Cerrar loading
    if (mounted) Navigator.pop(context);

    if (res["success"] == true) {
      // Redirigir al login (sin poder volver atrás)
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const Login()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sesión cerrada correctamente")),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Error al cerrar sesión")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ============= DATOS ==================
    final persona = widget.usuario["persona"] ?? {};
    final String nombre = widget.usuario["name"] ?? "Usuario";
    final String username = widget.usuario["username"] ?? nombre.toLowerCase();
    final String descripcion = widget.usuario["descripcion_perfil"] ??
        widget.usuario["descripcion"] ??
        "Explorando nuevas recetas y sabores";

    // ============ FOTO =====================
    final String? img64 = persona["imagen"];
    
    ImageProvider foto;
    if (img64 != null && img64.isNotEmpty) {
      try {
        foto = MemoryImage(base64Decode(img64));
      } catch (e) {
        foto = const NetworkImage("https://cdn-icons-png.flaticon.com/512/149/149071.png");
      }
    } else {
      foto = const NetworkImage("https://cdn-icons-png.flaticon.com/512/149/149071.png");
    }

    // ============ DATOS PERSONA ============
    final String altura = persona["altura"]?.toString() ?? "-";
    final String peso = persona["peso"]?.toString() ?? "-";
    final String recetas = widget.usuario["recetas_guardadas"]?.toString() ?? "0";
    final String categorias = widget.usuario["categorias_fav"]?.toString() ?? "0";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // CABECERA
              Row(children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFFFFD54F),
                  backgroundImage: foto,
                  onBackgroundImageError: (_, __) {},
                  child: img64 == null || img64.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nombre, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFFFF8C21))),
                      Text("@$username", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      Text(descripcion, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ]
                  )
                )
              ]),

              const SizedBox(height: 25),

              // BOTONES
              Row(children: [
                Expanded(
                  child: _btn("Editar Perfil", () async {
                    final actualizado = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditarPerfilView(usuario: widget.usuario))
                    );

                    if (actualizado == true) {
                      setState(() {});
                    }
                  })
                ),
                const SizedBox(width: 10),
               Expanded(
  child: _btn("Hazte Chef", () async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SolicitudChefView(usuario: widget.usuario),
      ),
    );

    // Si se envió la solicitud exitosamente, actualizar UI
    if (resultado == true) {
      setState(() {}); // Reconstruye el widget
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✓ Solicitud enviada correctamente"),
          backgroundColor: Colors.green,
        ),
      );
    }
  })
),
              ]),

              const SizedBox(height: 22),

              // ESTADISTICAS
              Row(children: [
                Expanded(child: _StatBox(valor: recetas, label: "Recetas\nGuardadas")),
                Expanded(child: _StatBox(valor: categorias, label: "Categorías\nFavoritas")),
              ]),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MiniInfo("Altura", "$altura m"),
                  _MiniInfo("Peso", "$peso kg"),
                ]
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text("Guardadas", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFFF8C21))),
                  Text("Completadas", style: TextStyle(fontSize: 15, color: Colors.black87)),
                ]
              ),

              const SizedBox(height: 10),
              Container(height: 2, width: 110, color: const Color(0xFFFF8C21)),
              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: Text("Aquí aparecerán tus recetas guardadas", style: TextStyle(color: Colors.grey[500], fontSize: 14))
                )
              ),

              // 🔥 BOTÓN DE CERRAR SESIÓN
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _cerrarSesion,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red, fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

            ],
          )
        )
      )
    );
  }

  // BOTON UNIVERSAL
  Widget _btn(String txt, VoidCallback onTap) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD54F),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))
        ),
        child: Text(txt, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333), fontSize: 14))
      )
    );
  }
}

// WIDGETS ABAJO
class _StatBox extends StatelessWidget {
  final String valor, label;
  const _StatBox({required this.valor, required this.label});
  
  @override
  Widget build(BuildContext ctx) => Column(children: [
    Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF8C21))),
    const SizedBox(height: 4),
    Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[700]))
  ]);
}

class _MiniInfo extends StatelessWidget {
  final String t, v;
  const _MiniInfo(this.t, this.v);
  
  @override
  Widget build(BuildContext ctx) => Column(children: [
    Text(v, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF8C21))),
    Text(t, style: const TextStyle(fontSize: 12, color: Colors.grey))
  ]);
}