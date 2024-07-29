import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListaEstacionHidrologicaScreen extends StatefulWidget {
  final int idUsuario;
  final String nombreMunicipio;
  final String nombreEstacion;
  final String tipoEstacion;
  final String nombreCompleto;
  final String telefono;
  final int idEstacion;
  final bool codTipoEstacion;

  ListaEstacionHidrologicaScreen({
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
  _ListaEstacionHidrologicaScreenState createState() =>
      _ListaEstacionHidrologicaScreenState();
}

class _ListaEstacionHidrologicaScreenState
    extends State<ListaEstacionHidrologicaScreen> {
  List<Map<String, dynamic>> datos = [];
  bool isLoading = true;
  List<Map<String, dynamic>> datosFiltrados = [];
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

  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _limnimetro = TextEditingController();
  //final TextEditingController _fechaRegController = TextEditingController();
  late DateTime fechaReg = DateTime.now();

  @override
  void initState() {
    super.initState();
    // miModelo4 = Provider.of<EstacionService>(context, listen: false);
    //_cargarDatosEstacion();
    fetchDatosHidrologico(); // Carga los datos al inicializar el estado
  }

  @override
  void dispose() {
    _limnimetro.dispose();
    fechaReg;
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> guardarDato() async {
    if (_formKey.currentState!.validate()) {
      final newDato = {
        'idEstacion': widget.idEstacion,
        'limnimetro': _limnimetro.text.isEmpty
            ? null
            : double.parse(_limnimetro.text),
        'fechaReg': DateTime.now().toIso8601String(), // Generar fecha actual
      
      };

      final response = await http.post(
        Uri.parse('http://localhost:8080/datosHidrologica/addDatosHidrologica'),
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
                    fetchDatosHidrologico(); // Recargar los datos
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

  void filtrarDatosPorMes(String? mes) {
    if (mes == null || mes.isEmpty || mes == 'Todos') {
      setState(() {
        datosFiltrados = datos;
      });
      return;
    }

    int mesIndex = meses.indexOf(mes) - 1; // Restar 1 para ajustar el índice

    setState(() {
      datosFiltrados = datos.where((dato) {
        try {
          DateTime fecha = DateTime.parse(dato['fechaReg']);
          return fecha.month == mesIndex;
        } catch (e) {
          print('Error al parsear la fecha: ${dato['fechaReg']}');
          return false;
        }
      }).toList();
    });
  }

  Future<void> fetchDatosHidrologico() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/estacion/lista_datos_hidrologica/${widget.idEstacion}'),
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
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage("images/47.jpg"),
                    ),
                    const SizedBox(height: 5),
                    //SizedBox(height: 15),
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
                      'Municipio de: ${widget.nombreMunicipio}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(208, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Estación Hidrologica: ${widget.nombreEstacion}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(208, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    20.0), // Ajusta el valor según sea necesario
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
                                backgroundColor:
                                    Color.fromARGB(255, 142, 146, 143),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //const SizedBox(width: 10),
                      formDatosEstacion(),
                      const SizedBox(height: 20),
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
                                      'Limnimetro',
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
                                        dato['fechaReg']?.toString()),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataCell(
                                        Text(
                                          dato['limnimetro'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )                             ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget formDatosEstacion() {
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
                            controller: _limnimetro,
                            decoration: _getInputDecoration(
                                'limnimetro', Icons.thermostat),
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Color.fromARGB(255, 201, 219, 255),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa la limnimetro';
                              }
                              return null;
                            },
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
