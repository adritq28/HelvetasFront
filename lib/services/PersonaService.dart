import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helvetasfront/model/Persona.dart';
import 'package:http/http.dart' as http;


class PersonaService extends ChangeNotifier {

  Future<List<Persona>> getPersonas() async {
    try {
      //print('saasdasd1');
      //final url = Uri.http("localhost:8080", "/personas");
      //print('aaaaaaaa0');
      final response = await http.get(Uri.http("localhost:8080", "/personas/sol"));
      //print('aaaaaaaa');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Persona> personas = data.map((e) => Persona.fromJson(e)).toList();
        return personas;
      } else {
        throw Exception('Failed to load personas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> savePersona(Persona persona) async {
    try {
      final response = await http.post(
        Uri.http("localhost:8080", "/personas/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(persona.toJson()),
      );
      if (response.statusCode == 201) {
        print('Persona guardada correctamente');
        print(response.statusCode);
        return (response.body.toString());
      } else {
        throw Exception('Error al guardar la persona');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
