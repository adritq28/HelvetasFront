import 'dart:convert';
import 'dart:html' as html;

import 'package:excel/excel.dart' as excel_pkg;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helvetasfront/model/DatosEstacionHidrologica.dart';
import 'package:helvetasfront/services/EstacionHidrologicaService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListaInvitadoHidrologicaScreen extends StatefulWidget {
  final int idEstacion;
  final String nombreMunicipio;
  final String nombreEstacion;

  const ListaInvitadoHidrologicaScreen({
    required this.idEstacion,
    required this.nombreMunicipio,
    required this.nombreEstacion,
  });

  @override
  _ListaInvitadoHidrologicaScreenState createState() =>
      _ListaInvitadoHidrologicaScreenState();
}

class _ListaInvitadoHidrologicaScreenState
    extends State<ListaInvitadoHidrologicaScreen> {
  final EstacionHidrologicaService _datosService2 =
      EstacionHidrologicaService(); // Instancia del servicio de datos
  late Future<List<DatosEstacionHidrologica>> _futureDatosEstacion;
  late List<Map<String, dynamic>> datos = [];
  bool isLoading = true;
  List<Map<String, dynamic>> datosFiltrados = [];
  String? mesSeleccionado;
  List<String> meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  @override
  void initState() {
    super.initState();
    fetchDatosHidrologico();
  }

  Future<void> fetchDatosHidrologico() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/estacion/lista_datos_hidrologica/${widget.idEstacion}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        datos = List<Map<String, dynamic>>.from(json.decode(response.body));
        datosFiltrados = datos; // Inicialmente, no se filtra nada
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load datos hidrologicos');
    }
  }

  Future<void> exportToExcel(List<Map<String, dynamic>> datosList) async {
    try {
      var excel = excel_pkg.Excel.createExcel(); // Crear un nuevo archivo Excel
      excel_pkg.Sheet sheetObject =
          excel['Sheet1']; // Seleccionar la primera hoja

      // Escribir los encabezados
      sheetObject.appendRow([
        'Nombre del Municipio',
        'Nombre del Estacion',
        'Limnimetro',
        'Fecha Reg',
        'ID Estación',
        'Delete'
      ]);

      // Escribir los datos
      for (var dato in datosList) {
        sheetObject.appendRow([
          widget.nombreMunicipio,
          widget.nombreEstacion,
          dato['limnimetro'],
          dato['fechaReg'],
          dato['idEstacion'],
          dato['delete']
        ]);
      }

      // Guardar el archivo Excel en memoria
      var fileBytes = excel.save();
      if (fileBytes == null) {
        throw Exception('No se pudo generar el archivo Excel.');
      }

      // Crear un blob de datos
      final blob = html.Blob([fileBytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Crear un enlace de descarga y hacer clic en él
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "DatosHidrologicos.xlsx")
        ..click();

      // Liberar la URL del blob
      html.Url.revokeObjectUrl(url);

      print('Archivo listo para descargar');
    } catch (e) {
      print('Error al guardar el archivo: $e');
    }
  }

  void exportarDato() {
    exportToExcel(datosFiltrados);
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return 'Fecha no disponible';
    }
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
    } catch (e) {
      print('Error al parsear la fecha: $dateTimeString');
      return 'Fecha inválida';
    }
  }

  void filtrarDatosPorMes(String? mes) {
    if (mes == null || mes.isEmpty) {
      setState(() {
        datosFiltrados = datos;
      });
      return;
    }

    int mesIndex = meses.indexOf(mes) + 1; // Meses son 1-indexados en DateTime

    setState(() {
      datosFiltrados = datos.where((dato) {
        try {
          DateTime fecha = DateTime.parse(dato['fechaReg']);
          return fecha.month == mesIndex;
        } catch (e) {
          print('Error al parsear la fecha: ${dato['fechaReg']}');
          return false;
        }
      }).toList();
    });
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
                  SizedBox(height: 10),
                  Container(
                    height: 90,
                    color: Color.fromARGB(
                        51, 25, 25, 26), // Fondo negro con 20% de opacidad
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage("images/47.jpg"),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10.0,
                            runSpacing: 5.0,
                            children: [
                              Text(
                                "Bienvenido Invitado",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '| Municipio de: ${widget.nombreMunicipio}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(208, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '| Estación Hidrológica: ${widget.nombreEstacion}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(208, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.5, // Ajusta el ancho según tus necesidades
                    child: DropdownButton<String>(
                      value: mesSeleccionado,
                      hint: Text(
                        'Seleccione un mes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          mesSeleccionado = newValue;
                          filtrarDatosPorMes(newValue);
                        });
                      },
                      items: meses.map<DropdownMenuItem<String>>((String mes) {
                        return DropdownMenuItem<String>(
                          value: mes,
                          child: Text(
                            mes,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 185, 223,
                                  255), // Cambia el color del texto en el DropdownMenuItem
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.grey[
                          800], // Cambia el color de fondo del menú desplegable
                      style: const TextStyle(
                        color: Colors
                            .white, // Cambia el color del texto del DropdownButton
                      ),
                      iconEnabledColor:
                          Colors.white, // Cambia el color del icono desplegable
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: exportarDato,
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text(
                          'Exportar datos',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 142, 146, 143),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                                      'Limnimetro',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: datosFiltrados.map((dato) {
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
                                          dato['limnimetro'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Footer(), // Añadido Footer aquí
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      //color: Color.fromARGB(35, 20, 19, 19), // Color de fondo del footer
      child: Center(
        child: Text(
          '@Pachatatiña 2024 | HELVETAS | EUROCLIMA',
          style: GoogleFonts.convergence(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 237, 237, 239), // Color del texto
              fontSize: 16.0, // Tamaño de la fuente
              //fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center, // Centra el texto
        ),
      ),
    );
  }
}
