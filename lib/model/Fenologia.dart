class Fenologia {
  //final int id;
  final int idMunicipio;
  final String nombreCultivo;
  final String tipo;
  final String descripcion;
  final int fase;
  final int nroDias;
  //final int idPronostico;
  final double tempMax;
  final double tempMin;
  final double pcpn;
  late DateTime fechaSiembra = DateTime.now();
  final int idFenologia;

  Fenologia({
    //required this.id,
    required this.idMunicipio,
    required this.nombreCultivo,
    required this.tipo,
    required this.descripcion,
    required this.fase,
    required this.nroDias,
    //required this.idPronostico,
    required this.tempMax,
    required this.tempMin,
    required this.pcpn,
    required this.fechaSiembra,
    required this.idFenologia,
  });

  factory Fenologia.fromJson(Map<String, dynamic> json) {
    return Fenologia(
      //id: json['idDatosEst'] ?? 0,
      idMunicipio: json['idMunicipio'] ?? 0,
      nombreCultivo: (json['nombreCultivo'] ?? ''),
      tipo: (json['tipo'] ?? ''),
      descripcion: (json['descripcion'] ?? ''),
      fase: (json['fase'] ?? ''),
      nroDias: (json['nroDias'] ?? ''),
      //idPronostico: json['idFenologia'] ?? 0,
      tempMax: (json['tempMax'] ?? 0.0).toDouble(),
      tempMin: (json['tempMin'] ?? 0.0).toDouble(),
      pcpn: (json['pcpn'] ?? 0.0).toDouble(),
      fechaSiembra: json['fechaSiembra'] != null
          ? DateTime.parse(json['fechaSiembra'])
          : DateTime.now(),
      idFenologia: json['idFenologia'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        //'idPronostico': idPronostico,
        'idMunicipio': idMunicipio,
        'descripcion': descripcion,
        'nombreMunucipio': nombreCultivo,
        'tipo': tipo,
        'fase': fase,
        'nroDias': nroDias,
        'tempMax': tempMax,
        'tempMin': tempMin,
        'pcpn': pcpn,
        'fechaSiembra':
            fechaSiembra.toUtc().toIso8601String(), //fechaSiembraDatos.toIso8601String(),
        'idFenologia': idFenologia,
      };

  String toStringFenologia() {
    return "Fenologia [idMunicipio.toString()" +
        ", nombreCultivo=" +
        nombreCultivo +
        ", tipo=" +
        tipo +
        ", descripcion=" +
        descripcion +
        ", fase=" +
        fase.toString() +
        ", nroDias=" +
        nroDias.toString() +
        ", fechaSiembra=" +
        fechaSiembra.toString() +
        //", idPronostico=" +
        //idPronostico.toString() +
        ", tempMax=" +
        tempMax.toString() +
        ", tempMin=" +
        tempMin.toString() +
        ", pcpn=" +
        pcpn.toString() +
        ", idFenologia=" +
        idFenologia.toString() +
        "]";
  }
}