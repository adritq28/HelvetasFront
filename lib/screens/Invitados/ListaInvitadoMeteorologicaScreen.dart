import 'dart:convert';
import 'dart:html' as html;

import 'package:excel/excel.dart' as excel_pkg;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helvetasfront/screens/Administrador/Meteorologia/GraficaScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListaInvitadoMeteorologicaScreen extends StatefulWidget {
  final int idEstacion;
  final String nombreMunicipio;
  final String nombreEstacion;

  const ListaInvitadoMeteorologicaScreen({
    required this.idEstacion,
    required this.nombreMunicipio,
    required this.nombreEstacion,
  });

  @override
  _ListaInvitadoMeteorologicaScreenState createState() =>
      _ListaInvitadoMeteorologicaScreenState();
}

class _ListaInvitadoMeteorologicaScreenState
    extends State<ListaInvitadoMeteorologicaScreen> {
  List<Map<String, dynamic>> datos = [];
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

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  late EstacionService miModelo4; // Futuro de la lista de personas

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
        datosFiltrados = datos; // Inicialmente, no se filtra nada
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load datos meteorologicos');
    }
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

  Future<void> exportToExcel(List<Map<String, dynamic>> datosList) async {
    try {
      var excel = excel_pkg.Excel.createExcel(); // Crear un nuevo archivo Excel
      var sheet = excel['Sheet1']; // Seleccionar la primera hoja

      // Escribir los encabezados
      sheet.appendRow([
        'Fecha',
        'Temp Max',
        'Temp Min',
        'Precipitación',
        'Temp Ambiente',
        'Dir Viento',
        'Vel Viento',
        'Evaporación'
      ]);

      // Agrega los datos filtrados
      for (var dato in datosList) {
        sheet.appendRow([
          formatDateTime(dato['fechaReg']?.toString()),
          dato['tempMax']?.toString() ?? '',
          dato['tempMin']?.toString() ?? '',
          dato['pcpn']?.toString() ?? '',
          dato['tempAmb']?.toString() ?? '',
          dato['dirViento']?.toString() ?? '',
          dato['velViento']?.toString() ?? '',
          dato['taevap']?.toString() ?? '',
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
        ..setAttribute("download", "DatosMeteorologicos.xlsx")
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

                  SizedBox(height: 10),
                  Container(
                    height: 90,
                    color: Color.fromARGB(
                        91, 4, 18, 43), // Fondo negro con 20% de opacidad
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("images/47.jpg"),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10.0,
                            runSpacing: 5.0,
                            children: [
                              Text("Bienvenido Invitado",
                                  style: GoogleFonts.lexend(
                                      textStyle: TextStyle(
                                    color: Colors.white60,
                                    //fontWeight: FontWeight.bold,
                                  ))),
                              Text('| Municipio de: ${widget.nombreMunicipio}',
                                  style: GoogleFonts.lexend(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                              Text(
                                  '| Estación Meteorológica: ${widget.nombreEstacion}',
                                  style: GoogleFonts.lexend(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
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
                  // Dentro de tu Widget build donde tienes los botones
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
                          backgroundColor: Color(0xFF58D68D), // Color plomo
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Border radius
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GraficaScreen(datos: datosFiltrados),
                            ),
                          );
                        },
                        icon: Icon(Icons.show_chart, color: Colors.white),
                        label: Text(
                          'Gráfica',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFF0B27A), // Color plomo
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Border radius
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: kIsWeb
                              ? Scrollbar(
                                  thumbVisibility:
                                      true, // Mostrar la barra de desplazamiento en la web
                                  controller: _horizontalScrollController,
                                  child: SingleChildScrollView(
                                    controller: _horizontalScrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _verticalScrollController,
                                      child: SingleChildScrollView(
                                        controller: _verticalScrollController,
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          columns: const [
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
                                                'Evaporación',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: datosFiltrados.map((dato) {
                                            int index =
                                                datosFiltrados.indexOf(dato);
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    formatDateTime(
                                                        dato['fechaReg']
                                                            ?.toString()),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['tempMax'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['tempMin'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['pcpn'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['tempAmb'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['dirViento']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['velViento']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['taevap'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _horizontalScrollController,
                                    child: SingleChildScrollView(
                                      controller: _horizontalScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          columns: const [
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
                                                'Evaporación',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: datosFiltrados.map((dato) {
                                            int index =
                                                datosFiltrados.indexOf(dato);
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    formatDateTime(
                                                        dato['fechaReg']
                                                            ?.toString()),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['tempMax'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['tempMin'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['pcpn'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['tempAmb'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['dirViento']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['velViento']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    dato['taevap'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                  const SizedBox(height: 20),
                  Footer(),
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
              fontSize: 11.0, // Tamaño de la fuente
              //fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center, // Centra el texto
        ),
      ),
    );
  }
}
