class Persona {
  final int id;
  final String tipoPersona;
  final String nombre;
  final String ci;
  final int idEstacion;

  Persona(
      {required this.id,
      required this.tipoPersona,
      required this.nombre,
      required this.ci,
      required this.idEstacion});




  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['idPersona'],
      tipoPersona: json['tipoPersona'],
      nombre: json['nombre'],
      ci: json['ci'],
      idEstacion: json['idEstacion'],
    );
  }

    Map<String, dynamic> toJson() => {
        'idPersona': id,
        'tipoPersona': tipoPersona,
        'nombre': nombre,
        'ci': ci,
        'idEstacion': idEstacion,
      };

  // String toJsonString() {
  //   return jsonEncode(toJson());
  // }

  String toStringPersona() {
    return "Persona [idPersona=" + id.toString() + ", tipo=" + tipoPersona + ", nombre=" + nombre
                + ", ci=" + ci + ", idEstacion=" + idEstacion.toString() + "]";
  }
}
