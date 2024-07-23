import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AnadirCultivoScreen extends StatefulWidget {
  final int idZona;

  const AnadirCultivoScreen({
    required this.idZona,
  });

  @override
  _AnadirCultivoScreenState createState() => _AnadirCultivoScreenState();
}

class _AnadirCultivoScreenState extends State<AnadirCultivoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _fechaSiembraController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoController.dispose();
    _fechaSiembraController.dispose();
    super.dispose();
  }

  Future<void> guardarDato() async {
    if (_formKey.currentState!.validate()) {
      final String fechaReg = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());

      final newDato = {
        'idZona': widget.idZona,
        'nombre': _nombreController.text,
        'tipo': _tipoController.text,
        'fechaSiembra': _fechaSiembraController.text.isEmpty ? null : _fechaSiembraController.text,
        'fechaReg': fechaReg,
      };

      final response = await http.post(
        Uri.parse('http://localhost:8080/cultivos/addCultivo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newDato),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dato añadido correctamente')),
        );
        Navigator.pop(context, true);
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
          _fechaSiembraController.text = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateTime);
        });
      }
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
              child: Form(
                key: _formKey,
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
                          child: TextFormField(
                            controller: _nombreController,
                            decoration: _getInputDecoration(
                                'Nombre Cultivo', Icons.thermostat),
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Color.fromARGB(255, 201, 219, 255),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa el nombre del cultivo';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _tipoController,
                            decoration: _getInputDecoration(
                                'Tipo Cultivo', Icons.thermostat),
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Color.fromARGB(255, 201, 219, 255),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa el tipo de cultivo';
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
                          child: GestureDetector(
                            onTap: _selectDateTime,
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _fechaSiembraController,
                                decoration: _getInputDecoration(
                                  'Fecha y Hora de Siembra',
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
            ),
          ),
        ],
      ),
    );
  }
}
