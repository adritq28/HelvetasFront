import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:helvetasfront/model/Estacion.dart';
import 'package:helvetasfront/model/Municipio.dart';
import 'package:http/http.dart' as http;

class EstacionService extends ChangeNotifier {
  List<DatosEstacion> _lista = [];
  List<DatosEstacion> get lista11 => _lista;

  List<DatosEstacion> _lista3 = [];
  List<DatosEstacion> get lista113 => _lista3;

  List<Municipio> _lista4 = [];
  List<Municipio> get lista114 => _lista4;

  List<Estacion> _lista5 = [];
  List<Estacion> get lista115 => _lista5;

  final String apiUrl =
      'http://localhost:8080/usuario'; // Reemplaza con la URL de tu API

  Future<String?> obtenerCi(int idUsuario) async {
    //final response = await http.get(Uri.parse('$apiUrl/ci/$idUsuario'));
    final response = await http.get(Uri.parse('http://localhost:8080/usuario/ci/$idUsuario'));
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
      final telefono = await obtenerCi(idUsuario);
      return contrasenaIngresada == telefono;
    } catch (e) {
      print('Error al validar la contraseña: $e');
      return false;
    }
  }

  Future<void> getDatosEstacion() async {
    try {
      //print('saasdasd1');
      //final url = Uri.http("localhost:8080", "/personas");
      //print('aaaaaaaa0');
      final response = await http.get(Uri.http("localhost:8080", "/datosEstacion/listaDatosEstacion"));
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
      throw Exception('Erroraaaaa: $e');
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

        _lista.sort((a, b) => b.idUsuario.compareTo(a.idUsuario));

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
    final response =
        await http.delete(Uri.parse('http://localhost:8080/datosEstacion/$id'));
    if (response.statusCode == 200) {
      // La estación se eliminó exitosamente
      // Puedes realizar alguna acción adicional si es necesario
      print('Datos Estacion eliminada correctamente');
    } else {
      // Ocurrió un error al intentar eliminar la estación
      throw Exception('Error al eliminar la estación');
    }
  }

  Future<List<DatosEstacion>> obtenerDatosEstacion(int id) async {
    final response = await http.get(Uri.parse('http://localhost:8080/datosEstacion/$id'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isEmpty) {
        return []; // Indica que no hay datos
      }
      return jsonData.map((item) => DatosEstacion.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener datos del observador');
    }
  }

  Future<List<DatosEstacion>> obtenerDatosMunicipio(int id) async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/datosEstacion/datos_municipio/$id'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isEmpty) {
        return []; // Indica que no hay datos
      }
      return jsonData.map((item) => DatosEstacion.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener datos del observador');
    }
  }

  Future<void> getMunicipio() async {
    try {
      final response = await http
          .get(Uri.http("localhost:8080", "/datosEstacion/vermunicipios"));
      //print('aaaaaaaa');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _lista4 = data.map((e) => Municipio.fromJson(e)).toList();
        print('3333333' + _lista4.length.toString());

        //return datosEstacion;
        notifyListeners();
      } else {
        throw Exception('Failed to load personas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Estacion>> getEstacion(int id) async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/estacion/verEstaciones/$id'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      _lista5 = jsonData.map((e) => Estacion.fromJson(e)).toList();
      notifyListeners();
      if (jsonData.isEmpty) {
        return []; // Indica que no hay datos
      }
      return _lista5;
    } else {
      throw Exception('Error al obtener datos del observador');
    }
  }

  Future<List<DatosEstacion>> getListaMetetorologica(int id) async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/datosEstacion/obtener_estacion_meteorologica/$id'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      _lista3 = jsonData.map((e) => DatosEstacion.fromJson(e)).toList();
      notifyListeners();
      if (jsonData.isEmpty) {
        return []; // Indica que no hay datos
      }
      return _lista3;
    } else {
      throw Exception('Error al obtener datos del observador');
    }
  }

  Future<void> getDatos() async {
    try {
      final response = await http
          .get(Uri.http("localhost:8080", "/datosEstacion/verDatosEstacion"));
      //print('aaaaaaaa');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _lista3 = data.map((e) => DatosEstacion.fromJson(e)).toList();
        print('3333333' + _lista.length.toString());

        //return datosEstacion;
        notifyListeners();
      } else {
        throw Exception('Failed to load personas');
      }
    } catch (e) {
      throw Exception('Erroreeee: $e');
    }
  }
}
