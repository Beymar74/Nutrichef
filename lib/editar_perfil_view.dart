import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/perfil_update_service.dart';

class EditarPerfilView extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const EditarPerfilView({super.key, required this.usuario});

  @override
  State<EditarPerfilView> createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  // Controllers
  final TextEditingController name = TextEditingController();
  final TextEditingController descripcion = TextEditingController();
  final TextEditingController nombres = TextEditingController();
  final TextEditingController paterno = TextEditingController();
  final TextEditingController materno = TextEditingController();
  final TextEditingController telefono = TextEditingController();
  final TextEditingController altura = TextEditingController();
  final TextEditingController peso = TextEditingController();
  final TextEditingController nacimiento = TextEditingController();

  File? imgFile;
  String? base64Img;

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;
    final p = u["persona"] ?? {};

    name.text = u["name"] ?? "";
    descripcion.text = u["descripcion_perfil"] ?? "";
    nombres.text = p["nombres"] ?? "";
    paterno.text = p["apellido_paterno"] ?? "";
    materno.text = p["apellido_materno"] ?? "";
    telefono.text = p["telefono"] ?? "";
    altura.text = p["altura"]?.toString() ?? "";
    peso.text = p["peso"]?.toString() ?? "";
    nacimiento.text = p["fecha_nacimiento"] ?? "";
  }

  Future pickImg() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (f != null) {
      final file = File(f.path);
      final bytes = await file.readAsBytes();
      setState(() {
        imgFile = file;
        base64Img = base64Encode(bytes);
      });
    }
  }

  Future guardar() async {
    String token = widget.usuario["token"];
    if (token.isEmpty) return;

    final res = await PerfilUpdateService.actualizarPerfilCompleto(
      token: token,
      name: name.text.trim(),
      descripcion: descripcion.text.trim(),
      nombres: nombres.text.trim(),
      apellidoPaterno: paterno.text.trim(),
      apellidoMaterno: materno.text.trim(),
      telefono: telefono.text.trim(),
      altura: altura.text.trim(),
      peso: peso.text.trim(),
      fechaNacimiento: nacimiento.text.trim(),
      imagen: base64Img,
    );

    // ================== 🔥 ACTUALIZA SIN RECARGAR APP ==================
    if (res["success"] == true) {
      widget.usuario["name"] = name.text.trim();
      widget.usuario["descripcion_perfil"] = descripcion.text.trim();
      widget.usuario["persona"]["nombres"] = nombres.text.trim();
      widget.usuario["persona"]["apellido_paterno"] = paterno.text.trim();
      widget.usuario["persona"]["apellido_materno"] = materno.text.trim();
      widget.usuario["persona"]["telefono"] = telefono.text.trim();
      widget.usuario["persona"]["altura"] = altura.text.trim();
      widget.usuario["persona"]["peso"] = peso.text.trim();
      widget.usuario["persona"]["fecha_nacimiento"] = nacimiento.text.trim();
      if (base64Img != null) widget.usuario["persona"]["imagen"] = base64Img;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Perfil actualizado ✔")));

      Navigator.pop(context, true);  // 🔥 Devuelve a PerfilView y se refresca
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"] ?? "Error al guardar")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C21)),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: const Text("Editar Perfil", style: TextStyle(
            color: Color(0xFFFF8C21), fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(children:[

          const SizedBox(height:25),

          /// =================== 📸 FOTO IGUAL A COMPLETAR PERFIL ===================
          GestureDetector(
            onTap: pickImg,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: const Color(0xFFFFD54F),
                  backgroundImage: imgFile != null
                      ? FileImage(imgFile!)
                      : (widget.usuario["persona"]["imagen"] != null
                          ? MemoryImage(base64Decode(widget.usuario["persona"]["imagen"]))
                          : null) as ImageProvider?,
                  child: (imgFile == null && widget.usuario["persona"]["imagen"] == null)
                      ? const Icon(Icons.person, size: 75, color: Colors.white)
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                        color: Color(0xFFFF8C21), shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.white, size: 21),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height:40),

          campo("Username", name),
          campo("Descripción", descripcion),
          campo("Nombres", nombres),
          campo("Apellido Paterno", paterno),
          campo("Apellido Materno", materno),
          campo("Teléfono", telefono),
          campo("Altura (m)", altura),
          campo("Peso (kg)", peso),
          campo("Fecha Nacimiento", nacimiento),

          const SizedBox(height:35),

          ElevatedButton(
            onPressed: guardar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF8C21),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))
            ),
            child: const Text(
                "Guardar Cambios",
                style: TextStyle(fontSize: 17, color: Colors.white)
            ),
          ),

          const SizedBox(height:40)
        ]),
      ),
    );
  }

  // ===================== INPUT ESTÉTICO =====================
  Widget campo(String label, TextEditingController c){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height:6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFD54F),
            borderRadius: BorderRadius.circular(25)
          ),
          child: TextField(
            controller: c,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal:18,vertical:14),
            ),
          ),
        ),
        const SizedBox(height:18),
      ],
    );
  }
}
