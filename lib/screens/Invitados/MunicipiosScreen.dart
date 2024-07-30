import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helvetasfront/model/Municipio.dart';
import 'package:helvetasfront/screens/Invitados/ListaEstacionScreen.dart';
import 'package:helvetasfront/screens/Invitados/ZonasScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:helvetasfront/services/MunicipioService.dart';
import 'package:provider/provider.dart';

class MunicipiosScreen extends StatefulWidget {
  @override
  _MunicipiosScreenState createState() => _MunicipiosScreenState();
}

class _MunicipiosScreenState extends State<MunicipiosScreen> {
  final EstacionService _datosService2 = EstacionService();
  late Future<List<Municipio>> _futureUsuarioEstacion;
  final EstacionService _datosService3 = EstacionService();
  late EstacionService miModelo4;

  late List<Municipio> _usuarioEstacion = [];

  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<EstacionService>(context, listen: false);
    _cargarMunicipio();
  }

  Future<void> _cargarMunicipio() async {
    try {
      await miModelo4.getMunicipio();
      List<Municipio> a = miModelo4.lista114;
      setState(() {
        _usuarioEstacion = a;
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  void _mostrarModal(int idMunicipio, String nombreMunicipio) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(), // Cierra el modal al hacer clic fuera de él
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Para evitar que los clics en el contenido cierren el modal
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(226, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.8, // Ajuste de ancho
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Opciones',
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 9, 64, 142),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar el modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ChangeNotifierProvider(
                              create: (context) => EstacionService(),
                              child: EstacionScreen(
                                idMunicipio: idMunicipio,
                                nombreMunicipio: nombreMunicipio,
                              ),
                            );
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Color de fondo plomo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // Ajuste de tamaño
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Colors.white), // Icono
                          SizedBox(width: 10), // Espacio entre icono y texto
                          Flexible(
                            child: Text(
                              'Estaciones Hidrometeorologicas',
                              style: GoogleFonts.lexend(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar el modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ChangeNotifierProvider(
                              create: (context) => MunicipioService(),
                              child: ZonasScreen(
                                idMunicipio: idMunicipio,
                                nombreMunicipio: nombreMunicipio,
                              ),
                            );
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Color de fondo verde
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // Ajuste de tamaño
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.white), // Icono
                          SizedBox(width: 10), // Espacio entre icono y texto
                          Flexible(
                            child: Text(
                              'Pronostico Agrometeorologico',
                              style: GoogleFonts.lexend(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
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
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("images/47.jpg"),
                ),
                SizedBox(height: 15),
                SizedBox(height: 5),
                Text("Bienvenido Invitado ",
                    style: GoogleFonts.lexend(
                        textStyle: TextStyle(
                      color: Colors.white60,
                      //fontWeight: FontWeight.bold,
                    ))),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      //style: TextStyle(color: Colors.white),
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                      'Lista de Municipios',
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
              itemCount: miModelo4.lista114.length,
              itemBuilder: (context, index) {
                final dato = miModelo4.lista114[index];
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
                        'ID: ${dato.idMunicipio}',
                        style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Municipio: ${dato.nombreMunicipio}',
                        style: GoogleFonts.numans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.visibility_rounded,
                                color: Colors.white),
                            label: Text(
                              'Ver Datos',
                              style: GoogleFonts.lexend(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                            ),
                            onPressed: () async {
                              _mostrarModal(
                                  dato.idMunicipio, dato.nombreMunicipio);
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
