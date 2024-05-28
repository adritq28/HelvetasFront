import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Municipio.dart';
import 'package:helvetasfront/screens/ListaInvitadoScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:provider/provider.dart';

class MunicipiosScreen extends StatefulWidget {
  @override
  _MunicipiosScreenState createState() => _MunicipiosScreenState();
}

class _MunicipiosScreenState extends State<MunicipiosScreen> {
  final EstacionService _datosService2 = EstacionService();
  late Future<List<Municipio>> _futureUsuarioEstacion;
  final EstacionService _datosService3 = EstacionService();
  late EstacionService miModelo4;

  late List<Municipio> _usuarioEstacion = [];

  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<EstacionService>(context, listen: false);
    _cargarMunicipio();
  }

  Future<void> _cargarMunicipio() async {
    try {
      await miModelo4.getMunicipio();
      List<Municipio> a = miModelo4.lista114;
      setState(() {
        _usuarioEstacion = a;
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF164092),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: op2(context),
      ),
    );
  }

  Widget op2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
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
                SizedBox(height: 5),
                Text(
                  "Bienvenido Invitado ",
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
                      style: TextStyle(color: Colors.white),
                      'Lista de Municipios',
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: miModelo4.lista114.length,
              itemBuilder: (context, index) {
                final dato = miModelo4.lista114[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${dato.idMunicipio}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Municipio: ${dato.nombreMunicipio}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.visibility_rounded,
                                color: Colors.white),
                            label: Text('Ver Datos',
                                style: TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey, // Color plomo
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8.0), // Border radius
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ChangeNotifierProvider(
                                    create: (context) => EstacionService(),
                                    child: ListaInvidatoScreen(
                                      idMunicipio: dato.idMunicipio,
                                      nombreMunicipio: dato.nombreMunicipio,
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }




  
}
