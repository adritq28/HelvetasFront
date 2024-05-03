class DatosEstacion {
  final int id;
  final String coordenada;
  final double dirVelViento;
  final DateTime fechaDatos;
  final double pcpn;
  final double taevap;
  final double tempAmb;
  final double tempMax;
  final double tempMin;

  DatosEstacion(
    {required this.id,
    required this.coordenada,
    required this.dirVelViento,
    required this.fechaDatos,
    required this.pcpn,
    required this.taevap,
    required this.tempAmb,
    required this.tempMax,
    required this.tempMin,

    });


    factory DatosEstacion.fromJson(Map<String, dynamic> json) {
    return DatosEstacion(
      id: json['idDatosEst']?? 0,
      coordenada: json['coordenada']?? '',
      dirVelViento: (json['dirVelViento']?? 0.0).toDouble(),
      fechaDatos: json['fechaDatos']!= null ? DateTime.parse(json['fechaDatos']) : DateTime.now(),
      pcpn: (json['pcpn']?? 0.0).toDouble(),
      taevap: (json['taevap']?? 0.0).toDouble(),
      tempAmb: (json['tempAmb']?? 0.0).toDouble(),
      tempMax: (json['tempMax']?? 0.0).toDouble(),
      tempMin: (json['tempMin']?? 0.0).toDouble(),

      
      
    );
  }

    Map<String, dynamic> toJson() => {
      
        'idDatosEstacion': id,
        'coordenada': coordenada,
        'dirVelViento': dirVelViento,
        'fechaDatos': fechaDatos.toUtc().toIso8601String(),//fechaDatos.toIso8601String(),
        'pcpn': pcpn,
        'taevap': taevap,
        'tempAmb': tempAmb,
        'tempMax': tempMax,
        'tempMin': tempMin,
      };

  String toStringDatosEstacion() {
    //print('777777');
    return "DatosEstacion [idDatosEstacion=" + id.toString() +
    ", coordenada=" + coordenada +
    ", dirVelViento=" + dirVelViento.toString() +
    ", fechaDatos=" + fechaDatos.toString() +
    ", pcpn=" + pcpn.toString()+
    ", taevap=" + taevap.toString() +
    ", tempAmb=" + tempAmb.toString() +
    ", tempMax=" + tempMax.toString()+
    ", tempMin=" + tempMin.toString() +"]";
  }
}
