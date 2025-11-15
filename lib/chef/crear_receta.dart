import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/receta_service.dart';


class CrearRecetaScreen extends StatefulWidget {
  final int chefId;

  const CrearRecetaScreen({
    super.key,
    required this.chefId,
  });

  @override
  State<CrearRecetaScreen> createState() => _CrearRecetaScreenState();
}

class _CrearRecetaScreenState extends State<CrearRecetaScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecetaService _recetaService = RecetaService();
  
  // Controladores
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _tiempoController = TextEditingController();
  final _porcionesController = TextEditingController();
  
  // Listas dinámicas
  List<IngredienteForm> _ingredientes = [IngredienteForm()];
  List<PasoForm> _pasos = [PasoForm(numero: 1)];
  
  // Selecciones
  String _dificultad = 'Fácil';
  String _categoria = 'Desayuno';
  List<String> _etiquetas = [];
  File? _imagenPrincipal;
  List<File> _imagenesAdicionales = [];
  
  // Estado
  bool _isLoading = false;
  bool _usarOCR = false;
  
  // Información nutricional
  Map<String, dynamic>? _infoNutricional;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _tiempoController.dispose();
    _porcionesController.dispose();
    for (var ing in _ingredientes) {
      ing.dispose();
    }
    for (var paso in _pasos) {
      paso.dispose();
    }
    super.dispose();
  }

  Future<void> _seleccionarImagenPrincipal() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (image != null) {
                  setState(() {
                    _imagenPrincipal = File(image.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de galería'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (image != null) {
                  setState(() {
                    _imagenPrincipal = File(image.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _usarOCRParaIngredientes() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    
    if (image != null) {
      setState(() => _usarOCR = true);
      
      // Simular OCR - En producción esto llamaría al servicio real
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _ingredientes = [
          IngredienteForm()..nombre.text = 'Tomate'..cantidad.text = '2'..unidad.text = 'unidades',
          IngredienteForm()..nombre.text = 'Cebolla'..cantidad.text = '1'..unidad.text = 'unidad',
          IngredienteForm()..nombre.text = 'Aceite de oliva'..cantidad.text = '2'..unidad.text = 'cucharadas',
        ];
        _usarOCR = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Ingredientes detectados con OCR'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }

  void _calcularInformacionNutricional() {
    setState(() => _isLoading = true);
    
    // Simular cálculo - En producción esto llamaría al servicio real
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _infoNutricional = {
          'calorias': 245,
          'proteinas': 12.5,
          'carbohidratos': 32.8,
          'grasas': 8.2,
          'fibra': 4.5,
        };
        _isLoading = false;
      });
    });
  }

  void _guardarReceta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imagenPrincipal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, agrega una imagen principal'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simular guardado
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Receta creada y enviada a revisión'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear receta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nueva Receta',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : () {
              // Guardar como borrador
            },
            icon: const Icon(Icons.save_outlined, size: 20),
            label: const Text('Borrador'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
      body: _isLoading && !_usarOCR
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF8C21),
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Indicator
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF8C21),
                            const Color(0xFFFF8C21).withOpacity(0.3),
                          ],
                          stops: const [0.3, 1],
                        ),
                      ),
                    ),
                    
                    // Imagen Principal
                    _buildSeccionImagen(),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información Básica
                          _buildSeccionTitulo('Información Básica'),
                          _buildCampoTexto(
                            controller: _tituloController,
                            label: 'Título de la Receta',
                            hint: 'Ej: Pasta Carbonara Tradicional',
                            icon: Icons.title,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa un título';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildCampoTexto(
                            controller: _descripcionController,
                            label: 'Descripción',
                            hint: 'Describe tu receta brevemente',
                            icon: Icons.description,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa una descripción';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildCampoTexto(
                                  controller: _tiempoController,
                                  label: 'Tiempo (min)',
                                  hint: '30',
                                  icon: Icons.timer,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildCampoTexto(
                                  controller: _porcionesController,
                                  label: 'Porciones',
                                  hint: '4',
                                  icon: Icons.people,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          
                          // Dificultad y Categoría
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Dificultad',
                                  value: _dificultad,
                                  items: ['Fácil', 'Media', 'Difícil'],
                                  onChanged: (value) {
                                    setState(() => _dificultad = value!);
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Categoría',
                                  value: _categoria,
                                  items: ['Desayuno', 'Almuerzo', 'Cena', 'Postre', 'Snack'],
                                  onChanged: (value) {
                                    setState(() => _categoria = value!);
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Ingredientes
                          _buildSeccionIngredientes(),
                          
                          const SizedBox(height: 30),
                          
                          // Pasos
                          _buildSeccionPasos(),
                          
                          const SizedBox(height: 30),
                          
                          // Información Nutricional
                          _buildSeccionNutricional(),
                          
                          const SizedBox(height: 30),
                          
                          // Etiquetas
                          _buildSeccionEtiquetas(),
                          
                          const SizedBox(height: 40),
                          
                          // Botón Publicar
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _guardarReceta,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8C21),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Publicar Receta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C21),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEC888D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionImagen() {
    return GestureDetector(
      onTap: _seleccionarImagenPrincipal,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: _imagenPrincipal != null
              ? DecorationImage(
                  image: FileImage(_imagenPrincipal!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imagenPrincipal == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Agregar imagen principal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Toca para seleccionar',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: _seleccionarImagenPrincipal,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFFF8C21)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF8C21), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF8C21)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionIngredientes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSeccionTitulo('Ingredientes'),
            Row(
              children: [
                if (_usarOCR)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFFF8C21),
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: _usarOCRParaIngredientes,
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text('Usar OCR'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _ingredientes.add(IngredienteForm());
                    });
                  },
                  icon: const Icon(Icons.add_circle),
                  color: const Color(0xFF4CAF50),
                ),
              ],
            ),
          ],
        ),
        ..._ingredientes.asMap().entries.map((entry) {
          final index = entry.key;
          final ingrediente = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: ingrediente.nombre,
                    decoration: InputDecoration(
                      hintText: 'Ingrediente',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: ingrediente.cantidad,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Cant',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: ingrediente.unidad,
                    decoration: InputDecoration(
                      hintText: 'Unidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                if (_ingredientes.length > 1)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        ingrediente.dispose();
                        _ingredientes.removeAt(index);
                      });
                    },
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSeccionPasos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSeccionTitulo('Pasos de Preparación'),
            IconButton(
              onPressed: () {
                setState(() {
                  _pasos.add(PasoForm(numero: _pasos.length + 1));
                });
              },
              icon: const Icon(Icons.add_circle),
              color: const Color(0xFF4CAF50),
            ),
          ],
        ),
        ..._pasos.asMap().entries.map((entry) {
          final index = entry.key;
          final paso = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF8C21),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: paso.descripcion,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'Describe este paso...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_pasos.length > 1)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              paso.dispose();
                              _pasos.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.close, size: 20),
                          color: Colors.red,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSeccionNutricional() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSeccionTitulo('Información Nutricional'),
            TextButton.icon(
              onPressed: _ingredientes.isEmpty ? null : _calcularInformacionNutricional,
              icon: const Icon(Icons.calculate, size: 18),
              label: const Text('Calcular'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
        if (_infoNutricional != null)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutriente('Calorías', '${_infoNutricional!['calorias']}', 'kcal'),
                _buildNutriente('Proteínas', '${_infoNutricional!['proteinas']}', 'g'),
                _buildNutriente('Carbos', '${_infoNutricional!['carbohidratos']}', 'g'),
                _buildNutriente('Grasas', '${_infoNutricional!['grasas']}', 'g'),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Text(
                'Agrega ingredientes y calcula la información nutricional',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNutriente(String nombre, String valor, String unidad) {
    return Column(
      children: [
        Text(
          nombre,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              valor,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF8C21),
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unidad,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeccionEtiquetas() {
    final etiquetasDisponibles = [
      'Vegetariano',
      'Vegano',
      'Sin Gluten',
      'Sin Lactosa',
      'Keto',
      'Low Carb',
      'Alta en Proteína',
      'Saludable',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSeccionTitulo('Etiquetas y Dietas'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: etiquetasDisponibles.map((etiqueta) {
            final isSelected = _etiquetas.contains(etiqueta);
            return FilterChip(
              label: Text(etiqueta),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _etiquetas.add(etiqueta);
                  } else {
                    _etiquetas.remove(etiqueta);
                  }
                });
              },
              selectedColor: const Color(0xFFFF8C21).withOpacity(0.2),
              checkmarkColor: const Color(0xFFFF8C21),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFFFF8C21) : Colors.grey[700],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Clases auxiliares
class IngredienteForm {
  final TextEditingController nombre = TextEditingController();
  final TextEditingController cantidad = TextEditingController();
  final TextEditingController unidad = TextEditingController();
  
  void dispose() {
    nombre.dispose();
    cantidad.dispose();
    unidad.dispose();
  }
}

class PasoForm {
  final int numero;
  final TextEditingController descripcion = TextEditingController();
  
  PasoForm({required this.numero});
  
  void dispose() {
    descripcion.dispose();
  }
}