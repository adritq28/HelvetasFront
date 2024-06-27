
class Promotor {
  final int idUsuario;
  final String nombreMunicipio;
  final String nombreZona;
  final String nombreCompleto;
  final String telefono;
  final int idZona;


  Promotor({
    required this.idUsuario,
    required this.nombreMunicipio,
    required this.nombreZona,
    required this.nombreCompleto,
    required this.telefono,
    required this.idZona,
  });

  factory Promotor.fromJson(Map<String, dynamic> json) {
    return Promotor(
      idUsuario: json['idUsuario'],
      nombreMunicipio: json['nombreMunicipio'],
      nombreZona: json['nombre'],
      nombreCompleto: json['nombreCompleto'],
      telefono: json['telefono'],
      idZona: json['idZona'],

    );
  }

  Map<String, dynamic> toJson() => {
        'idUsuario': idUsuario,
        'nombreMunucipio': nombreMunicipio,
        'nombre': nombreZona,
        'nombreCompleto': nombreCompleto,
        'telefono': telefono,
        'idZona': idZona,
      };

      

  String toStringPromotor() {
    return "Usuario [idUsuario=" +
        idUsuario.toString() +
        ", nombreMunicipio=" +
        nombreMunicipio +
        ", nombreZona=" +
        nombreZona +
        ", nombreCompleto=" +
        nombreCompleto +
        ", telefono=" +
        telefono +
        ", idZona=" +
        idZona.toString() +
        "]";
  }
}