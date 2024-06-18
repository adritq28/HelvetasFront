import 'dart:html' as html;

import 'package:excel/excel.dart' as excel_pkg;
import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacionHidrologica.dart';
import 'package:helvetasfront/services/EstacionHidrologicaService.dart';
import 'package:provider/provider.dart';

class ListaInvitadoHidrologicaScreen extends StatefulWidget {
  final int idEstacion;
  final String nombreEstacion;
  final String nombreMunicipio;

  ListaInvitadoHidrologicaScreen({
    required this.idEstacion,
    required this.nombreEstacion,
    required this.nombreMunicipio,
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
  final EstacionHidrologicaService _datosService3 =
      EstacionHidrologicaService();
  late EstacionHidrologicaService miModelo4; // Futuro de la lista de personas
  late List<DatosEstacionHidrologica> _datosEstacion = [];

  // @override
  // void initState() {
  //   super.initState();
  //   miModelo4 = Provider.of<EstacionHidrologicaService>(context, listen: false);
  //   _cargarDatosMeteorologica(); // Carga los datos al inicializar el estado
  // }
  @override
  void initState() {
    super.initState();
    _futureDatosEstacion = _cargarDatosMeteorologica(); // Inicializa el Future
  }

  Future<List<DatosEstacionHidrologica>> _cargarDatosMeteorologica() async {
    try {
      final datosService =
          Provider.of<EstacionHidrologicaService>(context, listen: false);
      await datosService.getListaHidrologica(widget.idEstacion);
      return datosService.lista11;
    } catch (e) {
      print('Error al cargar los datos: $e');
      return [];
    }
  }

  // Future<void> exportToExcel(List<DatosEstacionHidrologica> datosList) async {
  //   var excel = excel_pkg.Excel.createExcel();
  //   excel.delete('Sheet1');
  //   excel_pkg.Sheet sheetObject = excel['Estacion Data'];

  //   // Add the headers
  //   List<String> headers = [
  //     'Nombre del Municipio',
  //     'Limnimetro',
  //     'Fecha Reg',
  //     'ID Estación',
  //     'Delete'
  //   ];
  //   sheetObject.appendRow(headers);

  //   // Add data
  //   for (var datos in datosList) {
  //     List<dynamic> row = [
  //       widget.nombreMunicipio,
  //       datos.limnimetro,
  //       datos.fechaReg,
  //       datos.idEstacion,
  //       datos.delete
  //     ];
  //     sheetObject.appendRow(row);
  //   }

  //   // Save the file
  //   final directory = Directory(path.join('/Users/ADRI/Downloads'));
  //   // if (!directory.existsSync()) {
  //   //   await Future.microtask(() {
  //   //     directory.createSync(recursive: true);
  //   //   });
  //   // }
  //   final file = File(path.join(directory.path, 'EstacionData.xlsx'));

  //   // Write to the file
  //   List<int>? bytes = excel.save();
  //   if (bytes != null) {
  //     file.writeAsBytesSync(bytes, flush: true);
  //     print('Exportado a ${file.path}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Datos exportados a Excel en ${file.path}')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error al guardar el archivo Excel')),
  //     );
  //   }
  // }

  Future<void> exportToExcel(List<DatosEstacionHidrologica> datosList) async {
  try {
    var excel = excel_pkg.Excel.createExcel(); // Crear un nuevo archivo Excel
    excel_pkg.Sheet sheetObject = excel['Sheet1']; // Seleccionar la primera hoja

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
    for (var datos in datosList) {
      sheetObject.appendRow([
        widget.nombreMunicipio,
        widget.nombreEstacion,
        datos.limnimetro,
        datos.fechaReg,
        datos.idEstacion,
        datos.delete
      ]);
    }

    // Guardar el archivo Excel en memoria
    var fileBytes = excel.save();
    if (fileBytes == null) {
      throw Exception('No se pudo generar el archivo Excel.');
    }

    // Crear un blob de datos
    final blob = html.Blob([fileBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    // Crear un enlace de descarga y hacer clic en él
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "Datos.xlsx")
      ..click();
    
    // Liberar la URL del blob
    html.Url.revokeObjectUrl(url);

    print('Archivo listo para descargar');
  } catch (e) {
    print('Error al guardar el archivo: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF164092),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
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
                      Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Municipio de " + widget.nombreMunicipio,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          style: TextStyle(color: Colors.white),
                          'DATOS REGISTRADOS')
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            FutureBuilder<List<DatosEstacionHidrologica>>(
              future: _datosService3.getListaHidrologica(widget.idEstacion),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Este usuario no tiene datos registrados'));
                } else {
                  _datosEstacion = snapshot.data!;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.feed, color: Colors.white),
                            label: Text('Exportar Datos',
                                style: TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey, // Color plomo
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8.0), // Border radius
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                            ),
                            onPressed: () async {
                              if (_datosEstacion.isNotEmpty) {
                                await exportToExcel(_datosEstacion);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Datos exportados a Excel')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('No hay datos para exportar')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      tablaDatos(_datosEstacion),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView tablaDatos(List<DatosEstacionHidrologica> datosList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Borde redondeado
          border: Border.all(
              color: Colors.grey), // Borde gris alrededor de la tabla
        ),
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) =>
              Color.fromARGB(255, 178, 197,
                  255)!), // Color de fondo de la fila de encabezado
          dataRowColor: MaterialStateColor.resolveWith((states) =>
              Colors.grey[100]!), // Color de fondo de las filas de datos
          columns: const [
            DataColumn(
                label: Text('Nombre del Municipio',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Limnimetro',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Fecha Reg',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('ID Estación',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            // Otros campos según tus necesidades
          ],
          rows: datosList.map((datos) {
            return DataRow(cells: [
              DataCell(Text('${widget.nombreMunicipio}')),
              DataCell(Text('${datos.limnimetro}')),
              DataCell(Text('${datos.fechaReg}')),
              DataCell(Text('${datos.idEstacion}')),
              DataCell(Text('${datos.delete}')),
              // Otros campos según tus necesidades
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
