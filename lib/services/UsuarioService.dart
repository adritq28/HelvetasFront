import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/UsuarioEstacion.dart';
import 'package:http/http.dart' as http;

class UsuarioService extends ChangeNotifier {
  List<UsuarioEstacion> _lista = [];

  List<UsuarioEstacion> get lista11 => _lista;

  
  
  Future<void> getUsuario() async {
    try {
      final response = await http.get(Uri.http("localhost:8080", "/usuario/verusuarios"));
      //print('aaaaaaaa');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        

        _lista = data.map((e) => UsuarioEstacion.fromJson(e)).toList();
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



  Future<String> saveUsuario(UsuarioEstacion usuarioEstacion) async {
    try {
      final response = await http.post(
        Uri.http("localhost:8080", "/datosEstacion/addDatosEstacion"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(usuarioEstacion.toJson()),
      );
      if (response.statusCode == 201) {
        //print('Datos Estacion guardada correctamente');
        //print(response.statusCode);
        notifyListeners();
        //getDatosEstacion();
        return (response.body.toString());
      } else {
        throw Exception('Error al guardar la usuario');
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
