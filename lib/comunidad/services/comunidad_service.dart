import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComunidadService extends ChangeNotifier {
  bool loading = false; // Indica si estamos cargando las publicaciones
  List<dynamic> posts = []; // Lista donde almacenaremos las publicaciones

  // Método para cargar las publicaciones desde la API
  Future<void> cargarFeed(String token) async {
    loading = true; // Iniciamos el estado de carga
    notifyListeners(); // Notificamos a los widgets que el estado ha cambiado

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.5:18000/api/publicaciones'), // Endpoint de publicaciones
        headers: {
          'Authorization': 'Bearer $token', // Autenticación con token
          'Accept': 'application/json', // Aceptamos JSON como respuesta
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        posts = data['data']; // Asignamos las publicaciones a la lista
      } else {
        throw Exception('Error al cargar las publicaciones');
      }
    } catch (e) {
      print('Error al obtener las publicaciones: $e');
      // Puedes mostrar un mensaje de error o realizar alguna acción aquí
    }

    loading = false; // Terminamos de cargar
    notifyListeners(); // Notificamos a los widgets que los datos han cambiado
  }

  // Método adicional para obtener una publicación por su ID (si lo necesitas)
  Future<void> obtenerPublicacionPorId(int id, String token) async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.5:18000/api/publicaciones/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        posts = [data['data']]; // Asignamos solo una publicación
      } else {
        throw Exception('Error al obtener la publicación');
      }
    } catch (e) {
      print('Error al obtener la publicación: $e');
    }

    loading = false;
    notifyListeners();
  }
}
