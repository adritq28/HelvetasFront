import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/screens/Administrador/EditarMeteorologicaScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DatosMeteorologicaScreen extends StatefulWidget {
  final int idEstacion;
  final String nombreMunicipio;
  final String nombreEstacion;
  //final String tipoEstacion;

  const DatosMeteorologicaScreen({
    required this.idEstacion,
    required this.nombreMunicipio,
    required this.nombreEstacion,
    //required this.tipoEstacion
  });

  @override
  _DatosMeteorologicaScreenState createState() =>
      _DatosMeteorologicaScreenState();
}

class _DatosMeteorologicaScreenState extends State<DatosMeteorologicaScreen> {
  List<Map<String, dynamic>> datos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDatosMeteorologicos();
  }

  Future<void> fetchDatosMeteorologicos() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/estacion/lista_datos_meteorologica/${widget.idEstacion}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        datos = List<Map<String, dynamic>>.from(json.decode(response.body));
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load datos meteorologicos');
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  void editarDato(int index) {
  // Obtener los datos del índice seleccionado
  Map<String, dynamic> dato = datos[index];

  // Navegar a la pantalla de edición pasando los datos como argumentos
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditarMeteorologicaScreen(
        tempMax: dato['tempMax'],
        tempMin: dato['tempMin'],
        pcpn: dato['pcpn'],
        tempAmb: dato['tempAmb'],
        dirViento: dato['dirViento'],
        velViento: dato['velViento'],
        taevap: dato['taevap'],
        fechaReg: dato['fechaReg'],
      ),
    ),
  );
}


  void visualizarDato(int index) {
    // Implementar la lógica para visualizar el dato en la posición 'index'
    print('Visualizar dato en la posición $index');
  }

  void eliminarDato(int index) {
    // Implementar la lógica para eliminar el dato en la posición 'index'
    print('Eliminar dato en la posición $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/fondo.jpg'), // Ruta de la imagen de fondo
                fit: BoxFit
                    .cover, // Ajustar la imagen para cubrir todo el contenedor
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("images/47.jpg"),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Municipio de: ${widget.nombreMunicipio}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(208, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Estación Meteorologica: ${widget.nombreEstacion}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(208, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Fecha',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Temp Max',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Temp Min',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Precipitación',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Temp Ambiente',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Dir Viento',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Vel Viento',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Evaporacion',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Acciones',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: datos.map((dato) {
                                  int index = datos.indexOf(dato);
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          formatDateTime(
                                              dato['fechaReg'].toString()),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dato['tempMax'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dato['tempMin'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dato['pcpn'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dato['tempAmb'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dato['dirViento'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dato['velViento'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dato['taevap'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => editarDato(index),
                                              child: Container(
                                                padding: EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color(0xFFF0B27A),
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () =>
                                                  visualizarDato(index),
                                              child: Container(
                                                padding: EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color(0xFF58D68D),
                                                ),
                                                child: Icon(
                                                  Icons.remove_red_eye_sharp,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () => eliminarDato(index),
                                              child: Container(
                                                padding: EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color(0xFFEC7063),
                                                ),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
