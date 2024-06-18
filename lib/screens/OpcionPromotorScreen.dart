import 'package:flutter/material.dart';

class OpcionPromotorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de registrar fecha de siembra
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrarFechaSiembraScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Registrar Fecha de Siembra'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de registro de pronóstico decenal
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroPronosticoDecenalScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Registro de Pronóstico Decenal'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarFechaSiembraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Fecha de Siembra'),
      ),
      body: Center(
        child: Text(
          'Pantalla de Registrar Fecha de Siembra',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class RegistroPronosticoDecenalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Pronóstico Decenal'),
      ),
      body: Center(
        child: Text(
          'Pantalla de Registro de Pronóstico Decenal',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}