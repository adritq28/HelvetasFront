import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helvetasfront/model/UsuarioEstacion.dart';
import 'package:helvetasfront/screens/Hidrologia/ListaEstacionHidrologicaScreen.dart';
import 'package:helvetasfront/screens/Meteorologia/ListaEstacionScreen.dart';
import 'package:helvetasfront/services/EstacionHidrologicaService.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:helvetasfront/services/UsuarioService.dart';
import 'package:provider/provider.dart';

class ListaUsuarioEstacionScreen extends StatefulWidget {
  @override
  _ListaUsuarioEstacionScreenState createState() =>
      _ListaUsuarioEstacionScreenState();
}

class _ListaUsuarioEstacionScreenState
    extends State<ListaUsuarioEstacionScreen> {
  final UsuarioService _datosService2 = UsuarioService();
  late Future<List<UsuarioEstacion>> _futureUsuarioEstacion;
  final EstacionService _datosService3 = EstacionService();
  late UsuarioService miModelo4;
  late List<UsuarioEstacion> _usuarioEstacion = [];
  late List<String> _municipios = []; // Lista de municipios
  String? _selectedMunicipio; // Municipio seleccionado

  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<UsuarioService>(context, listen: false);
    _cargarUsuarioEstacion();
  }

  Future<void> _cargarUsuarioEstacion() async {
    try {
      await miModelo4.getUsuario();
      List<UsuarioEstacion> a = miModelo4.lista11;
      setState(() {
        _usuarioEstacion = a;
        _municipios = a.map((e) => e.nombreMunicipio).toSet().toList();
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'images/fondo.jpg', // Cambia esto por la ruta de tu imagen
              fit: BoxFit.cover,
            ),
          ),
          // Contenido de la pantalla
          Padding(
            padding: const EdgeInsets.all(0.0),
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
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 25,
                      ),
                    ),
                    const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 28,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 70,
                  color: Color.fromARGB(
                      91, 4, 18, 43), // Fondo negro con 20% de opacidad
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 15),
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 10.0,
                          runSpacing: 5.0,
                          children: [
                            Text(
                              'OBSERVADORES METEOROLOGICOS E HIDROLOGICOS',
                              style: GoogleFonts.kulimPark(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(
                                      255, 243, 243, 243), // Color del texto
                                  fontSize:
                                      13.0, // Tamaño de la fuente mayor para el título
                                  fontWeight:
                                      FontWeight.bold, // Negrita para el título
                                ),
                              ),
                              textAlign: TextAlign
                                  .left, // Alineación del texto a la izquierda
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'MUNICIPIOS: ',
                  style: GoogleFonts.kulimPark(
                    textStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 239, 239, 240), // Color del texto
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold, // Tamaño de la fuente
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  hint: Text(
                    "Seleccione un Municipio",
                    style: GoogleFonts.convergence(
                      textStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 255, 255, 255), // Color del texto
                        fontSize: 15.0, // Tamaño de la fuente
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  value: _selectedMunicipio,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMunicipio = newValue;
                    });
                  },
                  items:
                      _municipios.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: GoogleFonts.convergence(
                            textStyle: TextStyle(
                              color: Color.fromARGB(
                                  255, 8, 8, 114), // Color del texto
                              fontSize: 15.0, // Tamaño de la fuente
                              //fontWeight: FontWeight.bold,
                            ),
                          )),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: op2(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget op2(BuildContext context) {
    List<UsuarioEstacion> usuariosFiltrados = _selectedMunicipio == null
        ? _usuarioEstacion
        : _usuarioEstacion
            .where((u) => u.nombreMunicipio == _selectedMunicipio)
            .toList();

    return ListView.builder(
      itemCount: (usuariosFiltrados.length / 2).ceil(),
      itemBuilder: (context, index) {
        int firstIndex = index * 2;
        int secondIndex = firstIndex + 1;

        var firstDato = usuariosFiltrados[firstIndex];
        var secondDato = secondIndex < usuariosFiltrados.length
            ? usuariosFiltrados[secondIndex]
            : null;

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
                    Center(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage("images/47.jpg"),
                      ),
                    ),
                    Text(
                      "${firstDato.nombreCompleto}",
                      style: GoogleFonts.krub(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    SizedBox(height: 5),
                    Text("Municipio: ${firstDato.nombreMunicipio}",
                        style: GoogleFonts.fredoka(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 0, 7, 40),
                          fontSize: 15,
                        ))),
                    Text("Estación: ${firstDato.nombreEstacion}",
                        style: GoogleFonts.fredoka(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 0, 7, 40),
                          fontSize: 15,
                        ))),
                    Text("Tipo de Estación: ${firstDato.tipoEstacion}",
                        style: GoogleFonts.fredoka(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 0, 7, 40),
                          fontSize: 15,
                        ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.assignment_add,
                            size: 50,
                          ),
                          onPressed: () {
                            mostrarDialogoContrasena(context, firstDato);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (secondDato != null)
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
                      Center(
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage("images/46.jpg"),
                        ),
                      ),
                      Text("${secondDato.nombreCompleto}",
                          style: GoogleFonts.krub(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))),
                      SizedBox(height: 5),
                      Text("Municipio: ${secondDato.nombreMunicipio}",
                          style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 7, 40),
                            fontSize: 15,
                          ))),
                      Text("Estación: ${secondDato.nombreEstacion}",
                          style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 7, 40),
                            fontSize: 15,
                          ))),
                      Text("Tipo de Estación: ${secondDato.tipoEstacion}",
                          style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 7, 40),
                            fontSize: 15,
                          ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.assignment_add,
                              size: 50,
                            ),
                            onPressed: () {
                              mostrarDialogoContrasena(context, secondDato);
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

  void mostrarDialogoContrasena(BuildContext context, UsuarioEstacion dato) {
    final TextEditingController _passwordController = TextEditingController();
    bool _obscureText = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese Contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Cambiar la visibilidad del texto
                      setState(() {
                        _obscureText = !_obscureText;
                        print('aaaaaaaaaa');
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                  height: 20), // Espacio entre el campo de texto y los botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.red, // Cambia el color del texto a rojo
                        fontSize: 18, // Cambia el tamaño del texto a 18
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.blue, // Cambia el color del texto a azul
                        fontSize: 18, // Cambia el tamaño del texto a 18
                      ),
                    ),
                    onPressed: () async {
                      final password = _passwordController.text;
                      final esValido = await _datosService3.validarContrasena(
                          password, dato.idUsuario);
                      if (esValido) {
                        if (dato.codTipoEstacion) {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider(
                                create: (context) => EstacionService(),
                                child: ListaEstacionScreen(
                                  idUsuario: dato.idUsuario,
                                  nombreMunicipio: dato.nombreMunicipio,
                                  nombreEstacion: dato.nombreEstacion,
                                  tipoEstacion: dato.tipoEstacion,
                                  nombreCompleto: dato.nombreCompleto,
                                  telefono: dato.telefono,
                                  idEstacion: dato.idEstacion,
                                  codTipoEstacion: dato.codTipoEstacion,
                                ),
                              );
                            }),
                          );
                        } else {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider(
                                create: (context) =>
                                    EstacionHidrologicaService(),
                                child: ListaEstacionHidrologicaScreen(
                                  idUsuario: dato.idUsuario,
                                  nombreMunicipio: dato.nombreMunicipio,
                                  nombreEstacion: dato.nombreEstacion,
                                  tipoEstacion: dato.tipoEstacion,
                                  nombreCompleto: dato.nombreCompleto,
                                  telefono: dato.telefono,
                                  idEstacion: dato.idEstacion,
                                  codTipoEstacion: dato.codTipoEstacion,
                                ),
                              );
                            }),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Contraseña incorrecta'),
                              actions: [
                                TextButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cierra el diálogo
                                  },
                                ),
                              ],
                            );
                          },
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
    );
  }
}
