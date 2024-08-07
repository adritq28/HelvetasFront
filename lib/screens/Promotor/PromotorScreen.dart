import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helvetasfront/model/Promotor.dart';
import 'package:helvetasfront/screens/OpcionZonaScreen.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:helvetasfront/services/PromotorService.dart';
import 'package:provider/provider.dart';

class PromotorScreen extends StatefulWidget {
  @override
  _PromotorScreenState createState() => _PromotorScreenState();
}

class _PromotorScreenState extends State<PromotorScreen> {
  final PromotorService _datosService2 = PromotorService();
  late Future<List<Promotor>> _futurePromotor;
  final EstacionService _datosService3 = EstacionService();
  late PromotorService miModelo4;
  late List<Promotor> _Promotor = [];
  late List<String> _municipios = []; // Lista de municipios
  String? _selectedMunicipio;

  @override
  void initState() {
    super.initState();
    miModelo4 = Provider.of<PromotorService>(context, listen: false);
    _cargarPromotor();
  }

  Future<void> _cargarPromotor() async {
    try {
      await miModelo4.getPromotor();
      List<Promotor> a = miModelo4.lista11;
      setState(() {
        _Promotor = a;
        _municipios = a.map((e) => e.nombreMunicipio).toSet().toList();
      
      });
    } catch (e) {
      print('Error al cargar los datossss: $e');
    }
  }
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'images/fondo.jpg', // Cambia esto por la ruta de tu imagen
              fit: BoxFit.cover,
            ),
          ),
          // Contenido de la pantalla
          Padding(
            padding: const EdgeInsets.all(0.0),
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
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 25,
                      ),
                    ),
                    const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 28,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 70,
                  color: Color.fromARGB(
                      91, 4, 18, 43), // Fondo negro con 20% de opacidad
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 15),
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 10.0,
                          runSpacing: 5.0,
                          children: [
                            Text(
                              'OBSERVADORES METEOROLOGICOS E HIDROLOGICOS',
                              style: GoogleFonts.kulimPark(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(
                                      255, 243, 243, 243), // Color del texto
                                  fontSize:
                                      13.0, // Tamaño de la fuente mayor para el título
                                  fontWeight:
                                      FontWeight.bold, // Negrita para el título
                                ),
                              ),
                              textAlign: TextAlign
                                  .left, // Alineación del texto a la izquierda
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'MUNICIPIOS: ',
                  style: GoogleFonts.kulimPark(
                    textStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 239, 239, 240), // Color del texto
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold, // Tamaño de la fuente
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  hint: Text(
                    "Seleccione un Municipio",
                    style: GoogleFonts.convergence(
                      textStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 255, 255, 255), // Color del texto
                        fontSize: 15.0, // Tamaño de la fuente
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  value: _selectedMunicipio,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMunicipio = newValue;
                    });
                  },
                  items:
                      _municipios.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: GoogleFonts.convergence(
                            textStyle: TextStyle(
                              color: Color.fromARGB(
                                  255, 8, 8, 114), // Color del texto
                              fontSize: 15.0, // Tamaño de la fuente
                              //fontWeight: FontWeight.bold,
                            ),
                          )),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: op2(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget op2(BuildContext context) {
    List<Promotor> usuariosFiltrados = _selectedMunicipio == null
        ? _Promotor
        : _Promotor
            .where((u) => u.nombreMunicipio == _selectedMunicipio)
            .toList();
    return ListView.builder(
      itemCount: (usuariosFiltrados.length / 2).ceil(),
      itemBuilder: (context, index) {
        int firstIndex = index * 2;
        int secondIndex = firstIndex + 1;

        var firstDato = usuariosFiltrados[firstIndex];
        var secondDato = secondIndex < usuariosFiltrados.length
            ? usuariosFiltrados[secondIndex]
            : null;

        return Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage("images/47.jpg"),
                      ),
                    ),
                    Text(
                      "${firstDato.nombreCompleto}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("Municipio: ${firstDato.nombreMunicipio}"),
                    Text("ID Municipio: ${firstDato.idMunicipio}"),
                    //Text("ID: ${firstDato.idCultivo}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.assignment_add,
                            size: 50,
                          ),
                          onPressed: () {
                            mostrarDialogoContrasena(context, firstDato);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (secondDato != null)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage("images/46.jpg"),
                        ),
                      ),
                      Text(
                        "${secondDato.nombreCompleto}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text("Municipio: ${secondDato.nombreMunicipio}"),
                    Text("ID Municipio: ${secondDato.idMunicipio}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.assignment_add,
                              size: 50,
                            ),
                            onPressed: () {
                              mostrarDialogoContrasena(context, secondDato);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void mostrarDialogoContrasena(BuildContext context, Promotor dato) {
    final TextEditingController _passwordController = TextEditingController();
    bool _obscureText = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese Contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Cambiar la visibilidad del texto
                      setState(() {
                        _obscureText = !_obscureText;
                        print('aaaaaaaaaa');
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                  height: 20), // Espacio entre el campo de texto y los botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.red, // Cambia el color del texto a rojo
                        fontSize: 18, // Cambia el tamaño del texto a 18
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.blue, // Cambia el color del texto a azul
                        fontSize: 18, // Cambia el tamaño del texto a 18
                      ),
                    ),
                    onPressed: () async {
                      final password = _passwordController.text;
                      final esValido = await _datosService3.validarContrasena(
                          password, dato.idUsuario);
                      if (esValido) {
                        Navigator.of(context).pop(); // Cierra el diálogo
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            print(dato.idUsuario);
                            return ChangeNotifierProvider(
                              create: (context) => PromotorService(),
                              child: OpcionZonaScreen(
                                idUsuario: dato.idUsuario,
                                idZona: dato.idZona,
                                nombreZona: dato.nombreZona,
                                nombreMunicipio: dato.nombreMunicipio,
                                nombreCompleto: dato.nombreCompleto,
                                telefono: dato.telefono,
                                idCultivo: dato.idCultivo,
                                nombreCultivo: dato.nombreCultivo,
                                tipo: dato.tipo,
                              ),
                            );
                          }),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Contraseña incorrecta'),
                              actions: [
                                TextButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cierra el diálogo
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  final _formKey = GlobalKey<FormState>();
  late int _idUsuario;
  late String _nombreMunicipio;
  late String _nombreZona;
  late String _nombreCompleto;
  late String _telefono;
  late int _idZona;

  Widget formPromotor() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  labelText: 'Municipio',
                  hintText: 'Municipio',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _nombreMunicipio = value!;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MyTextField(
                  labelText: 'Estacion',
                  hintText: 'Estacion',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _nombreZona = value!;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: MyTextField(
                  labelText: 'Nombre',
                  hintText: 'Nombre',
                  prefixIcon: Icons.person,
                  onSaved: (value) {
                    _nombreCompleto = value!;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              //   Promotor nuevoDato = Promotor(
              //       idUsuario: _idUsuario,
              //       nombreMunicipio: _nombreMunicipio,
              //       nombreZona: _nombreZona,
              //       nombreCompleto: _nombreCompleto,
              //       telefono: _telefono,
              //       idZona: _idZona );
              //   print(nuevoDato.toStringPromotor());

              //   crear(nuevoDato).then((alertDialog) {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return alertDialog;
              //       },
              //     );
              //   });
              // }
            },
            child: const Text('Guardar datos'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => EstacionService(),
                  );
                }),
              );
            },
            child: const Text('Datos estacion'),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final void Function(String?)? onSaved;

  const MyTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 225, 255, 246), // Color de fondo
        hintText: hintText, // Texto de sugerencia
        hintStyle: const TextStyle(
            color: Color.fromARGB(
                255, 180, 255, 231)), // Estilo del texto de sugerencia
        labelText: labelText, // Etiqueta del campo
        labelStyle:
            const TextStyle(color: Colors.blue), // Estilo de la etiqueta
        prefixIcon: Icon(
          prefixIcon,
          color: Color.fromARGB(255, 97, 173, 255),
        ), // Icono al inicio del campo
        border: OutlineInputBorder(
          // Borde del campo
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // Sin bordes visibles
        ),
        enabledBorder: OutlineInputBorder(
          // Borde cuando el campo está habilitado pero no seleccionado
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.blue, width: 2), // Bordes azules
        ),
        focusedBorder: OutlineInputBorder(
          // Borde cuando el campo está seleccionado
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.blue, width: 2), // Bordes azules
        ),
      ),
      // onSaved: (value) {
      //   _labelText = value!;
      // },
      onSaved: onSaved,
    );
  }
}