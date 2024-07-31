class Fenologia {
  //final int id;
  final int idMunicipio;
  final String nombreCultivo;
  final String tipo;
  final String descripcion;
  final int fase;
  final int nroDias;
  final int idCultivo;
  final double tempMax;
  final double tempMin;
  final double pcpn;
  late DateTime fechaSiembra = DateTime.now();
  final int idFenologia;
  final double tempOpt;
  final double umbInf;
  final double umbSup;
  final String imagen;

  Fenologia({
    //required this.id,
    required this.idMunicipio,
    required this.nombreCultivo,
    required this.tipo,
    required this.descripcion,
    required this.fase,
    required this.nroDias,
    required this.idCultivo,
    required this.tempMax,
    required this.tempMin,
    required this.pcpn,
    required this.fechaSiembra,
    required this.idFenologia,
    required this.tempOpt,
    required this.umbInf,
    required this.umbSup,
    required this.imagen
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
      idCultivo: json['idCultivo'] ?? 0,
      tempMax: (json['tempMax'] ?? 0.0).toDouble(),
      tempMin: (json['tempMin'] ?? 0.0).toDouble(),
      pcpn: (json['pcpn'] ?? 0.0).toDouble(),
      fechaSiembra: json['fechaSiembra'] != null
          ? DateTime.parse(json['fechaSiembra'])
          : DateTime.now(),
      idFenologia: json['idFenologia'] ?? 0,
      tempOpt: (json['tempOpt'] ?? 0.0).toDouble(),
      umbSup: (json['umbSup'] ?? 0.0).toDouble(),
      umbInf: (json['umbInf'] ?? 0.0).toDouble(),
      imagen: (json['imagen'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'idCultivo': idCultivo,
        'idMunicipio': idMunicipio,
        'descripcion': descripcion,
        'nombreMunucipio': nombreCultivo,
        'tipo': tipo,
        'fase': fase,
        'nroDias': nroDias,
        'tempMax': tempMax,
        'tempMin': tempMin,
        'pcpn': pcpn,
        'fechaSiembra': fechaSiembra
            .toUtc()
            .toIso8601String(), //fechaSiembraDatos.toIso8601String(),
        'idFenologia': idFenologia,
        'tempOpt': tempOpt,
        'umbSup': umbSup,
        'umbInf': umbInf,
        'imagen': imagen,
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
        ", idCultivo=" +
        idCultivo.toString() +
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
