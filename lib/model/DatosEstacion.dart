class DatosEstacion {
  final int id;
  final double tempMax;
  final double tempMin;
  final double tempAmb;
  final double pcpn;
  final double taevap;
  //final DateTime fechaReg;
  final String dirViento;
  final double velViento;
  final int idEstacion;

  DatosEstacion(
      {required this.id,
      required this.tempMax,
      required this.tempMin,
      required this.tempAmb,
      required this.pcpn,
      required this.taevap,
      //required this.fechaReg,
      required this.dirViento,
      required this.velViento,
      required this.idEstacion});

  factory DatosEstacion.fromJson(Map<String, dynamic> json) {
    return DatosEstacion(
      id: json['idDatosEst'] ?? 0,
      tempMax: (json['tempMax'] ?? 0.0).toDouble(),
      tempMin: (json['tempMin'] ?? 0.0).toDouble(),
      tempAmb: (json['tempAmb'] ?? 0.0).toDouble(),
      pcpn: (json['pcpn'] ?? 0.0).toDouble(),
      taevap: (json['taevap'] ?? 0.0).toDouble(),
      // fechaReg: json['fechaReg'] != null
      //     ? DateTime.parse(json['fechaReg'])
      //     : DateTime.now(),
      dirViento: (json['dirViento'] ?? ''),
      velViento: (json['velViento'] ?? 0.0).toDouble(),
      idEstacion: json['idEstacion'] ?? 0,
      
      
    );
  }

  Map<String, dynamic> toJson() => {
        'idDatosEstacion': id,
        'tempMax': tempMax,
        'tempMin': tempMin,
        'tempAmb': tempAmb,
        'pcpn': pcpn,
        'taevap': taevap,
        // 'fechaReg': fechaReg
        //     .toUtc()
        //     .toIso8601String(), //fechaDatos.toIso8601String(),
        'dirViento': dirViento,
        'velViento': velViento,
        'idEstacion': idEstacion,
        
      };

  String toStringDatosEstacion() {
    return "DatosEstacion [idDatosEstacion=" +
        id.toString() +
        ", tempMax=" +
        tempMax.toString() +
        ", tempMin=" +
        tempMin.toString() +
        ", tempAmb=" +
        tempAmb.toString() +
        ", pcpn=" +
        pcpn.toString() +
        ", taevap=" +
        taevap.toString() +
        ", dirViento=" +
        dirViento.toString() +
        ", velViento=" +
        velViento.toString() +
        ", idEstacion=" +
        idEstacion.toString() +
        "]";
  }
}
