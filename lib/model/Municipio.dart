class Municipio {
  final int idMunicipio;
  final String nombreMunicipio;
  final int idZona;
  final String nombreZona;
  final String nombreCultivo;
   final int idCultivo;

  Municipio(
      {required this.idMunicipio,
      required this.nombreMunicipio,
      required this.idZona,
      required this.nombreZona,
      required this.nombreCultivo,
      required this.idCultivo});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      idMunicipio: json['idMunicipio'] ?? 0,
      nombreMunicipio: (json['nombreMunicipio'] ?? ''),
      idZona: json['idZona'] ?? 0,
      nombreZona: (json['nombreZona'] ?? ''),
      nombreCultivo: (json['nombreCultivo'] ?? ''),
      idCultivo: json['idCultivo'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMunicipio': idMunicipio,
        'nombreMunicipio': nombreMunicipio,
        'idZona': idZona,
        'nombreZona': nombreZona,
        'nombreCultivo': nombreCultivo,
        'idCultivo': idCultivo,
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
        ", nombreCultivo=" +
        nombreCultivo.toString() +
        ", idCultivo=" +
        idCultivo.toString() +
        "]";
  }
}
