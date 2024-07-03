import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Municipio.dart';
import 'package:http/http.dart' as http;

class MunicipioService extends ChangeNotifier {
  List<Municipio> _lista = [];

  List<Municipio> get lista11 => _lista;
  List<Municipio> _lista5 = [];
  List<Municipio> get lista115 => _lista5;

  final String apiUrl =
      'http://localhost:8080/usuario'; // Reemplaza con la URL de tu API

  Future<String?> obtenerTelefono(int idUsuario) async {
    final response = await http.get(Uri.parse('$apiUrl/telefono/$idUsuario'));
    if (response.statusCode == 200) {
      return response
          .body; // Asumiendo que el teléfono se devuelve como texto plano
    } else {
      throw Exception('Error al obtener el teléfono');
    }
  }

  Future<void> obtenerZonas(int id) async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/municipio/zona/$id'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _lista = data.map((e) => Municipio.fromJson(e)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load personas');
      }
      
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  void printLista() {
    _lista.forEach((municipio) {
      print('Municipio ID: ${municipio.idMunicipio}');
      print('Nombre: ${municipio.nombreMunicipio}');
      print('ID Zona: ${municipio.idZona}');
      print('Nombre Zona: ${municipio.nombreZona}');
      print('---------------------------');
    });
  }
}
