import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReaccionesService extends ChangeNotifier {
  final String baseUrl = "http://192.168.0.5:18000/api";

  // Método para dar like a una publicación
  Future<void> darLike(int idPublicacion, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion/reaccion"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        print("Publicación con Like añadida.");
      } else {
        print("Error al añadir Like: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al dar Like: $e");
    }
  }

  // Método para quitar el like de una publicación
  Future<void> quitarLike(int idPublicacion, String token) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion/reaccion"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        print("Like eliminado.");
      } else {
        print("Error al eliminar Like: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al quitar Like: $e");
    }
  }
}
