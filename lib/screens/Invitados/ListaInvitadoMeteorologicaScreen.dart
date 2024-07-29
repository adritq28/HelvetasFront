import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:provider/provider.dart';

class ListaInvitadoMeteorologicaScreen extends StatefulWidget {
  final int idEstacion;
  final String nombreEstacion;
  final String nombreMunicipio;

  ListaInvitadoMeteorologicaScreen({
    required this.idEstacion,
    required this.nombreEstacion,
    required this.nombreMunicipio,
  });

  @override
  _ListaInvitadoMeteorologicaScreenState createState() => _ListaInvitadoMeteorologicaScreenState();
}

class _ListaInvitadoMeteorologicaScreenState extends State<ListaInvitadoMeteorologicaScreen> {
  final EstacionService _datosService2 =
      EstacionService(); // Instancia del servicio de datos
  late Future<List<DatosEstacion>> _futureDatosEstacion;
  final EstacionService _datosService3 = EstacionService();
  late EstacionService miModelo4; // Futuro de la lista de personas
  late List<DatosEstacion> _datosEstacion = [];

  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<EstacionService>(context, listen: false);
    _cargarDatosMeteorologica(); // Carga los datos al inicializar el estado
  }

  Future<void> _cargarDatosMeteorologica() async {
    try {
      await miModelo4.obtenerDatosMunicipio(widget.idEstacion);
      List<DatosEstacion> a = miModelo4.lista11;
      setState(() {
        _datosEstacion = a; // Asigna los datos a la lista
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF164092),
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF164092),
      //   title: Text(
      //     'Registro de datos Estacion ' + widget.tipoEstacion,
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 20,
      //     ),
      //   ),
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Aquí colocas tu formulario

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
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  onPressed: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) {
                    //     return ChangeNotifierProvider(
                    //       create: (context) => EstacionService(),
                    //       child: ExportToExcel(_datosEstacion);
                    //     );
                    //   }),
                    // );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
                height: 20), // Espacio entre el formulario y la tabla de datos
            FutureBuilder<List<DatosEstacion>>(
              future: _datosService3.getListaMetetorologica(widget.idEstacion),
              builder: (context, AsyncSnapshot<List<DatosEstacion>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Este usuario no tiene datos registrados'));
                } else {
                  final datosList = snapshot.data!;
                  return tablaDatos(datosList);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView tablaDatos(List<DatosEstacion> datosList) {
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
                label: Text('ID',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Temp. Max',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Temp. Min',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Temp. Amb',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('PCPN',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('TAEVAP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Dirección del Viento',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Velocidad del Viento',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('ID Estación',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            // Otros campos según tus necesidades
          ],
          rows: datosList.map((datos) {
            return DataRow(cells: [
              DataCell(Text('${datos.idUsuario}')),
              DataCell(Text('${datos.tempMax}')),
              DataCell(Text('${datos.tempMin}')),
              DataCell(Text('${datos.tempAmb}')),
              DataCell(Text('${datos.pcpn}')),
              DataCell(Text('${datos.taevap}')),
              DataCell(Text('${datos.dirViento}')),
              DataCell(Text('${datos.velViento}')),
              DataCell(Text('${datos.idEstacion}')),
              // Otros campos según tus necesidades
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
