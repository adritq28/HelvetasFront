import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PruebaEditar extends StatefulWidget {
  @override
  _PruebaEditarState createState() => _PruebaEditarState();
}

class _PruebaEditarState extends State<PruebaEditar> {
  TextEditingController _coordenadaController = TextEditingController();
  TextEditingController _dirVelVientoController = TextEditingController();
  // Agrega controladores para otros campos según sea necesario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Estación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _coordenadaController,
              decoration: InputDecoration(labelText: 'Coordenada'),
            ),
            TextFormField(
              controller: _dirVelVientoController,
              decoration: InputDecoration(labelText: 'Dirección del Viento'),
            ),
            // Agrega más campos según sea necesario
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar los datos editados
                _guardarCambios();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  // void _guardarCambios() {
  //   // Obtener los valores editados de los controladores y enviarlos al backend
  //   String coordenada = _coordenadaController.text;
  //   String dirVelViento = _dirVelVientoController.text;
  //   // Envía estos valores al backend para guardar los cambios
  //   // Puedes usar un servicio HTTP para enviar una solicitud PUT al backend
  // }

  void _guardarCambios() async {
  String baseUrl = Uri.http("localhost:8080", "/datosEstacion/77").toString();
  //String baseUrl = "localhost:8080", "/datosEstacion/addDatosEstacion",
  int idEstacion = 77; // Supongamos que ya tienes el ID de la estación
  String url = '$baseUrl/$idEstacion';

  String coordenada = _coordenadaController.text;
  String dirVelViento = _dirVelVientoController.text;

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    // Agrega cualquier otra cabecera que necesites, como tokens de autenticación
  };

  Map<String, dynamic> body = {
    'coordenada': coordenada,
    'dirVelViento': dirVelViento,
    // Agrega otros campos según sea necesario
  };

  try {
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Los datos se actualizaron exitosamente en el backend
      print('Datos actualizados correctamente');
    } else {
      // Error al actualizar los datos en el backend
      print('Error al actualizar los datos');
      print('Código de estado: ${response.statusCode}');
      print('Mensaje de error: ${response.body}');
    }
  } catch (e) {
    // Error de conexión o error en la solicitud
    print('Error: $e');
  }
}

}
