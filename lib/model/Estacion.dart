class Estacion {
  final int id;
  final String nombre;
  final String latitud;
  final String longitud;
  final String altura;
  final bool estado;
  final String tipoEstacion;
  final int idMunicipio;
  final bool codTipoEstacion;

  Estacion(
      {required this.id,
      required this.nombre,
      required this.latitud,
      required this.longitud,
      required this.altura,
      required this.estado,
      required this.tipoEstacion,
      required this.idMunicipio,
      required this.codTipoEstacion});

  factory Estacion.fromJson(Map<String, dynamic> json) {
    return Estacion(
      id: json['idEstacion'],
      nombre: json['nombre'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      altura: json['altura'],
      estado: json['estado'],
      tipoEstacion: json['tipoEstacion'],
      idMunicipio: json['idMunicipio'],
      codTipoEstacion: json['codTipoEstacion'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idEstacion': id,
        'nombre': nombre,
        'latitud': latitud,
        'longitud': longitud,
        'altura': altura,
        'estado': estado,
        'tipoEstacion': tipoEstacion,
        'idMunicipio': idMunicipio,
        'codTipoEstacion': codTipoEstacion,
      };

  String toStringEstacion() {
    return "Estacion [idEstacion=" +
        id.toString() +
        ", nombre=" +
        nombre +
        ", latitud=" +
        latitud +
        ", longitud=" +
        longitud +
        ", altura=" +
        altura +
        ", estado=" +
        estado.toString() +
        ", tipoEstacion=" +
        tipoEstacion +
        ", idMunicipio=" +
        idMunicipio.toString() +
        ", codTipoEstacion=" +
        codTipoEstacion.toString() +
        "]";
  }
}
