class Municipio {
  final int idMunicipio;
  final String nombreMunicipio;
  final int idProvincia;

  Municipio(
      {required this.idMunicipio,
      required this.nombreMunicipio,
      required this.idProvincia});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      idMunicipio: json['idMunicipio'] ?? 0,
      nombreMunicipio: (json['nombreMunicipio'] ?? ''),
      idProvincia: json['idProvincia'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMunicipio': idMunicipio,
        'nombreMunicipio': nombreMunicipio,
        'idProvincia': idProvincia
      };

  String toStringMunicipio() {
    return "Municipio [idMunicipio=" +
        idMunicipio.toString() +
        ", nombre=" +
        nombreMunicipio +
        ", idProvincia=" +
        idProvincia.toString() +
        "]";
  }
}
