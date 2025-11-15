import 'package:flutter/material.dart';
import '../models/receta_model.dart';
import 'crear_receta.dart'; // Para reutilizar las clases auxiliares

class EditarRecetaScreen extends StatefulWidget {
  final Receta receta;

  const EditarRecetaScreen({
    super.key,
    required this.receta,
  });

  @override
  State<EditarRecetaScreen> createState() => _EditarRecetaScreenState();
}

class _EditarRecetaScreenState extends State<EditarRecetaScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _tiempoController;
  late TextEditingController _porcionesController;
  
  // Listas dinámicas
  List<IngredienteForm> _ingredientes = [];
  List<PasoForm> _pasos = [];
  
  // Estado
  bool _isLoading = false;
  bool _hasChanges = false;
  
  // Información adicional
  String _estadoActual = 'PUBLICADA';
  String? _motivoRechazo;

  @override
  void initState() {
    super.initState();
    _inicializarCampos();
  }

  void _inicializarCampos() {
    _tituloController = TextEditingController(text: widget.receta.titulo);
    _descripcionController = TextEditingController(text: widget.receta.resumen);
    _tiempoController = TextEditingController(
      text: widget.receta.tiempoPreparacion.toString()
    );
    _porcionesController = TextEditingController(text: '4'); // Default
    
    // Cargar ingredientes existentes
    _ingredientes = [
      IngredienteForm()..nombre.text = 'Pasta'..cantidad.text = '400'..unidad.text = 'gramos',
      IngredienteForm()..nombre.text = 'Guanciale'..cantidad.text = '150'..unidad.text = 'gramos',
      IngredienteForm()..nombre.text = 'Huevos'..cantidad.text = '4'..unidad.text = 'unidades',
    ];
    
    // Cargar pasos existentes
    _pasos = [
      PasoForm(numero: 1)..descripcion.text = 'Hervir agua con sal',
      PasoForm(numero: 2)..descripcion.text = 'Dorar el guanciale',
      PasoForm(numero: 3)..descripcion.text = 'Mezclar huevos con queso',
    ];
    
    // Simular estado de la receta
    _estadoActual = 'PUBLICADA';
    if (_estadoActual == 'RECHAZADA') {
      _motivoRechazo = 'La imagen no es clara, por favor agrega una mejor foto del plato terminado.';
    }
  }

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

  void _marcarCambios() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Descartar cambios?'),
        content: const Text('Tienes cambios sin guardar. ¿Deseas descartarlos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text(
              'Descartar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _guardarCambios() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simular guardado
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _estadoActual == 'RECHAZADA' 
                ? '✅ Receta actualizada y enviada a revisión'
                : '✅ Receta actualizada exitosamente',
            ),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text(
            'Editar Receta',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (_hasChanges)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: const Text(
                    'Sin guardar',
                    style: TextStyle(fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFFFFA726),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        body: _isLoading
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
                      // Barra de estado
                      if (_motivoRechazo != null)
                        Container(
                          padding: const EdgeInsets.all(15),
                          color: const Color(0xFFF44336).withOpacity(0.1),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning,
                                color: Color(0xFFF44336),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Receta Rechazada',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF44336),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _motivoRechazo!,
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
                        ),
                      
                      // Imagen actual
                      Stack(
                        children: [
                          Image.network(
                            widget.receta.imagen ?? 
                            'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _marcarCambios();
                                // Cambiar imagen
                              },
                              icon: const Icon(Icons.camera_alt, size: 18),
                              label: const Text('Cambiar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black54,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Estado actual
                            _buildEstadoCard(),
                            
                            const SizedBox(height: 25),
                            
                            // Información Básica
                            _buildSeccionTitulo('Información Básica'),
                            _buildCampoTexto(
                              controller: _tituloController,
                              label: 'Título de la Receta',
                              icon: Icons.title,
                              onChanged: (_) => _marcarCambios(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El título es requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildCampoTexto(
                              controller: _descripcionController,
                              label: 'Descripción',
                              icon: Icons.description,
                              maxLines: 3,
                              onChanged: (_) => _marcarCambios(),
                            ),
                            const SizedBox(height: 15),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCampoTexto(
                                    controller: _tiempoController,
                                    label: 'Tiempo (min)',
                                    icon: Icons.timer,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => _marcarCambios(),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildCampoTexto(
                                    controller: _porcionesController,
                                    label: 'Porciones',
                                    icon: Icons.people,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => _marcarCambios(),
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
                            
                            // Estadísticas
                            _buildEstadisticas(),
                            
                            const SizedBox(height: 40),
                            
                            // Botones de acción
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      if (await _onWillPop()) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      side: const BorderSide(
                                        color: Color(0xFFFF8C21),
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Color(0xFFFF8C21),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: _hasChanges ? _guardarCambios : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF8C21),
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Guardar Cambios',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEstadoCard() {
    Color estadoColor;
    IconData estadoIcon;
    String estadoTexto;
    
    switch (_estadoActual) {
      case 'PUBLICADA':
        estadoColor = const Color(0xFF4CAF50);
        estadoIcon = Icons.check_circle;
        estadoTexto = 'Publicada';
        break;
      case 'PENDIENTE_REVISION':
        estadoColor = const Color(0xFFFFA726);
        estadoIcon = Icons.schedule;
        estadoTexto = 'En Revisión';
        break;
      case 'RECHAZADA':
        estadoColor = const Color(0xFFF44336);
        estadoIcon = Icons.cancel;
        estadoTexto = 'Rechazada - Requiere cambios';
        break;
      default:
        estadoColor = const Color(0xFF9E9E9E);
        estadoIcon = Icons.edit;
        estadoTexto = 'Borrador';
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: estadoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: estadoColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(estadoIcon, color: estadoColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado Actual',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  estadoTexto,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: estadoColor,
                  ),
                ),
              ],
            ),
          ),
          if (_estadoActual == 'PUBLICADA')
            TextButton(
              onPressed: () {
                // Ver receta publicada
              },
              child: const Text('Ver publicación'),
            ),
        ],
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

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
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

  Widget _buildSeccionIngredientes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSeccionTitulo('Ingredientes'),
            IconButton(
              onPressed: () {
                setState(() {
                  _ingredientes.add(IngredienteForm());
                  _marcarCambios();
                });
              },
              icon: const Icon(Icons.add_circle),
              color: const Color(0xFF4CAF50),
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
                    onChanged: (_) => _marcarCambios(),
                    decoration: InputDecoration(
                      hintText: 'Ingrediente',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
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
                    onChanged: (_) => _marcarCambios(),
                    decoration: InputDecoration(
                      hintText: 'Cant',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
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
                    onChanged: (_) => _marcarCambios(),
                    decoration: InputDecoration(
                      hintText: 'Unidad',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
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
                        _marcarCambios();
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
                  _marcarCambios();
                });
              },
              icon: const Icon(Icons.add_circle),
              color: const Color(0xFF4CAF50),
            ),
          ],
        ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final PasoForm item = _pasos.removeAt(oldIndex);
              _pasos.insert(newIndex, item);
              _marcarCambios();
            });
          },
          children: _pasos.asMap().entries.map((entry) {
            final index = entry.key;
            final paso = entry.value;
            
            return Container(
              key: ValueKey(paso),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
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
                      onChanged: (_) => _marcarCambios(),
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
                          _marcarCambios();
                        });
                      },
                      icon: const Icon(Icons.close, size: 20),
                      color: Colors.red,
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEstadisticas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSeccionTitulo('Estadísticas'),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF8C21).withOpacity(0.05),
                const Color(0xFFFFB84D).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFF8C21).withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEstadistica(Icons.visibility, '324', 'Vistas'),
                  _buildEstadistica(Icons.star, '4.5', 'Rating'),
                  _buildEstadistica(Icons.comment, '12', 'Comentarios'),
                  _buildEstadistica(Icons.favorite, '45', 'Favoritos'),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+15% de interacción este mes',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEstadistica(IconData icon, String valor, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFF8C21), size: 22),
        const SizedBox(height: 6),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}