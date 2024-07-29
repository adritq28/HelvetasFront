import 'package:flutter/material.dart';
import 'package:helvetasfront/screens/TimeLineEvent.dart';
import 'package:intl/intl.dart';

class HorizontalTimeline extends StatelessWidget {
  final List<TimelineEvent> events;

  HorizontalTimeline({required this.events});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250, // Ajusta según tus necesidades
        //width: 500,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centrar contenido verticalmente
                children: [
                  Container(
                    width: 80, // Ancho deseado de la imagen rectangular
                    height: 120, // Alto deseado de la imagen rectangular
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Borde redondeado opcional
                      image: DecorationImage(
                        image: AssetImage("images/fenologia.jpg"), // Ruta de la imagen
                        fit: BoxFit.cover, // Ajuste para cubrir el contenedor
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    event.dias.toString(),
                    style: TextStyle(
                      color: event.textColor,
                    ),
                    textAlign: TextAlign.center, // Centrar el texto
                  ),
                  Text(
                    event.title,
                    style: TextStyle(
                      color: event.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Centrar el texto
                  ),
                  Text(
                    event.description,
                    style: TextStyle(
                      color: event.textColor,
                    ),
                    textAlign: TextAlign.center, // Centrar el texto
                  ),
                  Text(
                    DateFormat.yMMMd().format(event.fecha),
                    style: TextStyle(
                      color: event.textColor,
                    ),
                    textAlign: TextAlign.center, // Centrar el texto
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}