import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Municipio.dart';
import 'package:helvetasfront/screens/Invitados/PronosticoAgrometeorologico.dart';
import 'package:helvetasfront/services/FenologiaService.dart';
import 'package:helvetasfront/services/MunicipioService.dart';
import 'package:provider/provider.dart';

class ZonasScreen extends StatefulWidget {
  final int idMunicipio;
  final String nombreMunicipio;

  ZonasScreen({
    required this.idMunicipio,
    required this.nombreMunicipio,
  });

  @override
  _ZonasScreenState createState() => _ZonasScreenState();
}

class _ZonasScreenState extends State<ZonasScreen> {
  late Future<void> _futureObtenerZonas;
  late MunicipioService miModelo5;
  late List<Municipio> _Municipio = [];

  @override
  void initState() {
    super.initState();
    miModelo5 = Provider.of<MunicipioService>(context, listen: false);
    _cargarMunicipio();
  }

  Future<void> _cargarMunicipio() async {
    print(widget.idMunicipio);
    try {
      await Provider.of<MunicipioService>(context, listen: false)
          .obtenerZonas(widget.idMunicipio);
      miModelo5.printLista();
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
    return Consumer<MunicipioService>(
      builder: (context, miModelo5, _) => SingleChildScrollView(
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
                        'Lista de Zonas - Municipio de ' +
                            widget.nombreMunicipio,
                        style: TextStyle(color: Colors.white),
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
                itemCount: miModelo5.lista11.length,
                itemBuilder: (context, index) {
                  final dato = miModelo5.lista11[index];
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
                        Text(
                          'ID: ${dato.idMunicipio}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Municipio: ${dato.nombreMunicipio}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Nombre Zona: ${dato.nombreZona}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'ID Zona: ${dato.idZona}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Nombre Cultivo: ${dato.nombreCultivo}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'ID Cultivo: ${dato.idCultivo}',
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
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Border radius
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                              ),
                              onPressed: () async {
                                //PronosticoAgrometeorologico(dato.idZona, dato.nombreMunicipio);
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    print(dato.idZona);
                                    return ChangeNotifierProvider(
                                      create: (context) => FenologiaService(),
                                      child: PronosticoAgrometeorologico(
                                        idZona: dato.idZona,
                                        nombreMunicipio: dato.nombreMunicipio,
                                        idCultivo: dato.idCultivo,
                                      ),
                                    );
                                  }),
                                );
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
      ),
    );
  }
}
