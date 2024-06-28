class Promotor {
  final int idUsuario;
  final String nombreMunicipio;
  final String nombreZona;
  final String nombreCompleto;
  final String telefono;
  final int idZona;
  final int idCultivo;
  final String nombreCultivo;
  final String tipo;

  Promotor({
    required this.idUsuario,
    required this.nombreMunicipio,
    required this.nombreZona,
    required this.nombreCompleto,
    required this.telefono,
    required this.idZona,
    required this.idCultivo,
    required this.nombreCultivo,
    required this.tipo,
  });

  factory Promotor.fromJson(Map<String, dynamic> json) {
    return Promotor(
      idUsuario: json['idUsuario']?? 0,
      nombreMunicipio: json['nombreMunicipio'] ?? 'N/A',
      nombreZona: json['nombreZona'] ?? 'N/A',
      nombreCompleto: json['nombreCompleto'] ?? 'N/A',
      telefono: json['telefono'] ?? 'N/A',
      idZona: json['idZona']?? 0,
      idCultivo: json['idCultivo']?? 0,
      nombreCultivo: json['nombreCultivo'] ?? 'N/A',
      tipo: json['tipo'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() => {
        'idUsuario': idUsuario,
        'nombreMunucipio': nombreMunicipio,
        'nombreZona': nombreZona,
        'nombreCompleto': nombreCompleto,
        'telefono': telefono,
        'idZona': idZona,
        'idCultivo': idCultivo,
        'nombreCultivo': nombreCultivo,
        'tipo': tipo,
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
        ", idCultivo=" +
        idCultivo.toString() +
        ", nombre=" +
        nombreCultivo.toString() +
        ", tipo=" +
        tipo.toString() +
        "]";
  }
}
