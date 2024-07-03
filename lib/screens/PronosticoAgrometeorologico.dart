import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Fenologia.dart';
import 'package:helvetasfront/screens/HorizontalTimeLine.dart';
import 'package:helvetasfront/screens/TimeLineEvent.dart';
import 'package:helvetasfront/services/FenologiaService.dart';
import 'package:provider/provider.dart';

class PronosticoAgrometeorologico extends StatefulWidget {
  final int idZona;
  final String nombreMunicipio;

  PronosticoAgrometeorologico({
    required this.idZona,
    required this.nombreMunicipio,
  });

  @override
  _PronosticoAgrometeorologicoState createState() =>
      _PronosticoAgrometeorologicoState();
}

class _PronosticoAgrometeorologicoState
    extends State<PronosticoAgrometeorologico> {
  late Future<void> _futureObtenerZonas;
  late FenologiaService miModelo5;

  @override
  void initState() {
    super.initState();
    miModelo5 = Provider.of<FenologiaService>(context, listen: false);
    _cargarFenologia();
    fetchAlertas();
  }

  Future<void> _cargarFenologia() async {
    print(widget.idZona);
    try {
      await Provider.of<FenologiaService>(context, listen: false)
          .obtenerFenologia(widget.idZona);
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  Future<void> fetchAlertas() async {
    try {
      // Verificar si lista11 no está vacía
      if (miModelo5.lista11.isEmpty) {
        print('La lista11 está vacía');
        return;
      }

      // Verificar que el índice 0 existe
      if (miModelo5.lista11.length <= 0) {
        print('Índice fuera de rango');
        return;
      }

      // Imprimir el contenido de la lista para depuración
      print('Contenido de lista11: ${miModelo5.lista11}');

      List<Fenologia> datos =
          await Provider.of<FenologiaService>(context, listen: false).alertas(
              miModelo5.lista11[0].idFenologia,
              widget.idZona); // Reemplaza con los valores adecuados

      datos.forEach((dato) {
        print(dato);
      });
    } catch (e) {
      print('Errppppor: $e');
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
            final timelineEvents = generateTimeline(miModelo5.lista11);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
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
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage("images/47.jpg"),
                        ),
                        SizedBox(height: 15),
                        SizedBox(height: 5),
                        Text(
                          "Bienvenido Invitado ",
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Municipio de ' + widget.nombreMunicipio,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Cultivo de ' +
                                  miModelo5.lista11[0].nombreCultivo,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  HorizontalTimeline(events: timelineEvents),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: tablaDatosInvertida(miModelo5.lista11),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: miModelo5.lista11.length,
                    itemBuilder: (context, index) {
                      final dato = miModelo5.lista11[index];
                      int acumuladoDias = 0;
                      late DateTime fechaAcumulado = dato.fechaSiembra;
                      print(dato.fechaSiembra);
                      for (int i = 0; i <= index; i++) {
                        acumuladoDias += miModelo5.lista11[i].nroDias;
                        fechaAcumulado = fechaAcumulado.add(
                          Duration(days: miModelo5.lista11[i].nroDias),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                "images/fenologia.jpg",
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              'ID Fenologia: ${dato.idFenologia}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Nombre Cultivo: ${dato.nombreCultivo}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Nro Dias: ${dato.nroDias}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Nro Acumulado: $acumuladoDias',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Fase: ${dato.fase}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Descripcion: ${dato.descripcion}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Temp max: ${dato.tempMax}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Temp min: ${dato.tempMin}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Pcpn: ${dato.pcpn}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'FechaSiembra: ${dato.fechaSiembra}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Fecha acumulado: ${fechaAcumulado}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
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
      'Temp. Max',
      'Temp. Min',
      'PCPN',
    ];

    // Convertir cada columna en una fila
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
            headingRowColor: MaterialStateColor.resolveWith((states) =>
                Color.fromARGB(255, 178, 197,
                    255)!), // Color de fondo de la fila de encabezado
            dataRowColor: MaterialStateColor.resolveWith((states) =>
                Color.fromARGB(243, 238, 239,
                    255)!), // Co lor de fondo de las filas de datos
            columns: [
              DataColumn(
                label: Text(
                  'Umbrales',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20
                      //color: Colors.white,
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
                      //color: Colors.white,
                    ),
                  ),
                ),
            ],
            rows: filasInvertidas.map((fila) {
              return DataRow(
                cells: fila.asMap().entries.map((entry) {
                  int index = entry.key;
                  String celda = entry.value;
                  Color cellColor = Colors.white;

                  // Asignar un color específico a cada columna
                  switch (index) {
                    case 0:
                      cellColor = Colors.blue[100]!;
                      break;
                    case 1:
                      cellColor = Colors.green[100]!;
                      break;
                    case 2:
                      cellColor = Colors.yellow[100]!;
                      break;
                    case 3:
                      cellColor = Colors.orange[100]!;
                      break;
                  }

                  return DataCell(
                    Container(
                      color: cellColor,
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      child: Text(celda),
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

  List<TimelineEvent> generateTimeline(List<Fenologia> fenologiaList) {
    List<TimelineEvent> timelineEvents = [];
    if (fenologiaList.isEmpty) return timelineEvents;

    DateTime fechaAcumulada = fenologiaList[0].fechaSiembra;
    //String dias;

    for (int i = 0; i < fenologiaList.length; i++) {
      var dato = fenologiaList[i];
      //dias = dato.nroDias.toString();
      // Aquí decides qué imagen mostrar basada en tus datos
      String imagenPath = 'images/fenologia.jpg'; // Ejemplo de ruta de imagen

      timelineEvents.add(TimelineEvent(
          imagen: imagenPath,
          fecha: fechaAcumulada,
          title: 'FASE: ${dato.fase}',
          description: dato.descripcion,
          dias: 'Dias: ${dato.nroDias}'));

      // Solo suma los días después de añadir el evento
      if (i < fenologiaList.length - 1) {
        fechaAcumulada = fechaAcumulada.add(Duration(days: dato.nroDias));
      } else {
        // Para el último elemento, asegurarse de que la fecha acumulada final incluya todos los días
        fechaAcumulada = fechaAcumulada.add(Duration(days: dato.nroDias));
        timelineEvents.add(TimelineEvent(
            imagen: imagenPath,
            fecha: fechaAcumulada,
            title: 'FASE Final',
            description: 'Fecha final',
            dias: ' '));
      }
    }
    return timelineEvents;
  }
}
