import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarEstacionScreen extends StatefulWidget {
  // EditarEstacionScreen();
  final int estacionId;
  final String coordenada;
  final double dirVelViento;
  final double pcpn;
  final double taevap;
  final double tempAmb;
  final double tempMax;
  final double tempMin;

  EditarEstacionScreen(
      {required this.estacionId,
      required this.coordenada,
      required this.dirVelViento,
      required this.pcpn,
      required this.taevap,
      required this.tempAmb,
      required this.tempMax,
      required this.tempMin});

  @override
  _EditarEstacionScreenState createState() => _EditarEstacionScreenState();
}

class _EditarEstacionScreenState extends State<EditarEstacionScreen> {
  TextEditingController coordenada = TextEditingController();
  TextEditingController dirVelViento = TextEditingController();
  TextEditingController pcpn = TextEditingController();
  TextEditingController taevap = TextEditingController();
  TextEditingController tempAmb = TextEditingController();
  TextEditingController tempMax = TextEditingController();
  TextEditingController tempMin = TextEditingController();

  @override
  void initState() {
    super.initState();
    coordenada.text = widget.coordenada.toString();
    dirVelViento.text = widget.dirVelViento.toString();
    pcpn.text = widget.pcpn.toString();
    taevap.text = widget.taevap.toString();
    tempAmb.text = widget.tempAmb.toString();
    tempMax.text = widget.tempMax.toString();
    tempMin.text = widget.tempMin.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Estación'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: coordenada,
              decoration: InputDecoration(labelText: 'Coordenada'),
            ),
            TextFormField(
              controller: dirVelViento,
              decoration: InputDecoration(labelText: 'dirVelViento'),
            ),
            TextFormField(
              controller: pcpn,
              decoration: InputDecoration(labelText: 'pcpn'),
            ),
            TextFormField(
              controller: taevap,
              decoration: InputDecoration(labelText: 'taevap'),
            ),
            TextFormField(
              controller: tempAmb,
              decoration: InputDecoration(labelText: 'tempAmb'),
            ),
            TextFormField(
              controller: tempMax,
              decoration: InputDecoration(labelText: 'tempMax'),
            ),
            TextFormField(
              controller: tempMin,
              decoration: InputDecoration(labelText: 'Temperatura Mínima'),
              // Puedes establecer un valor inicial si lo deseas
            ),
            // Agrega más TextFormField para otros campos según sea necesario
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                actualizarDatosEstacion();
              },
              child: Text('Actualizar'),
            ),
            ////////////////
          ],
        ),
      ),
    );
  }

  Future<void> actualizarDatosEstacion() async {
    final String url =
        'http://localhost:8080/datosEstacion/updateDatosEstacion/${widget.estacionId}';

    Map<String, dynamic> datosActualizados = {
      "coordenada": coordenada.text,
      "dirVelViento": dirVelViento.text,
      "pcpn": pcpn.text,
      "taevap": taevap.text,
      "tempAmb": tempAmb.text,
      "tempMax": tempMax.text,
      "tempMin": tempMin.text,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(datosActualizados),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Mostrar el diálogo emergente
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Actualizado con éxito'),
              content: Text(
                  'Los datos de la estación han sido actualizados correctamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Cierra el diálogo emergente
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {
        print(
            'Error al actualizar los datos de la estación: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al realizar la solicitud PUT: $e');
    }
  }
}
