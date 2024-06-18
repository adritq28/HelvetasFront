import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:helvetasfront/screens/GraficaScreen.dart';
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
  final bool codTipoEstacion;

  ListaEstacionScreen({
    required this.idUsuario,
    required this.nombreMunicipio,
    required this.nombreEstacion,
    required this.tipoEstacion,
    required this.nombreCompleto,
    required this.telefono,
    required this.idEstacion,
    required this.codTipoEstacion,
  });

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

  List<double> tempMaxList = [];
  List<DateTime> fechaRegList = [];

  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<EstacionService>(context, listen: false);
    _cargarDatosEstacion(); // Carga los datos al inicializar el estado
  }

  Future<void> _cargarDatosEstacion() async {
    try {
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
      backgroundColor: Color(0xFF164092),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Aquí colocas tu formulario

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
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("images/47.jpg"),
                  ),
                  SizedBox(height: 15),
                  Text(
                    widget.nombreCompleto,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Observador de Estación " + widget.tipoEstacion,
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          style: TextStyle(color: Colors.white),
                          'REGISTRO DE DATOS')
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            formDatosEstacion(),
            SizedBox(
                height: 20), // Espacio entre el formulario y la tabla de datos
            FutureBuilder<List<DatosEstacion>>(
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

                  return tablaDatos(datosList, tempMaxList, fechaRegList);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView tablaDatos(List<DatosEstacion> datosList,
      List<double> tempMaxList, List<DateTime> fechaRegList) {
    //_fechaReg = DateTime.now();
    //String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(_fechaReg.toUtc().add(Duration(hours: 4)));
    datosList.forEach((datos) {
      tempMaxList.add(datos.tempMax);
      fechaRegList.add(datos.fechaReg);
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Borde redondeado
          border: Border.all(
              color: Colors.grey), // Borde gris alrededor de la tabla
        ),
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) =>
              Color.fromARGB(255, 178, 197,
                  255)!), // Color de fondo de la fila de encabezado
          dataRowColor: MaterialStateColor.resolveWith((states) =>
              Colors.grey[100]!), // Color de fondo de las filas de datos
          columns: const [
            DataColumn(
                label: Text('ID',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Nombre del Municipio',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Temp. Max',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Temp. Min',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Temp. Amb',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('PCPN',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('TAEVAP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Dirección del Viento',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Velocidad del Viento',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Fecha Reg',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('ID Estación',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('COD estacion',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
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
              DataCell(Text('${datos.fechaReg}')),
              DataCell(Text('${datos.idEstacion}')),
              DataCell(Text('${datos.codTipoEstacion}')),
              // Otros campos según tus necesidades
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Future<Widget> crear(DatosEstacion elem) async {
    //_fechaReg = DateTime.now();
    //String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(_fechaReg.toUtc().add(Duration(hours: 4)));
    String h = await _datosService2.saveDatosEstacion(elem);
    return AlertDialog(
      title: const Text('Título del Alerta'),
      content: Text(h),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _cargarDatosEstacion();
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
  late DateTime fechaReg = DateTime.now();

  Widget formDatosEstacion() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: MediaQuery.of(context).size.height/1.5,
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 20,
            left: 15,
            right: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Temp. Max',
                              hintText: 'Temp. Max',
                              prefixIcon: Icon(
                                Icons.thermostat,
                                color: Color(0xFF164092),
                              ), // Color del icono
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              hintStyle: TextStyle(fontSize: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF164092),
                                ), // Color del borde
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0),
                            onSaved: (value) {  
                              _tempMax = double.tryParse(value ?? '0') ?? 0.0;
                            },
                          ),
                        ),
                      ),

                      //const SizedBox(width: 5), // Espacio entre los campos
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Temp. Min',
                              hintText: 'Temp. Min',
                              prefixIcon: Icon(
                                Icons.thermostat,
                                color: Color(0xFF164092),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              hintStyle: TextStyle(fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF164092),
                                  )),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0),
                            onSaved: (value) {
                              _tempMin = double.tryParse(value ?? '0') ?? 0.0;
                            },
                          ),
                        ),
                      ),
                      //const SizedBox(width: 5),
                    ],
                  ),
                  //const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Precipitacion',
                              hintText: 'Precipitacion',
                              prefixIcon: Icon(
                                Icons.water,
                                color: Color(0xFF164092),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              hintStyle: TextStyle(fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF164092),
                                  )),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0),
                            onSaved: (value) {
                              _pcpn = double.tryParse(value ?? '0') ?? 0.0;
                            },
                          ),
                        ),
                      ),
                      //const SizedBox(width: 5), // Espacio entre los campos
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Evaporacion',
                              hintText: 'Evaporacion',
                              prefixIcon: Icon(
                                Icons.water_damage,
                                color: Color(0xFF164092),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              hintStyle: TextStyle(fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF164092),
                                  )),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0),
                            onSaved: (value) {
                              _taevap = double.tryParse(value ?? '0') ?? 0.0;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Dir. Viento',
                              hintText: 'Dir. Viento',
                              prefixIcon: Icon(
                                Icons.air,
                                color: Color(0xFF164092),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              hintStyle: TextStyle(fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF164092),
                                  )),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0),
                            onSaved: (value) {
                              _dirViento = value!;
                            },
                          ),
                        ),
                      ),
                      //const SizedBox(width: 5), // Espacio entre los campos
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Vel. Viento',
                              hintText: 'Vel. Viento',
                              prefixIcon: Icon(
                                Icons.speed,
                                color: Color(0xFF164092),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              hintStyle: TextStyle(fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF164092),
                                  )),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0),
                            onSaved: (value) {
                              _velViento = double.tryParse(value ?? '0') ?? 0.0;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  //const SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Temp. Amb',
                          hintText: 'Temp. Amb',
                          prefixIcon: Icon(
                            Icons.thermostat,
                            color: Color(0xFF164092),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          labelStyle: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          hintStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xFF164092),
                              )),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24.0),
                        onSaved: (value) {
                          _tempAmb = double.tryParse(value ?? '0') ?? 0.0;
                        },
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Alineación de los botones
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return GraficaScreen(
                                  tempMaxList: tempMaxList,
                                  fechaRegList: fechaRegList,
                                );
                              }),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    255, 125, 130, 125), // Color de fondo verde
                                borderRadius: BorderRadius.circular(
                                    10), // Radio de esquinas de 10
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Para que el contenedor solo ocupe el espacio del contenido
                                children: [
                                  Icon(Icons.line_axis,
                                      color: Colors.white), // Icono de guardar
                                  SizedBox(
                                      width:
                                          8.0), // Espacio entre el icono y el texto
                                  Text('Grafica',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color:
                                              Colors.white)), // Texto del botón
                                ],
                              ),
                              //SizedBox(height: 20),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              DatosEstacion nuevoDato = DatosEstacion(
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
                                  fechaReg: fechaReg..toUtc().subtract(Duration(hours: 8)),
                                  codTipoEstacion: widget.codTipoEstacion);
                              crear(nuevoDato).then((alertDialog) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alertDialog;
                                  },
                                );
                              });
                            }
                            SizedBox(height: 20);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.green, // Color de fondo verde
                              borderRadius: BorderRadius.circular(
                                  10), // Radio de esquinas de 10
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Para que el contenedor solo ocupe el espacio del contenido
                              children: [
                                Icon(Icons.save,
                                    color: Colors.white), // Icono de guardar
                                SizedBox(
                                    width:
                                        8.0), // Espacio entre el icono y el texto
                                Text('Guardar',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color:
                                            Colors.white)), // Texto del botón
                              ],
                            ),
                            //SizedBox(height: 20),
                          ),
                        ),
                      ])
                ],
              ),
            ),
          ),
        ));
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
        prefixIcon: Icon(prefixIcon,
            color:
                Color.fromARGB(255, 97, 173, 255)), // Icono al inicio del campo
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // Sin bordes visibles
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.blue, width: 2), // Bordes azules
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.blue, width: 2), // Bordes azules
        ),
      ),
      onSaved: onSaved,
    );
  }
}
