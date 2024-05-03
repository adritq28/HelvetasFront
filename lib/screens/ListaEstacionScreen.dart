import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:helvetasfront/screens/EditarEstacionScreen.dart';
import 'package:helvetasfront/screens/GraficaScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaEstacionScreen extends StatefulWidget {
  @override
  _ListaEstacionScreenState createState() => _ListaEstacionScreenState();
}

class _ListaEstacionScreenState extends State<ListaEstacionScreen> {
  final EstacionService _datosService2 =
      EstacionService(); // Instancia del servicio de datos
  late Future<List<DatosEstacion>> _futureDatosEstacion;

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
          formDatosEstacion(),
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Coordenada')),
                  DataColumn(label: Text('dirVelViento')),
                  DataColumn(label: Text('fechaDatos')),
                  DataColumn(label: Text('pcpn')),
                  DataColumn(label: Text('taevap')),
                  DataColumn(label: Text('tempAmb')),
                  DataColumn(label: Text('tempMax')),
                  DataColumn(label: Text('tempMin')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: miModelo4.lista11.map((dato) {
                  // Usamos la lista directamente del modelo
                  return DataRow(cells: [
                    DataCell(Text(dato.id.toString())),
                    DataCell(Text(dato.coordenada)),
                    DataCell(Text(dato.dirVelViento.toString())),
                    DataCell(Text(dato.fechaDatos.toString().split(' ')[0])),
                    DataCell(Text(dato.pcpn.toString())),
                    DataCell(Text(dato.taevap.toString())),
                    DataCell(Text(dato.tempAmb.toString())),
                    DataCell(Text(dato.tempMax.toString())),
                    DataCell(Text(dato.tempMin.toString())),
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
                                    estacionId: dato.id,
                                    coordenada: dato.coordenada,
                                    dirVelViento: dato.dirVelViento,
                                    pcpn: dato.pcpn,
                                    taevap: dato.taevap,
                                    tempAmb: dato.tempAmb,
                                    tempMax: dato.tempMax,
                                    tempMin: dato.tempMin,
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
                                          await _datosService2.eliminarEstacion(dato.id);
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
  late String _coordenada;
  late double _dirVelViento;
  late DateTime _fechaDatos = DateTime.now();
  late double _pcpn;
  late double _taevap;
  late double _tempAmb;
  late double _tempMax;
  late double _tempMin;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _fechaDatos) {
      setState(() {
        _fechaDatos = pickedDate;
      });
    }
  }

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
                  labelText: 'Coordenada 1',
                  hintText: 'Coordenada 1',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _coordenada = value!;
                  },
                ),
              ),
              const SizedBox(width: 10), // Espacio entre los campos
              Expanded(
                child: MyTextField(
                  labelText: 'Dir Vel Viento',
                  hintText: 'Dir Vel Viento',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _dirVelViento = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _fechaDatos == null
                        ? ''
                        : DateFormat('yyyy-MM-dd').format(_fechaDatos!),
                  ),
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    hintText: 'Seleccionar fecha',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    // No necesitas hacer nada aquí para el campo de fecha
                    // El valor de la fecha ya está almacenado en _fechaDatos
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
          const SizedBox(height: 20),
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
                  labelText: 'Temperatura ambiente',
                  hintText: 'Temperatura ambiente',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _tempAmb = double.tryParse(value ?? '0') ?? 0.0;
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                DatosEstacion nuevoDato = DatosEstacion(
                  id: 0,
                  coordenada: _coordenada,
                  dirVelViento: _dirVelViento,
                  fechaDatos: _fechaDatos,
                  pcpn: _pcpn,
                  taevap: _taevap,
                  tempAmb: _tempAmb,
                  tempMax: _tempMax,
                  tempMin: _tempMin,
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GraficaScreen()));
            },
            child: const Text('Ir a la grafica'),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => EditarEstacionScreen()));
          //   },
          //   child: const Text('Editar'),
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
