import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:http/http.dart' as http;

class EstacionService extends ChangeNotifier {
  List<DatosEstacion> _lista = [];

  List<DatosEstacion> get lista11 => _lista;

  Future<void> getDatosEstacion() async {
    try {
      //print('saasdasd1');
      //final url = Uri.http("localhost:8080", "/personas");
      //print('aaaaaaaa0');
      final response = await http
          .get(Uri.http("localhost:8080", "/datosEstacion/listaDatosEstacion"));
      //print('aaaaaaaa');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _lista = data.map((e) => DatosEstacion.fromJson(e)).toList();
        print('3333333' + _lista.length.toString());

        //return datosEstacion;
        notifyListeners();
      } else {
        throw Exception('Failed to load personas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<DatosEstacion>> getDatosEstacion2() async {
    try {
      //print('saasdasd1');
      //final url = Uri.http("localhost:8080", "/personas");
      //print('aaaaaaaa0');
      final response = await http
          .get(Uri.http("localhost:8080", "/datosEstacion/listaDatosEstacion"));
      //print('aaaaaaaa');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _lista.sort((a, b) => b.id.compareTo(a.id));

        // Limita la lista a los primeros 10 elementos
        _lista = _lista.take(10).toList();
        //print('222222222');
        List<DatosEstacion> datosEstacion =
            data.map((e) => DatosEstacion.fromJson(e)).toList();
        //print('3333333');
        return datosEstacion;
      } else {
        throw Exception('Failed to load personas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> saveDatosEstacion(DatosEstacion estacion) async {
    try {
      final response = await http.post(
        Uri.http("localhost:8080", "/datosEstacion/addDatosEstacion"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(estacion.toJson()),
      );
      if (response.statusCode == 201) {
        //print('Datos Estacion guardada correctamente');
        //print(response.statusCode);
        notifyListeners();
        //getDatosEstacion();
        return (response.body.toString());
      } else {
        throw Exception('Error al guardar la persona');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> eliminarEstacion(int id) async {
    print('Dsddddddddddddddddde');
  final response = await http.delete(Uri.parse('http://localhost:8080/datosEstacion/$id'));
  if (response.statusCode == 200) {
    // La estación se eliminó exitosamente
    // Puedes realizar alguna acción adicional si es necesario
    print('Datos Estacion eliminada correctamente');
  } else {
    // Ocurrió un error al intentar eliminar la estación
    throw Exception('Error al eliminar la estación');
  }
}
}
