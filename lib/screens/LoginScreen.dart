import 'package:flutter/material.dart';
import 'package:helvetasfront/screens/ListaUsuarioEstacionScreen.dart';
import 'package:helvetasfront/screens/MunicipiosScreen.dart';
import 'package:helvetasfront/screens/PromotorScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:helvetasfront/services/PromotorService.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color.fromARGB(255, 206, 222, 255), // Color azul
        //   title: Text(
        //     style: TextStyle(color: Colors.black, ),
        //     'Iniciar Sesión'),

        // ),
        body: Stack(
          children: [
            // Fondo de pantalla con imagen
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/fondo.jpg'), // Ruta de la imagen de fondo
                  fit: BoxFit
                      .cover, // Ajustar la imagen para cubrir todo el contenedor
                ),
              ),
            ),
            Center(
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            style: TextStyle(color: Colors.white, fontSize: 30),
            'Iniciar Sesión'),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Image.asset(
            'images/logo4.png', // Ruta de la imagen
            width: 300, // Ancho de la imagen
          ),
        ),
        Container(
          width: 300, // Define el ancho máximo del botón
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListaUsuarioEstacionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              Icons.badge, // Icono a agregar
              size: 24, // Tamaño del icono
              color: Color(0xFF164092), // Color del icono
            ),
            label: Text(
              "Soy Observador",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164092),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: 300, // Define el ancho máximo del botón
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => PromotorService(),
                    child:
                        PromotorScreen(), // Aquí envuelve la pantalla en el Provider
                  );
                }),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              Icons.assignment_ind, // Icono a agregar
              size: 24, // Tamaño del icono
              color: Color(0xFF164092), // Color del icono
            ),
            label: Text(
              "Soy Promotor",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164092),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: 300, // Define el ancho máximo del botón
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => EstacionService(),
                    child:
                        MunicipiosScreen(), // Aquí envuelve la pantalla en el Provider
                  );
                }),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              Icons.account_circle, // Icono a agregar
              size: 24, // Tamaño del icono
              color: Color(0xFF164092), // Color del icono
            ),
            label: Text(
              "Entrar como invitado",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164092),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // Aquí iría la lógica para navegar a la pantalla de registro
          },
          child: Text(
              style: TextStyle(color: Colors.white),
              '¿No tienes una cuenta? Regístrate aquí'),
        ),
      ],
    );
  }
}
