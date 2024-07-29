import 'package:flutter/material.dart';
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
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF164092),
        title: Text(
          'ObservadoreEs Meteorologicos e Hidrologicos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: op2(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget op2(BuildContext context) {
    return ListView.builder(
      itemCount: (miModelo4.lista11.length / 2).ceil(),
      itemBuilder: (context, index) {
        int firstIndex = index * 2;
        int secondIndex = firstIndex + 1;

        var firstDato = miModelo4.lista11[firstIndex];
        var secondDato = secondIndex < miModelo4.lista11.length
            ? miModelo4.lista11[secondIndex]
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("Municipio: ${firstDato.nombreMunicipio}"),
                    Text("Estación: ${firstDato.nombreEstacion}"),
                    Text("Tipo de Estación: ${firstDato.tipoEstacion}"),
                    Text("COD tipo estacion: ${firstDato.codTipoEstacion}"),
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
                      Text(
                        "${secondDato.nombreCompleto}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text("Municipio: ${secondDato.nombreMunicipio}"),
                      Text("Estación: ${secondDato.nombreEstacion}"),
                      Text("Tipo de Estación: ${secondDato.tipoEstacion}"),
                      Text("COD Estación: ${secondDato.codTipoEstacion}"),
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
                        }
                        else{
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider(
                                create: (context) => EstacionHidrologicaService(),
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

  Future<Widget> crear(UsuarioEstacion elem) async {
    String h = await _datosService2.saveUsuario(elem);
    print("a");
    return AlertDialog(
      title: const Text('Título del Alerta'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _cargarUsuarioEstacion();
            });
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  late int _idUsuario;
  late String _nombreMunicipio;
  late String _nombreEstacion;
  late String _tipoEstacion;
  late String _nombreCompleto;
  late String _telefono;
  late int _idEstacion;
  late bool _codTipoEstacion;

  Widget formUsuarioEstacion() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  labelText: 'Municipio',
                  hintText: 'Municipio',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _nombreMunicipio = value!;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MyTextField(
                  labelText: 'Estacion',
                  hintText: 'Estacion',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _nombreEstacion = value!;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: MyTextField(
                  labelText: 'Tipo estacion',
                  hintText: 'Tipo estacion',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _tipoEstacion = value!;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MyTextField(
                  labelText: 'Nombre',
                  hintText: 'Nombre',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _nombreCompleto = value!;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                UsuarioEstacion nuevoDato = UsuarioEstacion(
                    idUsuario: _idUsuario,
                    nombreMunicipio: _nombreMunicipio,
                    nombreEstacion: _nombreEstacion,
                    tipoEstacion: _tipoEstacion,
                    nombreCompleto: _nombreCompleto,
                    telefono: _telefono,
                    idEstacion: _idEstacion,
                    codTipoEstacion: _codTipoEstacion);
                print(nuevoDato.toStringUsuarioEstacion());

                crear(nuevoDato).then((alertDialog) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertDialog;
                    },
                  );
                });
              }
            },
            child: const Text('Guardar datos'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => EstacionService(),
                  );
                }),
              );
            },
            child: const Text('Datos estacion'),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final void Function(String?)? onSaved;

  const MyTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 225, 255, 246), // Color de fondo
        hintText: hintText, // Texto de sugerencia
        hintStyle: const TextStyle(
            color: Color.fromARGB(
                255, 180, 255, 231)), // Estilo del texto de sugerencia
        labelText: labelText, // Etiqueta del campo
        labelStyle:
            const TextStyle(color: Colors.blue), // Estilo de la etiqueta
        prefixIcon: Icon(
          prefixIcon,
          color: Color.fromARGB(255, 97, 173, 255),
        ), // Icono al inicio del campo
        border: OutlineInputBorder(
          // Borde del campo
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // Sin bordes visibles
        ),
        enabledBorder: OutlineInputBorder(
          // Borde cuando el campo está habilitado pero no seleccionado
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.blue, width: 2), // Bordes azules
        ),
        focusedBorder: OutlineInputBorder(
          // Borde cuando el campo está seleccionado
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.blue, width: 2), // Bordes azules
        ),
      ),
      // onSaved: (value) {
      //   _labelText = value!;
      // },
      onSaved: onSaved,
    );
  }
}
