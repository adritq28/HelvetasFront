import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helvetasfront/model/DatosPronostico.dart';
import 'package:helvetasfront/model/Fenologia.dart';
import 'package:helvetasfront/model/HistFechaSiembra.dart';
import 'package:helvetasfront/services/FenologiaService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PronosticoAgrometeorologico extends StatefulWidget {
  final int idZona;
  final String nombreMunicipio;
  final int idCultivo;

  PronosticoAgrometeorologico({
    required this.idZona,
    required this.nombreMunicipio,
    required this.idCultivo,
  });

  @override
  _PronosticoAgrometeorologicoState createState() =>
      _PronosticoAgrometeorologicoState();
}

class _PronosticoAgrometeorologicoState
    extends State<PronosticoAgrometeorologico> {
  late Future<void> _futureObtenerZonas;
  late FenologiaService miModelo5;
  late Future<Map<String, dynamic>>? _futureUltimaAlerta;

  late Future<List> _futurePronosticoCultivo;
  late Future<List<Map<String, dynamic>>> _futurePcpnFase;

  List<HistFechaSiembra> _fechasSiembra = [];
  HistFechaSiembra? _selectedFechaSiembra;

  @override
  void initState() {
    super.initState();
    miModelo5 = Provider.of<FenologiaService>(context, listen: false);
    _cargarFenologia();
    _fetchFechasSiembra();
  }

  Future<void> _fetchFechasSiembra() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/cultivos/fechas/${widget.idCultivo}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _fechasSiembra =
            data.map((json) => HistFechaSiembra.fromJson(json)).toList();
      });
    } else {
      // Manejar error
    }
  }

  Future<void> _cargarFenologia() async {
    try {
      await Provider.of<FenologiaService>(context, listen: false)
          .obtenerFenologia(widget.idCultivo);
      if (miModelo5.lista11.isNotEmpty) {
        int idCultivo = miModelo5.lista11[0].idCultivo;
        setState(() {
          _futureUltimaAlerta = miModelo5.fetchUltimaAlerta(idCultivo);
          _futurePronosticoCultivo = miModelo5.pronosticoCultivo(idCultivo);
          _futurePcpnFase = miModelo5.fetchPcpnFase(widget.idCultivo);
        });
      } else {
        throw Exception('No se encontró el idCultivo');
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF164092),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Consumer<FenologiaService>(
          builder: (context, miModelo5, _) {
            if (miModelo5.lista11.isEmpty) {
              return Center(
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            //final timelineEvents = generateTimeline(miModelo5.lista11);
            return SingleChildScrollView(
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
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
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
                                    Text(
                                        '| Municipio de: ${widget.nombreMunicipio}',
                                        style: GoogleFonts.lexend(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12))),
                                    Text(
                                        ' | Cultivo de ' +
                                            miModelo5.lista11[0].nombreCultivo,
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'SELECCIONE FECHAS: ',
                    style: GoogleFonts.kulimPark(
                      textStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 239, 239, 240), // Color del texto
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold, // Tamaño de la fuente
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DropdownButton<HistFechaSiembra>(
                    hint: Text('Seleccionar Fecha de Siembra'),
                    value: _selectedFechaSiembra,
                    onChanged: (HistFechaSiembra? nuevaFecha) {
                      setState(() {
                        _selectedFechaSiembra = nuevaFecha;
                        // Aquí puedes actualizar la fecha de siembra en tu UI
                        // y recalcular la fecha acumulada si es necesario
                      });
                    },
                    items: _fechasSiembra.map((HistFechaSiembra fecha) {
                      return DropdownMenuItem<HistFechaSiembra>(
                        value: fecha,
                        child: Text('${fecha.fechaSiembra.toLocal()}'),
                      );
                    }).toList(),
                  ),
                  Container(
                    width: double
                        .infinity, // Asegura que el contenedor ocupe todo el ancho disponible
                    padding:
                        EdgeInsets.all(16.0), // Espaciado alrededor del texto
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra el contenido verticalmente
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centra el contenido horizontalmente
                      children: [
                        Text(
                          'PRONOSTICO AGROMETEOROLOGICO',
                          style: GoogleFonts.reemKufiFun(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          textAlign: TextAlign.center, // Centrar el texto
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 10),
                  if (_futureUltimaAlerta != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey), // Borde opcional
                            borderRadius: BorderRadius.circular(
                                10), // Borde redondeado opcional
                          ),
                          child: FutureBuilder<Map<String, dynamic>>(
                            future: _futureUltimaAlerta,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final alertData = snapshot.data!;
                                // Convertir a Map<String, String>
                                final alertMessages = {
                                  'TempMax': alertData['TempMax']?.toString() ??
                                      'No alert',
                                  'TempMin': alertData['TempMin']?.toString() ??
                                      'No alert',
                                  'Pcpn': alertData['Pcpn']?.toString() ??
                                      'No alert',
                                  //'General':
                                  // alertData['General']?.toString() ?? 'No alert',
                                };

                                return Column(
                                  children: alertMessages.entries.map((entry) {
                                    final alertType = entry.key;
                                    final alertMessage = entry.value;

                                    Color alertColor;
                                    if (alertMessage.contains("ROJA")) {
                                      alertColor = const Color.fromARGB(
                                          255, 255, 139, 131);
                                    } else if (alertMessage
                                        .contains("AMARILLA")) {
                                      alertColor = const Color.fromARGB(
                                          255, 255, 247, 174);
                                    } else if (alertMessage.contains("VERDE")) {
                                      alertColor = const Color.fromARGB(
                                          255, 161, 255, 164);
                                    } else {
                                      alertColor = Colors.white;
                                    }

                                    return Container(
                                      padding: EdgeInsets.all(8.0),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          // Círculo de color

                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: alertColor,
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  8.0), // Espacio entre el círculo y el texto
                                          // Texto de la alerta
                                          Expanded(
                                            child: Text(
                                              '$alertType: $alertMessage',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    'No hay alertas disponibles',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Container(
                    width: double
                        .infinity, // Asegura que el contenedor ocupe todo el ancho disponible
                    padding:
                        EdgeInsets.all(16.0), // Espaciado alrededor del texto
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra el contenido verticalmente
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centra el contenido horizontalmente
                      children: [
                        Text(
                          'DATOS PRONOSTICO DECENAL',
                          style: GoogleFonts.reemKufiFun(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          textAlign: TextAlign.center, // Centrar el texto
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<DatosPronostico>>(
                    future: miModelo5
                        .pronosticoCultivo(miModelo5.lista11[0].idCultivo),
                    builder: (context,
                        AsyncSnapshot<List<DatosPronostico>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                                'Este usuario no tiene datos registrados'));
                      } else {
                        final datosList = snapshot.data!;
                        return Column(
                          children: [
                            //tablaDatos(datosList),
                            listaTarjetasPronostico(datosList),
                            //tablaDatosInvertida2(datosList),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double
                        .infinity, // Asegura que el contenedor ocupe todo el ancho disponible
                    padding:
                        EdgeInsets.all(16.0), // Espaciado alrededor del texto
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra el contenido verticalmente
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centra el contenido horizontalmente
                      children: [
                        Text(
                          'FENOLOGIA DE ' +
                              miModelo5.lista11[0].nombreCultivo.toUpperCase(),
                          style: GoogleFonts.reemKufiFun(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          textAlign: TextAlign.center, // Centrar el texto
                        ),
                      ],
                    ),
                  ),
                  Align(
  alignment: Alignment.center,
  child: Builder(
    builder: (context) {
      final ScrollController scrollController = ScrollController();
      return Scrollbar(
        controller: scrollController,
        thumbVisibility: true, // Muestra la barra de desplazamiento siempre
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          child: Row(
            children: [
              ...miModelo5.lista11.asMap().entries.map((entry) {
                int index = entry.key;
                var dato = entry.value;
                // La primera fase muestra la fecha de siembra sin sumar días
                DateTime fechaAcumulado;
                if (index == 0) {
                  fechaAcumulado = _selectedFechaSiembra?.fechaSiembra ?? dato.fechaSiembra;
                } else {
                  fechaAcumulado = (_selectedFechaSiembra?.fechaSiembra ?? miModelo5.lista11[0].fechaSiembra).add(
                    Duration(days: miModelo5.lista11.sublist(0, index).map((dato) => dato.nroDias).reduce((a, b) => a + b)),
                  );
                }
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  width: 200, // Ajustar el ancho para hacer las tarjetas más angostas
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Image.asset(
                          'images/${dato.imagen}', // Construir la ruta completa usando el nombre de la imagen de la base de datos
                          width: 90,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          '${dato.descripcion}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Nro Dias: ${dato.nroDias}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Fase: ${dato.fase}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${formatearFecha(fechaAcumulado)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              }).toList(),
              // Agrega una tarjeta adicional para la última fecha acumulada
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                width: 200, // Ajustar el ancho para hacer las tarjetas más angostas
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset( 
                        "images/6.jpg",
                        width: 90,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        'Fase Final',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '${formatearFecha((_selectedFechaSiembra?.fechaSiembra ?? miModelo5.lista11[0].fechaSiembra).add(
                        Duration(days: miModelo5.lista11.map((dato) => dato.nroDias).reduce((a, b) => a + b))
                      ))}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
)
,
                  const SizedBox(height: 10),
                  Container(
                    width: double
                        .infinity, // Asegura que el contenedor ocupe todo el ancho disponible
                    padding:
                        EdgeInsets.all(16.0), // Espaciado alrededor del texto
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra el contenido verticalmente
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centra el contenido horizontalmente
                      children: [
                        Text(
                          'DATOS PCPN FASE',
                          style: GoogleFonts.reemKufiFun(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          textAlign: TextAlign.center, // Centrar el texto
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futurePcpnFase,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No hay datos disponibles'));
                      } else {
                        final pcpnFaseList = snapshot.data!;
                        // Extraer datos
                        List<String> fases = pcpnFaseList
                            .map((e) => e['fase']?.toString() ?? '')
                            .toList();
                        List<String> pcpnAcumuladas = pcpnFaseList
                            .map((e) => e['pcpnAcumulada']?.toString() ?? '')
                            .toList();
                        // Crear filas para el DataTable invertido
                        List<DataRow> rows = [];
                        for (int i = 0; i < fases.length; i++) {
                          rows.add(
                            DataRow(
                              cells: [
                                DataCell(Text(fases[i],
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Color blanco para todas las letras
                                    ))),
                                DataCell(Text(pcpnAcumuladas[i],
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Color blanco para todas las letras
                                    ))),
                              ],
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10), // Borde redondeado
                              border: Border.all(
                                  color: Color.fromARGB(255, 245, 205,
                                      156)), // Borde gris alrededor de la tabla
                            ),
                            columns: [
                              DataColumn(
                                  label: Text('Fase',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ))),
                              DataColumn(
                                  label: Text('PCPN Acumulada',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ))),
                            ],
                            rows: rows,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double
                        .infinity, // Asegura que el contenedor ocupe todo el ancho disponible
                    padding:
                        EdgeInsets.all(16.0), // Espaciado alrededor del texto
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra el contenido verticalmente
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centra el contenido horizontalmente
                      children: [
                        Text(
                          'UMBRALES',
                          style: GoogleFonts.reemKufiFun(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          textAlign: TextAlign.center, // Centrar el texto
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: tablaDatosInvertida(miModelo5.lista11),
                  ),
                  const SizedBox(height: 20),
                  Footer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SingleChildScrollView tablaDatosInvertida(List<Fenologia> datosList) {
    // Definir los títulos de las columnas que se convertirán en filas
    final columnHeaders = [
      'Temp. optima',
      'Temp. Letal maxima',
      'Temp. Letal minima',
      'Umbral termico sup',
      'Umbral termico inf',
      'Precipitacion',
    ];

    // Convertir cada columna en una fila
    List<List<String>> filasInvertidas = List.generate(
      columnHeaders.length,
      (index) => [
        columnHeaders[index],
        ...datosList.map((datos) {
          switch (index) {
            case 0:
              return '${datos.tempOpt}';
            case 1:
              return '${datos.tempMax}';
            case 2:
              return '${datos.tempMin}';
            case 3:
              return '${datos.umbSup}';
            case 4:
              return '${datos.umbInf}';
            case 5:
              return '${datos.pcpn}';
            default:
              return '';
          }
        }).toList()
      ],
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Borde redondeado
            border: Border.all(
                color: const Color.fromARGB(
                    255, 255, 185, 185)), // Borde gris alrededor de la tabla
          ),
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Umbrales',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              for (int i = 0; i < datosList.length; i++)
                DataColumn(
                  label: Text(
                    'Fase ${i + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
            rows: filasInvertidas.map((fila) {
              return DataRow(
                cells: fila.map((celda) {
                  return DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      child: Text(
                        celda,
                        style: TextStyle(
                          color: Colors
                              .white, // Color blanco para todas las letras
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView tablaDatosInvertida2(List<DatosPronostico> datosList) {
    final columnHeaders = ['Temp. Max', 'Temp. Min', 'PCPN'];

    // Define a date formatter
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

    List<List<String>> filasInvertidas = List.generate(
      columnHeaders.length,
      (index) =>
          [columnHeaders[index]] +
          datosList.map((datos) {
            switch (index) {
              case 0:
                return '${datos.tempMax}';
              case 1:
                return '${datos.tempMin}';
              case 2:
                return '${datos.pcpn}';
              // case 3:
              //   return dateFormatter.format(datos.fecha); // Format the DateTime object
              default:
                return '';
            }
          }).toList(),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Borde redondeado
            border: Border.all(
                color: Colors.grey), // Borde gris alrededor de la tabla
          ),
          child: DataTable(
            columns: [
              DataColumn(
                label: Text('Datos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
              for (int i = 0; i < datosList.length; i++)
                DataColumn(
                  label: Text(dateFormatter.format(datosList[i].fecha),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
            ],
            rows: filasInvertidas.map((fila) {
              return DataRow(
                cells: fila.map((celda) {
                  return DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      child: Text(
                        celda,
                        style: TextStyle(
                          color: Colors
                              .white, // Color blanco para todas las letras
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView tablaDatos(List<DatosPronostico> datosList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Borde redondeado
          border: Border.all(
              color: Color.fromARGB(
                  255, 156, 245, 219)), // Borde gris alrededor de la tabla
        ),
        child: DataTable(
          // Color de fondo de las filas de datos
          columns: const [
            DataColumn(
                label: Text('Temp. Max',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ))),
            DataColumn(
                label: Text('Temp. Min',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ))),
            DataColumn(
                label: Text('PCPN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ))),
            DataColumn(
                label: Text('FECHA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ))),

            // Otros campos según tus necesidades
          ],
          rows: datosList.map((datos) {
            return DataRow(cells: [
              DataCell(Text('${datos.tempMax}',
                  style: TextStyle(
                    color: Colors.white,
                  ))),
              DataCell(Text('${datos.tempMin}',
                  style: TextStyle(
                    color: Colors.white,
                  ))),
              DataCell(Text('${datos.pcpn}',
                  style: TextStyle(
                    color: Colors.white,
                  ))),
              DataCell(Text('${datos.fecha}',
                  style: TextStyle(
                    color: Colors.white,
                  ))),

              // Otros campos según tus necesidades
            ]);
          }).toList(),
        ),
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

DateTime parseFecha(String fecha) {
  return DateTime.parse(fecha);
}

String formatearFecha(DateTime fecha) {
  final DateFormat formatter = DateFormat('MMM d, y', 'en_US');
  return formatter.format(fecha).toUpperCase();
}

Widget tarjetaPronostico(DatosPronostico datos) {
  // Puedes usar lógica aquí para seleccionar la imagen correcta
  DateTime fechaInicio = datos.fecha;
  DateTime fechaFinal = fechaInicio.add(Duration(days: 10));

  String fechaInicioFormateada = formatearFecha(fechaInicio);
  String fechaFinalFormateada = formatearFecha(fechaFinal);

  String imagen = datos.pcpn > 0 ? 'images/25.png' : 'images/26.png';

  return Card(
    margin: const EdgeInsets.all(8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Color.fromARGB(255, 156, 245, 219)),
    ),
    color: datos.pcpn > 0
        ? Color.fromARGB(119, 128, 253, 255)
        : Color.fromARGB(119, 255, 251, 128),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagen,
            height: 170,
            width: 170,
          ),
          SizedBox(height: 10),
          Text(
            'Fecha: $fechaInicioFormateada - $fechaFinalFormateada',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(
            'Temp. Max: ${datos.tempMax}°C',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            'Temp. Min: ${datos.tempMin}°C',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            'Precipitación: ${datos.pcpn} mm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget listaTarjetasPronostico(List<DatosPronostico> datosList) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: datosList.map((datos) {
        return tarjetaPronostico(datos);
      }).toList(),
    ),
  );
}
