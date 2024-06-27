import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class FormFechaSiembra extends StatefulWidget {
  final String nombreCompleto;
  final String nombreZona;

  FormFechaSiembra({
    required this.nombreCompleto,
    required this.nombreZona,
  });

  @override
  _FormFechaSiembraState createState() => _FormFechaSiembraState();
}

class _FormFechaSiembraState extends State<FormFechaSiembra> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF164092),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
            Text(
              'REGISTRO DE DATOS',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(20), // Márgenes alrededor del contenedor
              padding: EdgeInsets.all(15), // Padding interno del contenedor
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo blanco
                borderRadius:
                    BorderRadius.circular(15), // Bordes redondeados de radio 15
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Color de la sombra
                    blurRadius: 5, // Radio de desenfoque de la sombra
                    offset:
                        Offset(0, 2), // Offset de la sombra (desplazamiento)
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime(DateTime.now().year - 1),
                lastDay: DateTime(DateTime.now().year + 1),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _fechaSeleccionada = selectedDay;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            if (_fechaSeleccionada != null)
              Text(
                'Fecha seleccionada: ${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_fechaSeleccionada != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fecha guardada: $_fechaSeleccionada'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor selecciona una fecha primero'),
                    ),
                  );
                }
              },
              child: Text('Guardar Fecha'),
            ),
          ],
        ),
      ),
    );
  }
}
