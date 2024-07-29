import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  List<Map<String, dynamic>> datos = [];
  List<Map<String, dynamic>> datosFiltrados = [];
  bool isLoading = true;
  String? mesSeleccionado;
  List<String> meses = [
    'Todos',
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  //late PronosticoService miModelo4;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tempMaxController = TextEditingController();
  final TextEditingController _tempMinController = TextEditingController();
  final TextEditingController _pcpnController = TextEditingController();
  late DateTime fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    // miModelo4 = Provider.of<EstacionService>(context, listen: false);
    //_cargarDatosEstacion();
    fetchZonas(); // Carga los datos al inicializar el estado
  }

  @override
  void dispose() {
    _tempMaxController.dispose();
    _tempMinController.dispose();
    _pcpnController.dispose();
    fecha;

    super.dispose();
  }

  Future<void> guardarDato() async {
    if (_formKey.currentState!.validate()) {
      final newDato = {
        'idZona': widget.idZona,
        'tempMax': _tempMaxController.text.isEmpty
            ? null
            : double.parse(_tempMaxController.text),
        'tempMin': _tempMinController.text.isEmpty
            ? null
            : double.parse(_tempMinController.text),
        'pcpn': _pcpnController.text.isEmpty
            ? null
            : double.parse(_pcpnController.text),
        'fecha': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('http://localhost:8080/datos_pronostico/addDatosPronostico'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newDato),
      );

      if (response.statusCode == 201) {
        // Mostrar un diálogo de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Éxito'),
              content: Text('Dato añadido correctamente'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    fetchZonas(); // Recargar los datos
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        final errorMessage = response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir dato: $errorMessage')),
        );
      }
    }
  }

  InputDecoration _getInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.white),
      labelStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.black.withOpacity(0.3),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return 'Fecha no disponible';
    }
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
    } catch (e) {
      print('Error al parsear la fecha: $dateTimeString');
      return 'Fecha inválida';
    }
  }

  Future<void> fetchZonas() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/datos_pronostico/lista_datos_zona/${widget.idZona}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        datos = List<Map<String, dynamic>>.from(json.decode(response.body));
        datosFiltrados = datos; // Inicialmente, no se filtra nada
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load datos meteorologicos');
    }
  }

  void filtrarDatosPorMes(String? mes) {
    if (mes == null || mes.isEmpty || mes == 'Todos') {
      setState(() {
        datosFiltrados = datos;
      });
      return;
    }

    int mesIndex = meses.indexOf(mes);// Meses son 1-indexados en DateTime

    setState(() {
      datosFiltrados = datos.where((dato) {
        try {
          DateTime fecha = DateTime.parse(dato['fecha']);
          return fecha.month == mesIndex;
        } catch (e) {
          print('Error al parsear la fecha: ${dato['fecha']}');
          return false;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                //color: Colors.black.withOpacity(0.5), // Fondo semitransparente
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                    //SizedBox(height: 15),
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
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: DropdownButton<String>(
                        value: mesSeleccionado,
                        hint: Text(
                          'Seleccione un mes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            mesSeleccionado = newValue;
                            filtrarDatosPorMes(newValue);
                          });
                        },
                        items:
                            meses.map<DropdownMenuItem<String>>((String mes) {
                          return DropdownMenuItem<String>(
                            value: mes,
                            child: Text(
                              mes,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 185, 223, 255),
                              ),
                            ),
                          );
                        }).toList(),
                        dropdownColor: Colors.grey[800],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        iconEnabledColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0), // Ajusta el valor según sea necesario
                        child: TextButton.icon(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         GraficaScreen(datos: datosFiltrados),
                            //   ),
                            // );
                          },
                          icon: Icon(Icons.show_chart, color: Colors.white),
                          label: Text(
                            'Gráfica',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 142, 146, 143),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //const SizedBox(width: 10),
                  const SizedBox(height: 10),
                  formDatosPronostico() ,
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Nro',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Fecha',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Temp Max',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Temp Min',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Precipitación',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        
                          ],
                          rows: List<DataRow>.generate(datosFiltrados.length,
                              (index) {
                            final dato = datosFiltrados[index];
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    (index + 1)
                                        .toString(), // Número correlativo
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    formatDateTime(
                                        dato['fecha']?.toString()),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    dato['tempMax'].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    dato['tempMin'].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    dato['pcpn'].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                ])),
              ),
            ],
          ),
        ],
      ),
    );
  }
 Widget formDatosPronostico() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tempMaxController,
                          decoration:
                              _getInputDecoration('Temp Max', Icons.thermostat),
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Color.fromARGB(255, 201, 219, 255),
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa la temperatura ambiente';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _tempMinController,
                          decoration:
                              _getInputDecoration('Temp Min', Icons.thermostat),
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Color.fromARGB(255, 201, 219, 255),
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa la temperatura ambiente';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pcpnController,
                          decoration:
                              _getInputDecoration('Precipitación', Icons.water),
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Color.fromARGB(255, 201, 219, 255),
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 203, 230, 255),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: guardarDato,
                        child: Text('Añadir Dato'),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


