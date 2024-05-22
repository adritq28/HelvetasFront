import 'package:flutter/material.dart';
import 'package:helvetasfront/model/UsuarioEstacion.dart';
import 'package:helvetasfront/screens/ListaEstacionScreen.dart';
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
        title: const Text('Lista de Estacion'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: op2(context),
      ),
    );
  }

  Widget op2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          formUsuarioEstacion(),
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('idUsuario')),
                  DataColumn(label: Text('Municipio')),
                  DataColumn(label: Text('Estacion')),
                  DataColumn(label: Text('Tipo de Estacion')),
                  DataColumn(label: Text('Nombre Observador')),
                  DataColumn(label: Text('Celular')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: miModelo4.lista11.map((dato) {
                  return DataRow(cells: [
                    DataCell(Text(dato.idUsuario.toString())),
                    DataCell(Text(dato.nombreMunicipio.toString())),
                    DataCell(Text(dato.nombreEstacion.toString())),
                    DataCell(Text(dato.tipoEstacion.toString())),
                    DataCell(Text(dato.nombreCompleto.toString())),
                    DataCell(Text(dato.telefono.toString())),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              mostrarDialogoContrasena(context, dato);
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void mostrarDialogoContrasena(BuildContext context, UsuarioEstacion dato) {
    final TextEditingController _passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese Contraseña'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Contraseña'),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                final password = _passwordController.text;
                final esValido = await _datosService3.validarContrasena(password, dato.idUsuario);
                if (esValido) {
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
                        ),
                      );
                    }),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contraseña incorrecta')),
                  );
                }
              },
            ),
          ],
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
                );
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
