import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Persona.dart';
import 'package:helvetasfront/screens/ListaEstacionScreen.dart';
import 'package:helvetasfront/services/PersonaService.dart';



class ListaPersonasScreen extends StatefulWidget {
  @override
  _ListaPersonasScreenState createState() => _ListaPersonasScreenState();
}

class _ListaPersonasScreenState extends State<ListaPersonasScreen> {
  final PersonaService _datosService =PersonaService(); // Instancia del servicio de datos
  late Future<List<Persona>> _futurePersonas; // Futuro de la lista de personas

  @override
  void initState() {
    super.initState();
    _futurePersonas = _datosService
        .getPersonas(); // Obtiene la lista de personas al iniciar el estado
  }

  @override
  Widget build(BuildContext context) {
    //crear();
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Personas'),
        ),
        body: op2()
        //   Center(
        //     child: FutureBuilder<List<Persona>>(
        //       future: _futurePersonas,
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
        //         } else if (snapshot.hasError) {
        //           return Text(
        //               'Error: ${snapshot.error}'); // Muestra un mensaje de error si falla la obtención de datos
        //         } else {
        //           return ListView.builder(
        //             itemCount: snapshot.data!.length,
        //             itemBuilder: (context, index) {
        //               return ListTile(
        //                 title: Text(snapshot.data![index]
        //                     .toStringPersona()), // Muestra el nombre de la persona
        //                 //subtitle: Text(snapshot.data![index].apellido), // Muestra el apellido de la persona
        //                 // Puedes agregar más widgets aquí para mostrar más detalles de la persona
        //               );
        //             },
        //           );
        //         }
        //       },
        //     ),
        //   ),
        );
  }

  Widget op2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Texto 1'),
          // ElevatedButton(
          //   onPressed: () {
          //     crear().then((alertDialog) {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return alertDialog; // Muestra el AlertDialog devuelto por el método crear()
          //         },
          //       );
          //     });
          //   },
          //   child: Text('Crear Persona'),
          // ),

          Text('Texto 2'),
          formPersona(),
          Wrap(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: FutureBuilder<List<Persona>>(
                    future: _futurePersonas,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView.builder(
                          shrinkWrap:
                              true, // Para evitar el error de desbordamiento
                          physics:
                              NeverScrollableScrollPhysics(), // Para deshabilitar el desplazamiento de la lista
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data![index].toStringPersona()),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Widget> crear(Persona elem) async {
    String h = await _datosService.savePersona(elem);
    print("a");
    print(h);
    return AlertDialog(
      title: Text('Título del Alerta'),
      content: Text(h),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _ci;
  late int _estacion;
  late String _tipo;
//clave de acceso
  Widget formPersona() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un nombre';
              }
              return null;
            },
            onSaved: (value) {
              _nombre = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'ci'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un apellido';
              }
              return null;
            },
            onSaved: (value) {
              _ci = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Edad'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese una edad';
              }
              if (int.tryParse(value) == null) {
                return 'Por favor ingrese un número válido';
              }
              return null;
            },
            onSaved: (value) {
              _estacion = int.parse(value!);
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(labelText: 'TIPO'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un TIPO PERSONA';
              }
              return null;
            },
            onSaved: (value) {
              _tipo = value!;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Persona nuevaPersona = Persona(
                    id: 0,
                    nombre: _nombre,
                    ci: _ci,
                    idEstacion: _estacion,
                    tipoPersona: _tipo);
                crear(nuevaPersona).then((alertDialog) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertDialog; // Muestra el AlertDialog devuelto por el método crear()
                    },
                  );
                });
              }
            },
            child: Text('Crear Persona'),
          ),
          
          ElevatedButton(
          onPressed: () {
            // Navega a Screen2 cuando se presiona el botón
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListaEstacionScreen()),
            );
          },
          child: Text('Ir a Screen 2'),
        ),

        ],
      ),
    );
  }
}
