import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helvetasfront/model/UsuarioEstacion.dart';
import 'package:helvetasfront/screens/Invitados/MunicipiosScreen.dart';
import 'package:helvetasfront/screens/Meteorologia/ListaUsuarioEstacionScreen.dart';
import 'package:helvetasfront/screens/Promotor/PromotorScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:helvetasfront/services/PromotorService.dart';
import 'package:helvetasfront/services/UsuarioService.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UsuarioService _datosService2 = UsuarioService();
  late Future<List<UsuarioEstacion>> _futureUsuarioEstacion;
  final EstacionService _datosService3 = EstacionService();
  late UsuarioService miModelo4;
  late List<UsuarioEstacion> _usuarioEstacion = [];

  @override
  void initState() {
    super.initState();
  }

  void _showPasswordDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Admin Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                String nombreUsuario = usernameController.text;
                String password = passwordController.text;

                // Llama a la función login del servicio
                await Provider.of<UsuarioService>(context, listen: false)
                    .login(nombreUsuario, password, context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 80),
                  InkWell(
                    onTap: () {
                      _showPasswordDialog(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: Colors.white),
                        SizedBox(width: 5), // Espacio entre el icono y el texto
                        Text(
                          'Admin',
                          style: GoogleFonts.gantari(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                ],
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
          'Iniciar Sesión',
          style: GoogleFonts.prozaLibre(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
        ),
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
              style: GoogleFonts.murecho(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164092),
                ),
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
              style: GoogleFonts.murecho(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164092),
                ),
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
              style: GoogleFonts.murecho(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164092),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
