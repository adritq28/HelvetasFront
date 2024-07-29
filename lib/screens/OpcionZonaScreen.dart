import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Promotor.dart';
import 'package:helvetasfront/screens/Promotor/FormFechaSiembra.dart';
import 'package:helvetasfront/screens/Promotor/FormPronostico.dart';
import 'package:helvetasfront/services/PromotorService.dart';
import 'package:helvetasfront/services/PronosticoService.dart';
import 'package:provider/provider.dart';

class OpcionZonaScreen extends StatefulWidget {
  final int idUsuario;
  final int idZona;
  final String nombreZona;
  final String nombreMunicipio;
  final String nombreCompleto;
  final String telefono;
  final int idCultivo;
  final String nombreCultivo;
  final String tipo;

  OpcionZonaScreen({
    required this.idUsuario,
    required this.idZona,
    required this.nombreZona,
    required this.nombreMunicipio,
    required this.nombreCompleto,
    required this.telefono,
    required this.idCultivo,
    required this.nombreCultivo,
    required this.tipo,
  });

  @override
  _OpcionZonaScreenState createState() => _OpcionZonaScreenState();
}

class _OpcionZonaScreenState extends State<OpcionZonaScreen> {
  late PromotorService _datosService2;
  late Future<List<Promotor>> _promotorFuture;

  @override
  void initState() {
    super.initState();
    _datosService2 = Provider.of<PromotorService>(context, listen: false);
    _promotorFuture = _cargarPromotor();
  }

  Future<List<Promotor>> _cargarPromotor() async {
    try {
      final datosService2 =
          Provider.of<PromotorService>(context, listen: false);
      await datosService2.obtenerListaZonas(widget.idUsuario);
      final lista = datosService2.lista11;

      // Imprimir el contenido de la lista en la consola
      for (var promotor in lista) {
        print(
            'ID Usuario: ${promotor.idUsuario}, Nombre: ${promotor.nombreCompleto}');
      }

      return lista;
    } catch (e) {
      print('Error al cargar los datos: $e');
      return [];
    }
  }

  void _mostrarModal(Promotor promotor) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ChangeNotifierProvider(
                        create: (context) => PromotorService(),
                        child: FormFechaSiembra(
                          idUsuario: promotor.idUsuario,
                          idZona: promotor.idZona,
                          nombreZona: promotor.nombreZona ?? '',
                          nombreMunicipio: promotor.nombreMunicipio ?? '',
                          nombreCompleto: promotor.nombreCompleto ?? '',
                          telefono: promotor.telefono ?? '',
                          idCultivo: promotor.idCultivo ?? 0,
                          nombreCultivo: promotor.nombreCultivo ?? '',
                          tipo: promotor.tipo ?? '',
                        ),
                      );
                    }),
                  );
                },
                child: Text('Registro de Fecha Siembra'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ChangeNotifierProvider(
                        create: (context) => PronosticoService(),
                        child: FormPronostico(
                          idUsuario: promotor.idUsuario,
                          idZona: promotor.idZona,
                          nombreZona: promotor.nombreZona ?? '',
                          nombreMunicipio: promotor.nombreMunicipio ?? '',
                          nombreCompleto: promotor.nombreCompleto ?? '',
                          telefono: promotor.telefono ?? '',
                        ),
                      );
                    }),
                  );
                },
                child: Text('Registro de Pronóstico Decenal'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF164092),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Text(
                  widget.nombreCompleto,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Municipio de " + widget.nombreMunicipio,
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
                      'REGISTRO DE DATOS',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Promotor>>(
              future: _promotorFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay datos disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var promotor = snapshot.data![index];
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${promotor.nombreCultivo}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text("Zona: ${promotor.nombreZona}"),
                                  Text("Tipo Cultivo: ${promotor.tipo}"),
                                  Text("ID: ${promotor.idZona}"),
                                  Text("IDCULTIVO: ${promotor.idCultivo}"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.assignment_add,
                                          size: 50,
                                        ),
                                        onPressed: () {
                                          _mostrarModal(promotor); // Mostrar el modal con los datos correctos
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
