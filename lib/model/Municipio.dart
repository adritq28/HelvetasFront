class Municipio {
  final int idMunicipio;
  final String nombreMunicipio;
  final int idZona;
  final String nombreZona;

  Municipio(
      {required this.idMunicipio,
      required this.nombreMunicipio,
      required this.idZona,
      required this.nombreZona});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      idMunicipio: json['idMunicipio'] ?? 0,
      nombreMunicipio: (json['nombreMunicipio'] ?? ''),
      idZona: json['idZona'] ?? 0,
      nombreZona: (json['nombreZona'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'idMunicipio': idMunicipio,
        'nombreMunicipio': nombreMunicipio,
        'idZona': idZona,
        'nombreZona': nombreZona
      };

  String toStringMunicipio() {
    return "Municipio [idMunicipio=" +
        idMunicipio.toString() +
        ", nombre=" +
        nombreMunicipio +
        ", idZona=" +
        idZona.toString() +
        ", nombreZona=" +
        nombreZona.toString() +
        "]";
  }
}
