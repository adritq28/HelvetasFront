class Municipio{
  final int id;
  final String nombre;
  final int id_provincia;

  Municipio({required this.id, required this.nombre, required this.id_provincia});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      id: json['idEstacion'],
      nombre: json['nombre'],
      id_provincia: json['idProvincia'],
    );
  }

    Map<String, dynamic> toJson() => {
        'idEstacion': id,
        'nombre': nombre,
        'idProvincia': id_provincia
      };

  String toStringMunicipio() {
    return "Municipio [idMunicipio=" + id.toString() + ", nombre=" + nombre +  ", idProvincia=" + id_provincia.toString() + "]";
  }

}