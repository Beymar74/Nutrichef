import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'services/perfil_service.dart';
import 'nivel_cocina.dart';

class CompletarPerfil extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const CompletarPerfil({super.key, required this.usuario});

  @override
  State<CompletarPerfil> createState() => _CompletarPerfilState();
}

class _CompletarPerfilState extends State<CompletarPerfil> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  File? _imageFile;
  String? base64Image;

  @override
  void initState() {
    super.initState();

    final persona = widget.usuario["persona"] ?? {};

    _nombreController.text = widget.usuario["name"] ?? "";
    _descripcionController.text = widget.usuario["descripcion_perfil"] ?? "";
    _alturaController.text = persona["altura"]?.toString() ?? "";
    _pesoController.text = persona["peso"]?.toString() ?? "";
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      final file = File(img.path);
      final bytes = await file.readAsBytes();

      setState(() {
        _imageFile = file;
        base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _continuar() async {
    if (_nombreController.text.trim().isEmpty ||
        _descripcionController.text.trim().isEmpty ||
        _alturaController.text.trim().isEmpty ||
        _pesoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("⚠ Completa los campos")));
      return;
    }

    final token = widget.usuario["token"];
    if (token == null) return;

    final res = await PerfilService.actualizarPerfil(
      token: token,
      name: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      altura: _alturaController.text.trim(),
      peso: _pesoController.text.trim(),
      imagen: base64Image,
    );

    if (res["success"] == true) {

  String tokenOriginal = widget.usuario["token"]; // 🔥 GUARDAR TOKEN

  widget.usuario.clear();
  widget.usuario.addAll(res["usuario"]); // datos nuevos del backend
  widget.usuario["token"] = tokenOriginal; // 🔥 VOLVER A INSERTAR TOKEN

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => NivelCocina(usuario: widget.usuario)),
  );
} else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(children: [
            const SizedBox(height: 25),
            const Text("Completar Perfil",
                style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Color(0xFFFF8C21))),
            const SizedBox(height: 40),

            // 🔥 FOTO DE PERFIL FUNCIONAL
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFFFD54F),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person,size:70,color:Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF8C21),shape: BoxShape.circle),
                      child: const Icon(Icons.edit,color:Colors.white,size:20),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 45),

            campo("Nombre de Usuario",_nombreController,"username"),
            campo("Descripción",_descripcionController,"Escribe algo sobre ti"),
            campo("Altura (m)",_alturaController,"1.70",tipo: TextInputType.number),
            campo("Peso (kg)",_pesoController,"65",tipo: TextInputType.number),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed:_continuar,
              style:ElevatedButton.styleFrom(
                minimumSize: Size(220,50),backgroundColor: Color(0xFFFF8C21),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(25))),
              child: const Text("Continuar ➜",style:TextStyle(fontSize:17,color:Colors.white)),
            ),

            const SizedBox(height:40)
          ]),
        ),
      ),
    );
  }

  Widget campo(String t,TextEditingController c,String h,{tipo=TextInputType.text}){
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(t,style:TextStyle(fontWeight:FontWeight.w600,fontSize:15)),
      const SizedBox(height:8),
      Container(
        decoration: BoxDecoration(color:Color(0xFFFFD54F),borderRadius:BorderRadius.circular(25)),
        child: TextField(
          controller:c,keyboardType:tipo,
          decoration:InputDecoration(hintText:h,border:OutlineInputBorder(
            borderRadius:BorderRadius.circular(25),borderSide: BorderSide.none),
          contentPadding:EdgeInsets.symmetric(horizontal:18,vertical:13)),
        ),
      ),
      const SizedBox(height:20)
    ]);
  }
}
