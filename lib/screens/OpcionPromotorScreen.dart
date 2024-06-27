import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Promotor.dart';
import 'package:helvetasfront/screens/FormFechaSiembra.dart';
import 'package:helvetasfront/screens/FormPronostico.dart';
import 'package:helvetasfront/services/PromotorService.dart';
import 'package:helvetasfront/services/PronosticoService.dart';
import 'package:provider/provider.dart';

class OpcionPromotorScreen extends StatefulWidget {
  final int idUsuario;
  final int idZona;
  final String nombreZona;
  final String nombreMunicipio;
  final String nombreCompleto;
  final String telefono;


  OpcionPromotorScreen(
      {required this.idUsuario,
      required this.idZona,
      required this.nombreZona,
      required this.nombreMunicipio,
      required this.nombreCompleto,
      required this.telefono,});

  @override
  _OpcionPromotorScreenState createState() => _OpcionPromotorScreenState();
}

class _OpcionPromotorScreenState extends State<OpcionPromotorScreen> {
  late PromotorService _datosService2;
  late PromotorService _datosService3;
  late List<Promotor> _promotorList;

  @override
  void initState() {
    super.initState();
    _datosService2 = Provider.of<PromotorService>(context, listen: false);
    _datosService3 = PromotorService();
    _promotorList = [];
    _cargarPromotor();
  }

  Future<void> _cargarPromotor() async {
    try {
      await _datosService2.getPromotor();
      setState(() {
        _promotorList = _datosService2.lista11;
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF164092),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Row(
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
                      Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
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
                        'REGISTRO DE DATOS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => FormFechaSiembra()),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  //     textStyle: TextStyle(fontSize: 18),
                  //   ),
                  //   child: Text('Registrar Fecha de Siembra'),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChangeNotifierProvider(
                            create: (context) => PromotorService(),
                            child: FormFechaSiembra(
                              //idUsuario: dato.idUsuario,
                              //idZona: dato.idZona,
                              nombreZona: widget.nombreZona,
                              //nombreMunicipio: dato.nombreMunicipio,
                              nombreCompleto: widget.nombreCompleto,
                              //telefono: dato.telefono,
                            ),
                          );
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Registro de Pronóstico Decenal'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      var dato = _promotorList.firstWhere(
                        (promotor) => promotor.idUsuario == widget.idUsuario,
                        orElse: () => Promotor(
                          idUsuario: widget.idUsuario,
                          idZona: widget.idZona,
                          nombreZona: widget.nombreZona,
                          nombreMunicipio: widget.nombreMunicipio,
                          nombreCompleto: widget.nombreCompleto,
                          telefono: widget.telefono,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChangeNotifierProvider(
                            create: (context) => PronosticoService(),
                            child: FormPronostico(
                              idUsuario: dato.idUsuario,
                              idZona: dato.idZona,
                              nombreZona: dato.nombreZona!,
                              nombreMunicipio: dato.nombreMunicipio!,
                              nombreCompleto: dato.nombreCompleto!,
                              telefono: dato.telefono!,
                            ),
                          );
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Registro de Pronóstico Decenal'),
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
