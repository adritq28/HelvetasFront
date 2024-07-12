import 'package:flutter/material.dart';

class EditarMeteorologicaScreen extends StatefulWidget {
  final double tempMax;
  final double tempMin;
  final double pcpn;
  final double tempAmb;
  final String dirViento;
  final double velViento;
  final double taevap;
  final String fechaReg;

  const EditarMeteorologicaScreen({
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
  _EditarMeteorologicaScreenState createState() =>
      _EditarMeteorologicaScreenState();
}

class _EditarMeteorologicaScreenState extends State<EditarMeteorologicaScreen> {
  // Controllers for text fields
  TextEditingController tempMaxController = TextEditingController();
  TextEditingController tempMinController = TextEditingController();
  TextEditingController pcpnController = TextEditingController();
  TextEditingController tempAmbController = TextEditingController();
  TextEditingController dirVientoController = TextEditingController();
  TextEditingController velVientoController = TextEditingController();
  TextEditingController taevapController = TextEditingController();
  TextEditingController fechaRegController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with received values
    tempMaxController.text = widget.tempMax.toString();
    tempMinController.text = widget.tempMin.toString();
    pcpnController.text = widget.pcpn.toString();
    tempAmbController.text = widget.tempAmb.toString();
    dirVientoController.text = widget.dirViento;
    velVientoController.text = widget.velViento.toString();
    taevapController.text = widget.taevap.toString();
    fechaRegController.text = widget.fechaReg;
  }

  // Function to get common input decoration for text fields
  InputDecoration _getInputDecoration(String labelText, IconData prefixIcon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(
        prefixIcon,
        color: Color.fromARGB(255, 201, 219, 255),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20.0),
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 201, 219, 255),
      ),
      hintStyle: TextStyle(
        fontSize: 20.0,
        color: Color.fromARGB(255, 201, 219, 255),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 201, 219, 255),
        ),
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tempMaxController,
                          decoration: _getInputDecoration(
                            'Temperatura Máxima',
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
                        child: TextField(
                          controller: tempMinController,
                          decoration: _getInputDecoration(
                            'Temperatura Mínima',
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: pcpnController,
                          decoration: _getInputDecoration(
                            'Precipitación',
                            Icons.water,
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
                        child: TextField(
                          controller: tempAmbController,
                          decoration: _getInputDecoration(
                            'Temperatura Ambiente',
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dirVientoController,
                          decoration: _getInputDecoration(
                            'Dirección Viento',
                            Icons.air,
                          ),
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Color.fromARGB(255, 201, 219, 255),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: velVientoController,
                          decoration: _getInputDecoration(
                            'Velocidad Viento',
                            Icons.speed,
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taevapController,
                          decoration: _getInputDecoration(
                            'Evaporación',
                            Icons.speed,
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
                      // Expanded(
                      //   child: TextField(
                      //     controller: fechaRegController,
                      //     decoration: _getInputDecoration(
                      //       'Fecha y Hora',
                      //       Icons.calendar_today,
                      //     ),
                      //     style: TextStyle(
                      //       fontSize: 17.0,
                      //       color: Color.fromARGB(255, 201, 219, 255),
                      //     ),
                      //     keyboardType: TextInputType.datetime,
                      //   ),
                      // ),
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
                        onPressed: () {
                          // Perform any actions on button press here
                          print('Temp Max: ${tempMaxController.text}');
                          print('Temp Min: ${tempMinController.text}');
                          print('Precipitación: ${pcpnController.text}');
                          print('Temp Ambiente: ${tempAmbController.text}');
                          print('Dir Viento: ${dirVientoController.text}');
                          print('Vel Viento: ${velVientoController.text}');
                          print('Evaporación: ${taevapController.text}');
                          print('Fecha y Hora: ${fechaRegController.text}');
                          
                          // Example: Sending edited data back to previous screen
                          Navigator.pop(context, {
                            'tempMax': double.parse(tempMaxController.text),
                            'tempMin': double.parse(tempMinController.text),
                            'pcpn': double.parse(pcpnController.text),
                            'tempAmb': double.parse(tempAmbController.text),
                            'dirViento': dirVientoController.text,
                            'velViento': double.parse(velVientoController.text),
                            'taevap': double.parse(taevapController.text),
                            'fechaReg': fechaRegController.text,
                          });
                        },
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
