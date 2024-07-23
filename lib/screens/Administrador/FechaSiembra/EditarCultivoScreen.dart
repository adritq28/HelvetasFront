import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditarCultivoScreen extends StatefulWidget {
  final int idCultivo;
  final String nombre;
  final String fechaSiembra;
  final String fechaReg;
  final String tipo;

  const EditarCultivoScreen({
    required this.idCultivo,
    required this.nombre,
    required this.fechaSiembra,
    required this.fechaReg,
    required this.tipo
  });

  @override
  _EditarCultivoScreenState createState() =>
      _EditarCultivoScreenState();
}

class _EditarCultivoScreenState extends State<EditarCultivoScreen> {
  // Controllers for text fields
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaSiembraController = TextEditingController();
  TextEditingController fechaRegController = TextEditingController();
  TextEditingController tipoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with received values
    nombreController.text = widget.nombre;
    fechaSiembraController.text = widget.fechaSiembra;
    fechaRegController.text = widget.fechaReg;
    tipoController.text = widget.tipo;
  }

  // Function to get common input decoration for text fields
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

  Future<void> _selectDateTime() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          fechaSiembraController.text =
              DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateTime);
        });
      }
    }
  }

  Future<void> _guardarCambios() async {
  final url = Uri.parse('http://localhost:8080/cultivos/editar');
  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    'idCultivo': widget.idCultivo,
    'nombre': nombreController.text,
    'fechaSiembra': fechaSiembraController.text.isEmpty ? null : fechaSiembraController.text,
    'fechaReg': fechaRegController.text.isEmpty ? null : fechaRegController.text,
    'tipo': tipoController.text
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Datos actualizados correctamente');
    Navigator.pop(context, true); // Indica que se guardaron cambios
  } else {
    print('Error al actualizar los datos: ${response.body}');
  }
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, true);
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nombreController,
                          decoration: _getInputDecoration(
                            'Nombre Cultivo',
                            Icons.thermostat,
                          ),
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Color.fromARGB(255, 201, 219, 255),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: GestureDetector(
                            onTap:
                                _selectDateTime, // Mostrar el selector de fecha y hora al tocar el TextField
                            child: AbsorbPointer(
                              child: TextField(
                                controller: fechaSiembraController,
                                decoration: _getInputDecoration(
                                  'Fecha y Hora',
                                  Icons.calendar_today,
                                ),
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Color.fromARGB(255, 201, 219, 255),
                                ),
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                          ),
                        ),
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
                        onPressed: _guardarCambios,
                        child: Text('Guardar Cambios'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
