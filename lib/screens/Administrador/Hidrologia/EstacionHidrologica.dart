import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/screens/Administrador/Hidrologia/DatosHidrologicaScreen.dart';
import 'package:http/http.dart' as http;

class EstacionHidrologicaScreen extends StatefulWidget {
  final int idUsuario;
  final String nombre;
  final String apeMat;
  final String apePat;
  final String ci;

  const EstacionHidrologicaScreen({
    required this.idUsuario,
    required this.nombre,
    required this.apeMat,
    required this.apePat,
    required this.ci,
  });

  @override
  _EstacionHidrologicaScreenState createState() =>
      _EstacionHidrologicaScreenState();
}

class _EstacionHidrologicaScreenState
    extends State<EstacionHidrologicaScreen> {
  List<Map<String, dynamic>> estaciones = [];
  Map<String, List<Map<String, dynamic>>> estacionesPorMunicipio = {};
  String? municipioSeleccionado;
  String? estacionSeleccionada;
  int? idEstacionSeleccionada;
  //String? tipoEstacion;

  @override
  void initState() {
    super.initState();
    fetchEstacionesHidrologica();
  }


  Future<void> fetchEstacionesHidrologica() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/estacion/lista_hidrologica'));
    if (response.statusCode == 200) {
      setState(() {
        estaciones =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        estacionesPorMunicipio = agruparEstacionesPorMunicipio(estaciones);
      });
    } else {
      throw Exception('Failed to load estaciones');
    }
  }

  Map<String, List<Map<String, dynamic>>> agruparEstacionesPorMunicipio(
      List<Map<String, dynamic>> estaciones) {
    Map<String, List<Map<String, dynamic>>> agrupadas = {};
    for (var estacion in estaciones) {
      if (!agrupadas.containsKey(estacion['nombreMunicipio'])) {
        agrupadas[estacion['nombreMunicipio']] = [];
      }
      agrupadas[estacion['nombreMunicipio']]!.add(estacion);
    }
    return agrupadas;
  }

  void navigateToDatosHidrologicaScreen() {
    if (idEstacionSeleccionada != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DatosHidrologicaScreen(idEstacion: idEstacionSeleccionada!, nombreMunicipio: municipioSeleccionado!, nombreEstacion: estacionSeleccionada!, ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Opción 1'),
                        value: 'opcion1',
                      ),
                      PopupMenuItem(
                        child: Text('Opción 2'),
                        value: 'opcion2',
                      ),
                      PopupMenuItem(
                        child: Text('Opción 3'),
                        value: 'opcion3',
                      ),
                    ],
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("images/47.jpg"),
                      ),
                      SizedBox(width: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bienvenid@: ${widget.nombre} ${widget.apePat} ${widget.apeMat}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(208, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            Expanded(
              child: estaciones.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: estacionesPorMunicipio.keys.length,
                      itemBuilder: (context, index) {
                        String municipio =
                            estacionesPorMunicipio.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      municipioSeleccionado = municipio;
                                      estacionSeleccionada = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 203, 230, 255),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      municipio,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 34, 52, 96),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (municipioSeleccionado != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Seleccione una estación en $municipioSeleccionado:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 240, 255),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: estacionSeleccionada,
                      hint: Text(
                        'Seleccione una estación',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 236, 241, 255),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          estacionSeleccionada = newValue;
                          idEstacionSeleccionada = estacionesPorMunicipio[municipioSeleccionado]!
                              .firstWhere((element) => element['nombreEstacion'] == newValue)['idEstacion'];
                          navigateToDatosHidrologicaScreen();
                        });
                      },
                      items: estacionesPorMunicipio[municipioSeleccionado]!
                          .map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> estacion) {
                        return DropdownMenuItem<String>(
                          value: estacion['nombreEstacion'],
                          child: Text(estacion['nombreEstacion']),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
