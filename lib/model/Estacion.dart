class Estacion {
  final int id;
  final String nombre;
  final bool estado;
  final String tipoEstacion;
  final String coordenadas;
  final String imagen;
  final int idDatosEstacion;
  final int idObservador;
  final int idMunicipio;

  Estacion(
    {required this.id,
    required this.nombre,
    required this.estado,
    required this.tipoEstacion,
    required this.coordenadas,
    required this.imagen,
    required this.idDatosEstacion,
    required this.idObservador,
    required this.idMunicipio});


    factory Estacion.fromJson(Map<String, dynamic> json) {
    return Estacion(
      id: json['idEstacion'],
      nombre: json['nombre'],
      estado: json['estado'],
      tipoEstacion: json['tipoEstacion'],
      coordenadas: json['coordenadas'],
      imagen: json['imagen'],
      idDatosEstacion: json['idDatosEstacion'],
      idObservador: json['idObservador'],
      idMunicipio: json['idMunicipio'],
    );
  }

    Map<String, dynamic> toJson() => {
        'idEstacion': id,
        'nombre': nombre,
        'estado': estado,
        'tipoEstacion': tipoEstacion,
        'coordenadas': coordenadas,
        'imagen': imagen,
        'idDatosEstacion': idDatosEstacion,
        'idObservador': idObservador,
        'idMunicipio': idMunicipio,
      };

  String toStringEstacion() {
    return "Estacion [idEstacion=" + id.toString() + ", nombre=" + nombre + ", estado=" + estado.toString()
                + ", tipoEstacion=" + tipoEstacion + ", coordenadas=" + coordenadas + ", imagen=" + imagen + ", idDatosEstacion=" + idDatosEstacion.toString() +
                ", idObservador=" + idObservador.toString() + ", idMunicipio=" + idMunicipio.toString() +"]";
  }
}
