import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/UsuarioEstacion.dart';
import 'package:helvetasfront/screens/Administrador/AdminScreen.dart';
import 'package:http/http.dart' as http;

class UsuarioService extends ChangeNotifier {
  List<UsuarioEstacion> _lista = [];

  List<UsuarioEstacion> get lista11 => _lista;

  Future<void> getUsuario() async {
    try {
      final response =
          await http.get(Uri.http("localhost:8080", "/usuario/verusuarios"));
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

  Future<void> login(String nombreUsuario, String password, BuildContext context) async {
  final url = Uri.parse('http://localhost:8080/usuario/login');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nombreUsuario': nombreUsuario,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    String responseBody = response.body;
    print('Respuesta del servidor: $responseBody');

    try {
      // Intentar decodificar la respuesta JSON
      Map<String, dynamic> userDetails = jsonDecode(responseBody);

      if (userDetails.isNotEmpty) {
        // Usuario es administrador, navegar a AdminScreen con detalles del usuario
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminScreen(
              idUsuario: userDetails['idUsuario'],
              nombre: userDetails['nombre'],
              apeMat: userDetails['apeMat'],
              apePat: userDetails['apePat'],
              ci: userDetails['ci'],
            ),
          ),
        );
      } else {
        // Usuario no es administrador, manejar según sea necesario
       // transferencia de gdatos de obs hacia gam  urg de gob locales y luego alsenamhi
       //senmahi smat y gam
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de autenticación'),
              content: Text(responseBody), // Mostrar mensaje de error recibido del servidor
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Si no se puede decodificar como JSON, manejar como mensaje de texto simple
      print('Error al decodificar JSON: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de autenticación'),
            content: Text(responseBody), // Mostrar mensaje de error recibido del servidor
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } else {
    // Manejar otros casos de error, como 401, 404, etc.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Usuario no encontrado'),
          content: Text('Hubo un problema al conectar con el servidor.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


}
