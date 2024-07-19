import 'package:flutter/material.dart';
import 'package:helvetasfront/screens/Administrador/EstacionHidrologica.dart';
import 'package:helvetasfront/screens/Administrador/EstacionMeteorologica.dart';
import 'package:helvetasfront/screens/Administrador/PronosticoScreen.dart';

class AdminScreen extends StatelessWidget {
  final int idUsuario;
  final String nombre;
  final String apeMat;
  final String apePat;
  final String ci;

  const AdminScreen({
    required this.idUsuario,
    required this.nombre,
    required this.apeMat,
    required this.apePat,
    required this.ci,
  });

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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bienvenid@: $nombre $apePat $apeMat',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(208, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Botones grandes en dos filas
                      Wrap(
                        spacing: 20, // Espacio horizontal entre botones
                        runSpacing: 20, // Espacio vertical entre filas
                        children: [
                          Container(
                            width: 200,
                            height: 120, // Define el tamaño del botón
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EstacionMeteorologicaScreen(idUsuario: idUsuario, nombre: nombre, apePat: apePat, apeMat: apeMat, ci: ci),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFD2B4DE),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                Icons
                                    .holiday_village_rounded, // Icono a agregar
                                size: 24, // Tamaño del icono
                                color: Color.fromARGB(
                                    255, 136, 96, 151), // Color del icono
                              ),
                              label: Text(
                                "Estaciones Meteorologicas",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 246, 255),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 120, // Define el tamaño del botón
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EstacionHidrologicaScreen(idUsuario: idUsuario, nombre: nombre, apePat: apePat, apeMat: apeMat, ci: ci),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF1948A),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                Icons.query_stats_outlined, // Icono a agregar
                                size: 24, // Tamaño del icono
                                color: Color.fromARGB(
                                    255, 161, 82, 73), // Color del icono
                              ),
                              label: Text(
                                "Estaciones Hidrologicas",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 246, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 20, // Espacio horizontal entre botones
                        runSpacing: 20, // Espacio vertical entre filas
                        children: [
                          Container(
                            width: 200,
                            height: 120, // Define el tamaño del botón
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PronosticoScreen(idUsuario: idUsuario, nombre: nombre, apePat: apePat, apeMat: apeMat, ci: ci),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF1C40F),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                Icons.satellite_rounded, // Icono a agregar
                                size: 24, // Tamaño del icono
                                color: Color.fromARGB(
                                    255, 144, 128, 63), // Color del icono
                              ),
                              label: Text(
                                "Pronosticos Decenales",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 246, 255),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 120, // Define el tamaño del botón
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ListaUsuarioEstacionScreen(),
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF58D68D), // Color de fondo del botón
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                Icons.calendar_month, // Icono a agregar
                                size: 24, // Tamaño del icono
                                color: Color.fromARGB(
                                    255, 57, 139, 91), // Color del icono
                              ),
                              label: Text(
                                "Fechas de Siembra",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 246,
                                      255), // Color del texto del botón
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 20, // Espacio horizontal entre botones
                        runSpacing: 20, // Espacio vertical entre filas
                        children: [
                          Container(
                            width: 200,
                            height: 120, // Define el tamaño del botón
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ListaUsuarioEstacionScreen(),
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 43, 200, 190),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                Icons.account_circle, // Icono a agregar
                                size: 24, // Tamaño del icono
                                color: Color.fromARGB(
                                    255, 63, 129, 144), // Color del icono
                              ),
                              label: Text(
                                "Usuarios",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 246, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
