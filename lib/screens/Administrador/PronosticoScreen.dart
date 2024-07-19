import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PronosticoScreen extends StatefulWidget {
  final int idUsuario;
  final String nombre;
  final String apeMat;
  final String apePat;
  final String ci;

  const PronosticoScreen({
    required this.idUsuario,
    required this.nombre,
    required this.apeMat,
    required this.apePat,
    required this.ci,
  });

  @override
  _PronosticoScreenState createState() =>
      _PronosticoScreenState();
}

class _PronosticoScreenState
    extends State<PronosticoScreen> {
  List<Map<String, dynamic>> zonas = [];
  Map<String, List<Map<String, dynamic>>> zonasPorMunicipio = {};
  String? municipioSeleccionado;
  String? zonaSeleccionada;
  int? idzonaSeleccionada;

  @override
  void initState() {
    super.initState();
    fetchzonas();
  }

  Future<void> fetchzonas() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/datos_pronostico/lista_zonas'));
      if (response.statusCode == 200) {
        setState(() {
          zonas = List<Map<String, dynamic>>.from(json.decode(response.body));
          zonasPorMunicipio = agruparzonasPorMunicipio(zonas);
        });
      } else {
        throw Exception('Failed to load zonas');
      }
    } catch (e) {
      // Manejar errores de red o de decodificación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las zonas')),
      );
    }
  }

  Map<String, List<Map<String, dynamic>>> agruparzonasPorMunicipio(List<Map<String, dynamic>> zonas) {
    Map<String, List<Map<String, dynamic>>> agrupadas = {};
    for (var zona in zonas) {
      if (!agrupadas.containsKey(zona['nombreMunicipio'])) {
        agrupadas[zona['nombreMunicipio']] = [];
      }
      agrupadas[zona['nombreMunicipio']]!.add(zona);
    }
    return agrupadas;
  }

  void navigateToDatosMeteorologicaScreen() {
    // if (idzonaSeleccionada != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DatosMeteorologicaScreen(
    //         idZona: idzonaSeleccionada!,
    //         nombreMunicipio: municipioSeleccionado!,
    //         nombreZona: zonaSeleccionada!,
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              child: Row(
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
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Opción 1'),
                        value: 'opcion1',
                      ),
                      PopupMenuItem(
                        child: Text('Opción 2'),
                        value: 'opcion2',
                      ),
                      PopupMenuItem(
                        child: Text('Opción 3'),
                        value: 'opcion3',
                      ),
                    ],
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("images/47.jpg"),
                      ),
                      SizedBox(width: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bienvenid@: ${widget.nombre} ${widget.apePat} ${widget.apeMat}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(208, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: zonas.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: zonasPorMunicipio.keys.length,
                      itemBuilder: (context, index) {
                        String municipio = zonasPorMunicipio.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      municipioSeleccionado = municipio;
                                      zonaSeleccionada = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 203, 230, 255),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      municipio,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 34, 52, 96),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (municipioSeleccionado != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Seleccione una estación en $municipioSeleccionado:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 240, 255),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: zonaSeleccionada,
                      hint: Text(
                        'Seleccione una estación',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 236, 241, 255),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          zonaSeleccionada = newValue;
                          idzonaSeleccionada =
                              zonasPorMunicipio[municipioSeleccionado]!
                                  .firstWhere((element) =>
                                      element['nombreZona'] ==
                                      newValue)['idZona'];
                          navigateToDatosMeteorologicaScreen();
                        });
                      },
                      items: zonasPorMunicipio[municipioSeleccionado]!
                          .map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> zona) {
                        return DropdownMenuItem<String>(
                          value: zona['nombreZona'],
                          child: Text(zona['nombreZona']),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
