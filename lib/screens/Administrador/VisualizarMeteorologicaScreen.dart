import 'package:flutter/material.dart';

class VisualizarMeteorologicaScreen extends StatelessWidget {
  final int idDatosEst;
  final double tempMax;
  final double tempMin;
  final double pcpn;
  final double tempAmb;
  final String dirViento;
  final double velViento;
  final double taevap;
  final String fechaReg;

  const VisualizarMeteorologicaScreen({
    required this.idDatosEst,
    required this.tempMax,
    required this.tempMin,
    required this.pcpn,
    required this.tempAmb,
    required this.dirViento,
    required this.velViento,
    required this.taevap,
    required this.fechaReg,
  });

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
                  _buildDataRow('Temperatura Máxima', '${tempMax.toString()} °C', Icons.thermostat),
                  _buildDataRow('Temperatura Mínima', '${tempMin.toString()} °C', Icons.thermostat),
                  _buildDataRow('Precipitación', '${pcpn.toString()} mm', Icons.water),
                  _buildDataRow('Temperatura Ambiente', '${tempAmb.toString()} °C', Icons.thermostat),
                  _buildDataRow('Dirección Viento', dirViento, Icons.air),
                  _buildDataRow('Velocidad Viento', '${velViento.toString()} km/h', Icons.speed),
                  _buildDataRow('Evaporación', '${taevap.toString()} mm', Icons.speed),
                  _buildDataRow('Fecha y Hora', fechaReg, Icons.calendar_today),
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
