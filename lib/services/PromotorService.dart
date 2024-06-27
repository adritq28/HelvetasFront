import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Promotor.dart';
import 'package:http/http.dart' as http;

class PromotorService extends ChangeNotifier {
  List<Promotor> _lista = [];

  List<Promotor> get lista11 => _lista;

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

  Future<bool> validarContrasena(
      String contrasenaIngresada, int idUsuario) async {
    try {
      final telefono = await obtenerTelefono(idUsuario);
      return contrasenaIngresada == telefono;
    } catch (e) {
      print('Error al validar la contraseña: $e');
      return false;
    }
  }

  // Future<void> getPromotor() async {
  //   try {
  //     final response =
  //         await http.get(Uri.http("localhost:8080", "/promotor/lista_promotor"));
  //     //print('aaaaaaaa');
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);

  //       _lista = data.map((e) => Promotor.fromJson(e)).toList();
  //       print('3333333' + _lista.length.toString());

  //       //return datosEstacion;
  //       notifyListeners();
  //     } else {
  //       throw Exception('Failed to load personas');
  //     }
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }
  Future<void> getPromotor() async {
  try {
    final response = await http.get(Uri.http("localhost:8080", "/promotor/lista_promotor"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _lista = data.map((e) => Promotor.fromJson(e)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load personas');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

  
}
