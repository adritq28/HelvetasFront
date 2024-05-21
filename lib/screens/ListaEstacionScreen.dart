import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:helvetasfront/screens/EditarEstacionScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:provider/provider.dart';

class ListaEstacionScreen extends StatefulWidget {
  final int idUsuario;

  ListaEstacionScreen({
    required this.idUsuario,
  });

  //ListaEstacionScreen ({required this.idUsuario});

  @override
  _ListaEstacionScreenState createState() => _ListaEstacionScreenState();
}

class _ListaEstacionScreenState extends State<ListaEstacionScreen> {
  final EstacionService _datosService2 =
      EstacionService(); // Instancia del servicio de datos
  late Future<List<DatosEstacion>> _futureDatosEstacion;

  final EstacionService _datosService3 = EstacionService();

  late EstacionService miModelo4; // Futuro de la lista de personas

  late List<DatosEstacion> _datosEstacion = [];
  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<EstacionService>(context, listen: false);
    _cargarDatosEstacion(); // Carga los datos al inicializar el estado
  }

  Future<void> _cargarDatosEstacion() async {
    try {
      //List<DatosEstacion> datos = await miModelo4.getDatosEstacion();
      await miModelo4.getDatosEstacion();
      List<DatosEstacion> a = miModelo4.lista11;
      setState(() {
        _datosEstacion = a; // Asigna los datos a la lista
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Estación'),
      ),
      body: FutureBuilder<DatosEstacion?>(
        future: _datosService3.obtenerDatosEstacion(widget.idUsuario),
        builder: (context, AsyncSnapshot<DatosEstacion?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Este usuario no tiene datos registrados'));
          } else {
            final datos = snapshot.data!;
            // Aquí puedes utilizar los datos obtenidos en snapshot.data
            // Por ejemplo, puedes mostrarlos en un formulario de edición
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${datos.idUsuario}'),
                  Text('Nombre del Municipio: ${datos.nombreMunicipio}'),
                  Text('Temp. Max: ${datos.tempMax}'),
                  Text('Temp. Min: ${datos.tempMin}'),
                  Text('Temp. Amb: ${datos.tempAmb}'),
                  Text('PCPN: ${datos.pcpn}'),
                  Text('TAEVAP: ${datos.taevap}'),
                  Text('Dirección del Viento: ${datos.dirViento}'),
                  Text('Velocidad del Viento: ${datos.velViento}'),
                  Text('ID Estación: ${datos.idEstacion}'),
                  // Otros campos según tus necesidades
                ],
              ),
            );
          }
        },
      ),
    );
  }

  

  Widget op2(BuildContext context) {
    //final miModelo = Provider.of<EstacionService>(context);

    //print("aaaa" + miModelo.lista11.length.toString());

    return SingleChildScrollView(
      child: Column(
        children: [
          //const Text('prueba de lista estacion datos'),
          //const Text('Texto 2'),
          //formDatosEstacion(),
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('nombreMunicipio')),
                  DataColumn(label: Text('tempMax')),
                  DataColumn(label: Text('tempMin')),
                  DataColumn(label: Text('tempAmb')),
                  DataColumn(label: Text('pcpn')),
                  DataColumn(label: Text('taevap')),
                  DataColumn(label: Text('dirViento')),
                  DataColumn(label: Text('velViento')),
                  DataColumn(label: Text('idEstacion')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: miModelo4.lista11.map((dato) {
                  // Usamos la lista directamente del modelo
                  return DataRow(cells: [
                    DataCell(Text(dato.idUsuario.toString())),
                    DataCell(Text(dato.nombreMunicipio.toString())),
                    DataCell(Text(dato.tempMax.toString())),
                    DataCell(Text(dato.tempMin.toString())),
                    DataCell(Text(dato.tempAmb.toString())),
                    DataCell(Text(dato.pcpn.toString())),
                    DataCell(Text(dato.taevap.toString())),
                    DataCell(Text(dato.dirViento)),
                    DataCell(Text(dato.velViento.toString())),
                    DataCell(Text(dato.idEstacion.toString())),

                    // Agrega más celdas según tus necesidades
                    DataCell(
                      Row(
                        children: [
                          //editar
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Navegar a la pantalla de edición y pasar el ID de la estación como argumento
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarEstacionScreen(
                                    estacionId: dato.idEstacion,
                                    idUsuario: dato.idUsuario,
                                    nombreMunicipio: dato.nombreMunicipio,
                                    tempMax: dato.tempMax,
                                    tempMin: dato.tempMin,
                                    tempAmb: dato.tempAmb,
                                    pcpn: dato.pcpn,
                                    taevap: dato.taevap,
                                    dirViento: dato.dirViento,
                                    velViento: dato.velViento,
                                    idEstacion: dato.idEstacion,
                                  ),
                                ),
                              );
                            },
                          ),
                          //eliminar
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Eliminar estación"),
                                    content: Text(
                                        "¿Estás seguro de que quieres eliminar esta estación?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Cancelar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Eliminar"),
                                        onPressed: () async {
                                          await _datosService2
                                              .eliminarEstacion(dato.idUsuario);
                                          Navigator.of(context).pop();
                                          _cargarDatosEstacion();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Widget> crear(DatosEstacion elem) async {
    String h = await _datosService2.saveDatosEstacion(elem);
    print("a");
    print(h);
    return AlertDialog(
      title: const Text('Título del Alerta'),
      content: Text(h),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _cargarDatosEstacion();
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
  late double _tempMax;
  late double _tempMin;
  late double _tempAmb;
  late double _pcpn;
  late double _taevap;
  late String _dirViento;
  late double _velViento;
  late int _idEstacion;

//clave de acceso
  Widget formDatosEstacion() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  labelText: 'Temperatura maxima',
                  hintText: 'Temperatura maxima',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _tempMax = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
              ),
              const SizedBox(width: 10), // Espacio entre los campos
              Expanded(
                child: MyTextField(
                  labelText: 'Temperatura minima',
                  hintText: 'Temperatura minima',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _tempMin = double.tryParse(value ?? '0') ?? 0.0;
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
                  labelText: 'Temperatura ambiente',
                  hintText: 'Temperatura ambiente',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _tempAmb = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
              ),
              const SizedBox(width: 10), // Espacio entre los campos
              Expanded(
                child: MyTextField(
                  labelText: 'Precipitacion',
                  hintText: 'Precipitacion',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _pcpn = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  labelText: 'Tasa de evaporacion',
                  hintText: 'Tasa de evaporacion',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _taevap = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
              ),
              const SizedBox(width: 10), // Espacio entre los campos
              Expanded(
                child: MyTextField(
                  labelText: 'Dir Viento',
                  hintText: 'Dir Viento',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _dirViento = value!;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  labelText: 'Vel Viento',
                  hintText: 'Vel Viento',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _velViento = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
              ),
              Expanded(
                child: MyTextField(
                  labelText: 'Vel Viento',
                  hintText: 'Vel Viento',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _idEstacion = int.tryParse(value ?? '0') ?? 0;
                    ;
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                DatosEstacion nuevoDato = DatosEstacion(
                  //id: 0,
                  idUsuario: _idUsuario,
                  nombreMunicipio: _nombreMunicipio,
                  nombreEstacion: _nombreEstacion,
                  tipoEstacion: _tipoEstacion,
                  nombreCompleto: _nombreCompleto,
                  telefono: _telefono,
                  tempMax: _tempMax,
                  tempMin: _tempMin,
                  tempAmb: _tempAmb,
                  pcpn: _pcpn,
                  taevap: _taevap,
                  dirViento: _dirViento,
                  velViento: _velViento,
                  idEstacion: _idEstacion,
                );
                print(nuevoDato.toStringDatosEstacion());

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
