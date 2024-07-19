import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarHidrologicaScreen extends StatefulWidget {
  final int idHidrologica;
  final double limnimetro;
  final String fechaReg;

  const EditarHidrologicaScreen({
    required this.idHidrologica,
    required this.limnimetro,
    required this.fechaReg,
  });

  @override
  _EditarHidrologicaScreenState createState() =>
      _EditarHidrologicaScreenState();
}

class _EditarHidrologicaScreenState extends State<EditarHidrologicaScreen> {
  // Controllers for text fields
  TextEditingController limnimetroController = TextEditingController();
  TextEditingController fechaRegController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with received values
    limnimetroController.text = widget.limnimetro.toString();
    fechaRegController.text = widget.fechaReg;
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

  Future<void> _guardarCambios() async {
    final url = Uri.parse('http://localhost:8080/estacion/editarHidrologica');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'idHidrologica': widget.idHidrologica,
      'limnimetro': double.parse(limnimetroController.text),
      'fechaReg': fechaRegController.text,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Datos actualizados correctamente');
      Navigator.pop(context, true); // Indica que se guardaron cambio
    } else {
      print('Error al actualizar los datos');
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
                          controller: limnimetroController,
                          decoration: _getInputDecoration(
                            'Limnimetro',
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
