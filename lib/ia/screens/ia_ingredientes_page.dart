import 'package:flutter/material.dart';
import '../widgets/dialogo_eliminar.dart';
import '../widgets/input_ingrediente.dart';
import '../widgets/card_ingrediente.dart';
import '../widgets/dialogo_alerta.dart'; 
import 'ia_recetas_page.dart';
import '../controllers/ia_controller.dart';

class IaIngredientesPage extends StatefulWidget {
  final List<dynamic>? ingredientesIniciales;

  const IaIngredientesPage({
    super.key, 
    this.ingredientesIniciales
  });

  @override
  State<IaIngredientesPage> createState() => _IaIngredientesPageState();
}

class _IaIngredientesPageState extends State<IaIngredientesPage> {
  final IaController _iaController = IaController();
  
  bool _mostrarInput = false;
  bool _cargando = false; 

  List<Map<String, String>> ingredientes = [];
  List<String> _catalogoIngredientesNombres = [];
  List<String> _catalogoUnidadesNombres = [];

  static const String _alergenoPeligroso = "Mantequilla de Mani";

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
    _cargarCatalogos();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarSiExisteAlergeno();
    });
  }

  void _cargarDatosIniciales() {
    if (widget.ingredientesIniciales != null) {
      for (var item in widget.ingredientesIniciales!) {
        ingredientes.add({
          'cantidad': item['cantidad'].toString(),
          'unidad': item['unidad'].toString(),
          'nombre': item['nombre'].toString(),
        });
      }
    }
  }

  void _verificarSiExisteAlergeno() {
    final existeAlergeno = ingredientes.any(
      (item) => item['nombre'] == _alergenoPeligroso
    );

    if (existeAlergeno) {
      _mostrarDialogoAlergeno(_alergenoPeligroso);
    }
  }

  void _mostrarDialogoAlergeno(String nombreIngrediente) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DialogoAlerta(
        ingrediente: nombreIngrediente,
        onContinuar: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _cargarCatalogos() async {
    try {
      final resultados = await Future.wait([
        _iaController.listarCatalogoIngredientes(),
        _iaController.listarUnidades(),
      ]);

      if (!mounted) return;

      setState(() {
        _catalogoIngredientesNombres = (resultados[0] as List)
            .map((item) => item['descripcion'].toString())
            .toList();
        
        _catalogoUnidadesNombres = (resultados[1] as List)
            .map((item) => item['descripcion'].toString())
            .toList();
      });
    } catch (e) {
      debugPrint("Error cargando catálogos: $e");
    }
  }

  void _mostrarDialogoEliminar(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DialogoEliminar(
        onConfirmar: () {
          setState(() {
            ingredientes.removeAt(index);
          });
          Navigator.pop(context);
        },
        onCancelar: () => Navigator.pop(context),
      ),
    );
  }

  bool _yaExiste(String nombre) {
    return ingredientes.any(
      (item) => item['nombre']!.toLowerCase() == nombre.toLowerCase(),
    );
  }

  Future<void> _confirmarYBuscarRecetas() async {
    if (ingredientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agrega al menos un ingrediente.")),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      List<String> listaNombres = ingredientes.map((e) => e['nombre']!).toList();
      
      final recetasEncontradas = await _iaController.buscarRecetas(listaNombres);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IaRecetasPage(recetas: recetasEncontradas),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double botonAncho = MediaQuery.of(context).size.width * 0.70;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Permite que los botones suban con el teclado
      
      appBar: AppBar(
        title: const Text(
          'Ingredientes',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF8C21),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          // Usamos Column para dividir: Arriba (Scroll) y Abajo (Fijo)
          Column(
            children: [
              // ---------------------------------------------------------
              // PARTE SUPERIOR: SCROLLEABLE (Lista + Input)
              // ---------------------------------------------------------
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hemos identificado los siguientes ingredientes. '
                        'Si falta alguno añádelo, si hay alguno erróneo edítalo:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF333333),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Lista de ingredientes
                      if (ingredientes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: Text("No hay ingredientes. Añade uno.")),
                        )
                      else
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ingredientes.length,
                          itemBuilder: (context, index) {
                            final item = ingredientes[index];

                            return CardIngrediente(
                              key: ValueKey('card_$index'),
                              cantidad: item['cantidad']!,
                              unidad: item['unidad']!,
                              nombre: item['nombre']!,
                              
                              catalogoIngredientes: _catalogoIngredientesNombres,
                              catalogoUnidades: _catalogoUnidadesNombres,
                              
                              onEditar: (nuevoCantidad, nuevaUnidad, nuevoNombre) {
                                setState(() {
                                  ingredientes[index]['cantidad'] = nuevoCantidad;
                                  ingredientes[index]['unidad'] = nuevaUnidad;
                                  ingredientes[index]['nombre'] = nuevoNombre;
                                });

                                if (nuevoNombre == _alergenoPeligroso) {
                                   _mostrarDialogoAlergeno(nuevoNombre);
                                }
                              },
                              onEliminar: () => _mostrarDialogoEliminar(index),
                            );
                          },
                        ),

                      const SizedBox(height: 10),

                      // Input animado (se queda dentro del scroll para que suba si hace falta)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _mostrarInput
                            ? InputIngrediente(
                                key: const ValueKey("inputIngrediente"),
                                catalogoIngredientes: _catalogoIngredientesNombres,
                                catalogoUnidades: _catalogoUnidadesNombres,
                                
                                onAgregar: (unidad, nombre) {
                                  if (_yaExiste(nombre)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Este ingrediente ya existe."),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    ingredientes.add({
                                      'cantidad': "1",
                                      'unidad': unidad.isEmpty ? 'unidad' : unidad,
                                      'nombre': nombre,
                                    });
                                    _mostrarInput = false;
                                  });

                                  if (nombre == _alergenoPeligroso) {
                                     _mostrarDialogoAlergeno(nombre);
                                  }
                                },
                                onEliminar: () {
                                  setState(() => _mostrarInput = false);
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                      
                      // Espacio al final del scroll para que no choque con los botones fijos
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // ---------------------------------------------------------
              // PARTE INFERIOR: BOTONES FIJOS
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ocupa solo lo necesario
                  children: [
                    // Botón Añadir
                    Center(
                      child: SizedBox(
                        width: botonAncho,
                        child: ElevatedButton(
                          onPressed: () {
                             setState(() => _mostrarInput = true);
                             // Opcional: Scrollear hacia abajo si quieres ver el input al abrirse
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8C21),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            '+ Añadir Ingrediente',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Botón Confirmar
                    Center(
                      child: SizedBox(
                        width: botonAncho,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _cargando ? null : _confirmarYBuscarRecetas,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8C21),
                            disabledBackgroundColor: const Color(0xFFFF8C21).withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _cargando
                            ? const SizedBox(
                                height: 24, 
                                width: 24, 
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              )
                            : const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                        ),
                      ),
                    ),
                    
                    // Un pequeño espacio abajo por si acaso (SafeArea)
                    SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 10 : 0),
                  ],
                ),
              ),
            ],
          ),
          
          if (_cargando)
             ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.3)),
        ],
      ),
    );
  }
}