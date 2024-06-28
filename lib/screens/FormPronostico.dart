import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosPronostico.dart';
import 'package:helvetasfront/services/PronosticoService.dart';
import 'package:provider/provider.dart';

class FormPronostico extends StatefulWidget {
  final int idUsuario;
  final int idZona;
  final String nombreZona;
  final String nombreMunicipio;
  final String nombreCompleto;
  final String telefono;

  FormPronostico(
      {required this.idUsuario,
      required this.idZona,
      required this.nombreZona,
      required this.nombreMunicipio,
      required this.nombreCompleto,
      required this.telefono});

  @override
  _FormPronosticoState createState() => _FormPronosticoState();
}

class _FormPronosticoState extends State<FormPronostico> {
  final PronosticoService _pronosticoService2 =
      PronosticoService(); // Instancia del servicio de datos
  late Future<List<DatosPronostico>> _futureDatosPronostico;
  final PronosticoService _pronosticoService3 = PronosticoService();
  late PronosticoService miModelo4; // Futuro de la lista de personas
  late List<DatosPronostico> _datosPronostico = [];

  // @override
  // void initState() {
  //   super.initState();
  //   miModelo4 = Provider.of<PronosticoService>(context, listen: false);
  //   // _cargarDatosMeteorologica(); // Carga los datos al inicializar el estado
  // }
  final _formKey = GlobalKey<FormState>();
  late int _idUsuario;
  late String _nombreMunicipio;
  late String _nombreZona;
  late String _nombreCompleto;
  late double _tempMax;
  late double _tempMin;
  late double _pcpn;
  late int _idZona;
  late int _idFenologia;
  late DateTime fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<PronosticoService>(context, listen: false);
    _cargarDatosPronostico();
  }

  Future<void> _cargarDatosPronostico() async {
    try {
      await miModelo4.obtenerDatosPronostico(widget.idUsuario, widget.idZona);
      List<DatosPronostico> a = miModelo4.lista11;
      setState(() {
        _datosPronostico = a; // Asigna los datos a la lista
      });
    } catch (e) {
      print('Error al cargar los datos222: $e');
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
                    "Zona " + widget.nombreZona,
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
            FutureBuilder<List<DatosPronostico>>(
              future: _pronosticoService3.obtenerDatosPronostico(widget.idUsuario, widget.idZona),
              builder: (context, AsyncSnapshot<List<DatosPronostico>> snapshot) {
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
          ],
        ),
      ),
    );
  }

  SingleChildScrollView tablaDatos(List<DatosPronostico> datosList) {
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
                label: Text('Nombre municipio',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Nombre zona',
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
                label: Text('PCPN',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('Fecha Reg',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(
                label: Text('ID Fenologia',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            // Otros campos según tus necesidades
          ],
          rows: datosList.map((datos) {
            return DataRow(cells: [
              DataCell(Text('${datos.idUsuario}')),
              DataCell(Text('${widget.nombreMunicipio}')),
              DataCell(Text('${widget.nombreZona}')),
              DataCell(Text('${datos.tempMax}')),
              DataCell(Text('${datos.tempMin}')),
              DataCell(Text('${datos.pcpn}')),
              DataCell(Text('${datos.fecha}')),
              DataCell(Text('${datos.idFenologia}')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Future<Widget> crear(DatosPronostico elem) async {
    //_fechaReg = DateTime.now();
    //String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(_fechaReg.toUtc().add(Duration(hours: 4)));
    String h = await _pronosticoService2.saveDatosPronostico(elem);
    return AlertDialog(
      title: const Text('Título del Alerta'),
      content: Text(h),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _cargarDatosPronostico();
            }); // Cierra el diálogo
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  Widget formDatosEstacion() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 20,
            left: 15,
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'IDFENOLOGIA',
                              hintText: 'IDFENOLOGIA',
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
                              _idFenologia = int.tryParse(value ?? '0') ?? 0;
                            },
                          ),
                        ),
                      ),
                      //const SizedBox(width: 5), // Espacio entre los campos
                    ],
                  ),
                  //const SizedBox(height: 5),

                  //const SizedBox(width: 5),

                  Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Alineación de los botones
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) {
                            //     return GraficaScreen(
                            //       tempMaxList: tempMaxList,
                            //       fechaList: fechaList,
                            //     );
                            //   }),
                            // );
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
                              DatosPronostico nuevoDato = DatosPronostico(
                                idUsuario: widget.idUsuario,
                                nombreMunicipio: widget.nombreMunicipio,
                                nombreZona: widget.nombreZona,
                                nombreCompleto: widget.nombreCompleto,
                                telefono: widget.telefono,
                                tempMax: _tempMax,
                                tempMin: _tempMin,
                                pcpn: _pcpn,
                                idZona: widget.idZona,
                                idFenologia: _idFenologia,
                                fecha: fecha
                                  ..toUtc().subtract(Duration(hours: 8)),
                              );
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