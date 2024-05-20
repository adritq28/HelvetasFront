import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuarioEstacion {
  final int idUsuario;
  final String nombreMunicipio;
  final String nombreEstacion;
  final String tipoEstacion;
  final String nombreCompleto;
  final String telefono;

  UsuarioEstacion({
    required this.idUsuario,
    required this.nombreMunicipio,
    required this.nombreEstacion,
    required this.tipoEstacion,
    required this.nombreCompleto,
    required this.telefono,
  });

  factory UsuarioEstacion.fromJson(Map<String, dynamic> json) {
    return UsuarioEstacion(
      idUsuario: json['idUsuario'],
      nombreMunicipio: json['nombre'],
      nombreEstacion: json['nombre'],
      tipoEstacion: json['tipoEstacion'],
      nombreCompleto: json['nombreCompleto'],
      telefono: json['telefono'],
    );
  }
}
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}
class _MyWidgetState extends State<MyWidget> {
  late Future<List<UsuarioEstacion>> _futureUsuariosEstacion;
  List<UsuarioEstacion> _lista = [];

  List<UsuarioEstacion> get lista11 => _lista;

  @override
  void initState() {
    super.initState();
    _futureUsuariosEstacion = getUsuario(); // Inicializa _futureUsuariosEstacion
  }

  Future<List<UsuarioEstacion>> getUsuario() async {
    try {
      print('aaaaaaaaaaaaaa');
      final response =
          await http.get(Uri.http("localhost:8080", "/usuario/verusuarios"));
      print('bbbbbbbbbbbbbbb');
      if (response.statusCode == 200) {
        print('ccccccccccc');
        final List<dynamic> data = json.decode(response.body);
        print('dddddddddd');
        _lista = data.map((e) => UsuarioEstacion.fromJson(e)).toList();
        
        print('ppppppppp');
        print('Cantidad de usuarios: ${_lista.length}');
        //notifyListeners();
        return _lista; // Devuelve la lista después de cargar los datos
      } else {
        throw Exception('Failed to load personas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsuarioEstacion>>(
      future: _futureUsuariosEstacion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return DataTable(
            columns: [
              DataColumn(label: Text('Nombre Completo')),
              DataColumn(label: Text('Estación')),
              DataColumn(label: Text('Municipio')),
              DataColumn(label: Text('Tipo de Estación')),
              DataColumn(label: Text('Teléfono')),
            ],
            rows: snapshot.data!.map((usuarioEstacion) {
              return DataRow(cells: [
                DataCell(Text(usuarioEstacion.nombreCompleto)),
                DataCell(Text(usuarioEstacion.nombreEstacion)),
                DataCell(Text(usuarioEstacion.nombreMunicipio)),
                DataCell(Text(usuarioEstacion.tipoEstacion)),
                DataCell(Text(usuarioEstacion.telefono)),
              ]);
            }).toList(),
          );
        }
      },
    );
  }
}