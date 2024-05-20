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
  final UsuarioService _datosService2 =
      UsuarioService(); // Instancia del servicio de datos
  late Future<List<UsuarioEstacion>> _futureUsuarioEstacion;

  late UsuarioService miModelo4; // Futuro de la lista de personas

  late List<UsuarioEstacion> _usuarioEstacion = [];
  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<UsuarioService>(context, listen: false);
    _cargarUsuarioEstacion(); // Carga los datos al inicializar el estado
  }

  Future<void> _cargarUsuarioEstacion() async {
    try {
      //List<DatosEstacion> datos = await miModelo4.getDatosEstacion();
      await miModelo4.getUsuario();
      List<UsuarioEstacion> a = miModelo4.lista11;
      setState(() {
        _usuarioEstacion = a; // Asigna los datos a la lista
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // miModelo = Provider.of<EstacionService>(context);
    // cargarDatos();
    //crear();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Estacion'),
        ),
        body:
            Container(margin: const EdgeInsets.all(10.0), child: op2(context)));
  }

  Widget op2(BuildContext context) {
    //final miModelo = Provider.of<EstacionService>(context);

    //print("aaaa" + miModelo.lista11.length.toString());

    return SingleChildScrollView(
      child: Column(
        children: [
          //const Text('prueba de lista estacion datos'),
          //const Text('Texto 2'),
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
                ],
                rows: miModelo4.lista11.map((dato) {
                  // Usamos la lista directamente del modelo
                  return DataRow(cells: [
                    DataCell(Text(dato.idUsuario.toString())),
                    DataCell(Text(dato.nombreMunicipio.toString())),
                    DataCell(Text(dato.nombreEstacion.toString())),
                    DataCell(Text(dato.tipoEstacion.toString())),
                    DataCell(Text(dato.nombreCompleto.toString())),
                    DataCell(Text(dato.telefono.toString())),

                    // Agrega más celdas según tus necesidades
                  
                  ]);
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Widget> crear(UsuarioEstacion elem) async {
    String h = await _datosService2.saveUsuario(elem);
    print("a");
    //print(h);
    return AlertDialog(
      title: const Text('Título del Alerta'),
      //content: Text(h),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _cargarUsuarioEstacion();
              //_cargarDatos();
            }); // Cierra el diálogo
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

//clave de acceso
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
              const SizedBox(width: 10), // Espacio entre los campos
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
              const SizedBox(width: 10), // Espacio entre los campos
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
              const SizedBox(width: 10), // Espacio entre los campos
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
          

          SizedBox(height: 20),
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
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green), // Color de fondo verde
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white), // Color de las letras en blanco
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Modificar el radio de esquinas a 20
                ),
              ),
            ),
          ),
          ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        // Crear y proporcionar el Provider<EstacionService> aquí
        return ChangeNotifierProvider(
          create: (context) => EstacionService(), // Instancia del modelo
          child: ListaEstacionScreen(),
        );
      }),
    );
  },
  child: const Text('Datos estacion'),
),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => GraficaScreen()));
          //   },
          //   child: const Text('Ir a la grafica'),
          // ),
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
        fillColor: Colors.grey[200], // Color de fondo
        hintText: hintText, // Texto de sugerencia
        hintStyle: const TextStyle(
            color: Colors.grey), // Estilo del texto de sugerencia
        labelText: labelText, // Etiqueta del campo
        labelStyle:
            const TextStyle(color: Colors.blue), // Estilo de la etiqueta
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF065E9F),
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
