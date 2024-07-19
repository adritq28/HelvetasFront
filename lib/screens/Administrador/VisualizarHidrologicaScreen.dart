import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisualizarHidrologicaScreen extends StatelessWidget {
  final int idHidrologica;
  final double limnimetro;
  final String fechaReg;

  const VisualizarHidrologicaScreen({
    required this.idHidrologica,
    required this.limnimetro,
    required this.fechaReg,
  });

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
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
                  _buildDataRow('Limnimetro', '${limnimetro.toString()} cm', Icons.water),
                  _buildDataRow('Fecha y Hora de registro', formatDateTime(fechaReg), Icons.calendar_today),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String labelText, String valueText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color.fromARGB(255, 201, 219, 255),
            size: 28,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$labelText: $valueText',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 201, 219, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
