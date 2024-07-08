import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosPronostico.dart';
import 'package:helvetasfront/model/Fenologia.dart';
import 'package:http/http.dart' as http;

class FenologiaService extends ChangeNotifier {
  List<Fenologia> _lista = [];
  List<DatosPronostico> _lista2 = [];
  List<Fenologia> get lista11 => _lista;
  List<DatosPronostico> get lista112 => _lista2;
  List<Fenologia> _lista5 = [];
  List<Fenologia> get lista115 => _lista5;

  Future<List<DatosPronostico>> pronosticoCultivo(int idCultivo) async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/datos_pronostico/registro/$idCultivo'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isEmpty) {
        return []; // Indica que no hay datos
      }
      return jsonData.map((item) => DatosPronostico.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener datos del observador');
    }
  }


  Future<void> obtenerFenologia(int id) async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/fenologia/verFenologia/$id'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _lista = data.map((e) => Fenologia.fromJson(e)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load personas');
      }
      
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Fenologia>> alertas(int idFenologia, int idZona) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/datos_pronostico/comparacion/$idFenologia/$idZona'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      // Imprimir la respuesta completa
      print('Respuesta completa: ${response.body}');

      // Imprimir la lista decodificada
      print('Datos decodificados: $jsonData');

      if (jsonData.isEmpty) {
        return []; // Indica que no hay datos
      }

      // Mapear a objetos DatosPronostico y imprimir cada uno
      List<Fenologia> datosList =
          jsonData.map((item) => Fenologia.fromJson(item)).toList();
      datosList.forEach((datos) {
        print('DatosPronostico: ${datos.toString()}');
      });

      return datosList;
    } else {
      throw Exception('Error al obtener datos del observador');
    }
  }

Future<String> fetchUltimaAlerta(int cultivoId) async {
  final url = Uri.parse('http://localhost:8080/alertas/ultima/$cultivoId');

  try {
    print('Making GET request to: $url'); // Añade esta línea para verificar la URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      String responseBody = response.body;
      print('Response Body: $responseBody'); // Imprime el cuerpo de la respuesta
      return responseBody;
    } else {
      print('Failed to load alert: ${response.statusCode}'); // Imprime el estado del error
      throw Exception('Failed to load alert: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching alert: $e'); // Imprime el error capturado
    throw Exception('Error fetching alert: $e');
  }
}



}
