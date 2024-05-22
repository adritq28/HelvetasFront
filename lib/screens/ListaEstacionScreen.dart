import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:provider/provider.dart';

class ListaEstacionScreen extends StatefulWidget {
  final int idUsuario;
  final String nombreMunicipio;
  final String nombreEstacion;
  final String tipoEstacion;
  final String nombreCompleto;
  final String telefono;
  final int idEstacion;

  ListaEstacionScreen({
    required this.idUsuario,
    required this.nombreMunicipio,
    required this.nombreEstacion,
    required this.tipoEstacion,
    required this.nombreCompleto,
    required this.telefono,
    required this.idEstacion,
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
      await miModelo4.obtenerDatosEstacion(widget.idUsuario);
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
      body: Column(
        children: [
          // Aquí colocas tu formulario
          formDatosEstacion(),
          SizedBox(
              height: 20), // Espacio entre el formulario y la tabla de datos
          Expanded(
            child: FutureBuilder<List<DatosEstacion>>(
              future: _datosService3.obtenerDatosEstacion(widget.idUsuario),
              builder: (context, AsyncSnapshot<List<DatosEstacion>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Este usuario no tiene datos registrados'));
                } else {
                  final datosList = snapshot.data!;
                  return tablaDatos(datosList);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView tablaDatos(List<DatosEstacion> datosList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Nombre del Municipio')),
          DataColumn(label: Text('Temp. Max')),
          DataColumn(label: Text('Temp. Min')),
          DataColumn(label: Text('Temp. Amb')),
          DataColumn(label: Text('PCPN')),
          DataColumn(label: Text('TAEVAP')),
          DataColumn(label: Text('Dirección del Viento')),
          DataColumn(label: Text('Velocidad del Viento')),
          DataColumn(label: Text('ID Estación')),
          // Otros campos según tus necesidades
        ],
        rows: datosList.map((datos) {
          return DataRow(cells: [
            DataCell(Text('${datos.idUsuario}')),
            DataCell(Text('${widget.nombreMunicipio}')),
            DataCell(Text('${datos.tempMax}')),
            DataCell(Text('${datos.tempMin}')),
            DataCell(Text('${datos.tempAmb}')),
            DataCell(Text('${datos.pcpn}')),
            DataCell(Text('${datos.taevap}')),
            DataCell(Text('${datos.dirViento}')),
            DataCell(Text('${datos.velViento}')),
            DataCell(Text('${datos.idEstacion}')),
            // Otros campos según tus necesidades
          ]);
        }).toList(),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Temperatura máxima',
                        hintText: 'Temperatura máxima',
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                        labelStyle: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        hintStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(
                          // Define el borde de la caja
                          borderRadius: BorderRadius.circular(
                              10.0), // Ajusta el radio para que sea cuadrado
                        ),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      textAlign:
                          TextAlign.center, // Centra el texto dentro del campo
                      style: TextStyle(
                          fontSize: 24.0), // Ajusta el tamaño del texto
                      onSaved: (value) {
                        _tempMax = double.tryParse(value ?? '0') ?? 0.0;
                      },
                    ),
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
                const SizedBox(width: 10),
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
                //const SizedBox(width: 10), // Espacio entre los campos
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
                const SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  DatosEstacion nuevoDato = DatosEstacion(
                    //id: 0,
                    idUsuario: widget.idUsuario,
                    nombreMunicipio: widget.nombreMunicipio,
                    nombreEstacion: widget.nombreEstacion,
                    tipoEstacion: widget.tipoEstacion,
                    nombreCompleto: widget.nombreCompleto,
                    telefono: widget.telefono,
                    tempMax: _tempMax,
                    tempMin: _tempMin,
                    tempAmb: _tempAmb,
                    pcpn: _pcpn,
                    taevap: _taevap,
                    dirViento: _dirViento,
                    velViento: _velViento,
                    idEstacion: widget.idEstacion,
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
          ],
        ),
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
