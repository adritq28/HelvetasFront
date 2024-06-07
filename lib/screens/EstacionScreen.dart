import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Estacion.dart';
import 'package:helvetasfront/screens/ListaInvitadoHidrologicaScreen.dart';
import 'package:helvetasfront/screens/ListaInvitadoMeteorologicaScreen.dart';
import 'package:helvetasfront/services/EstacionHidrologicaService.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:provider/provider.dart';

class EstacionScreen extends StatefulWidget {
  final int idMunicipio;
  final String nombreMunicipio;

  //final double limnimetro;

  EstacionScreen({
    required this.idMunicipio,
    required this.nombreMunicipio,
  });

  @override
  _EstacionScreenState createState() => _EstacionScreenState();
}

class _EstacionScreenState extends State<EstacionScreen> {
  final EstacionService _datosService2 = EstacionService();
  late Future<List<Estacion>> _futureUsuarioEstacion;
  final EstacionService _datosService3 = EstacionService();
  late EstacionService miModelo5;

  late List<Estacion> _estacion = [];

  @override
  void initState() {
    super.initState();
    miModelo5 = Provider.of<EstacionService>(context, listen: false);
    _cargarEstacion();
  }

  Future<void> _cargarEstacion() async {
    try {
      await miModelo5.getEstacion(widget.idMunicipio);
      List<Estacion> a = miModelo5.lista115;
      setState(() {
        _estacion = a;
      });
      //print('Datos de las estaciones:  '+ widget.idMunicipio.toString());
      // for (var _estacion in a) {
      //   print('Nombre de la estación: ${_estacion.nombreEstacion}');
      //   // Imprime otros datos según sea necesario
      // }
      //print(_estacion);
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
        child: op2(context),
      ),
    );
  }

  Widget op2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: 15),
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
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      style: TextStyle(color: Colors.white),
                      'Lista de Estaciones - Municipio de ' +
                          widget.nombreMunicipio,
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: miModelo5.lista115.length,
              itemBuilder: (context, index) {
                final dato = miModelo5.lista115[index];
                //final dato = snapshot.data!;
                //print(' ' + dato.nombreEstacion);
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      Text(
                        'ID: ${widget.idMunicipio}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Estacion: ${dato.nombreEstacion}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tipo de Estacion: ${dato.tipoEstacion}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'COD Tipo de Estacion: ${dato.codTipoEstacion}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'COD Tipo de Estacion: ${dato.id}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.visibility_rounded,
                                color: Colors.white),
                            label: Text('Ver Datos',
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
                              //print(dato.codTipoEstacion);
                              if (dato.codTipoEstacion) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ChangeNotifierProvider(
                                      create: (context) => EstacionService(),
                                      child: ListaInvitadoMeteorologicaScreen(
                                        idEstacion: dato.id,
                                        nombreEstacion: dato.nombreEstacion,
                                        nombreMunicipio: widget.nombreMunicipio,
                                      ),
                                    );
                                  }),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ChangeNotifierProvider(
                                      create: (context) => EstacionHidrologicaService(),
                                      child: ListaInvitadoHidrologicaScreen(
                                        idEstacion: dato.id,
                                        nombreEstacion: dato.nombreEstacion,
                                        nombreMunicipio: widget.nombreMunicipio,
                                      ),
                                    );
                                  }),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
