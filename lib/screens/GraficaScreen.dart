import 'package:flutter/material.dart';
import 'package:helvetasfront/model/DatosEstacion.dart';
import 'package:helvetasfront/services/EstacionService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// class GraficaScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
//       home: _GraficaScreen(),
//     );
//   }
// }

class GraficaScreen extends StatefulWidget {
  @override
  _GraficaScreenState createState() => _GraficaScreenState();
}

// class _GraficaScreen extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _GraficaScreen({Key? key}) : super(key: key);

//   @override
//   _GraficaScreenState createState() => _GraficaScreenState();
// }

final EstacionService _datosService2 =
    EstacionService(); // Instancia del servicio de datos
late Future<List<DatosEstacion>>
    _futureDatosEstacion; // Futuro de la lista de personas

// @override
// void initState() {
//   //_futureDatosEstacion = _datosService2.getDatosEstacion();
//   //crear();
//   //super.initState();/ Obtiene la lista de personas al iniciar el estado
// }

class _GraficaScreenState extends State<GraficaScreen> {
  late EstacionService miModelo;
  late List<DatosEstacion> _datosEstacion = [];

  // List<_SalesData> data = [
  //   _SalesData('Jan', 35),
  //   _SalesData('Feb', 28),
  //   _SalesData('Mar', 34),
  //   _SalesData('Apr', 32),
  //   _SalesData('May', 40)
  // ];

  @override
  void initState() {
    super.initState();
    miModelo = EstacionService();
    _cargarDatosEstacion();
  }

  Future<void> _cargarDatosEstacion() async {
    try {
      await miModelo.getDatosEstacion();
      setState(() {
        _datosEstacion = miModelo.lista11;
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
      ),
      body: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            title: ChartTitle(text: 'Half yearly sales analysis'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              LineSeries<DatosEstacion, DateTime>(
                dataSource: _datosEstacion,
                xValueMapper: (DatosEstacion ventas, _) => ventas.fechaDatos,
                yValueMapper: (DatosEstacion ventas, _) => ventas.tempMin,
                name: 'Temperatura',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
              // LineSeries<DatosEstacion, DateTime>(
              //   dataSource: _datosEstacion,
              //   xValueMapper: (DatosEstacion ventas, _) => ventas.fechaDatos,
              //   yValueMapper: (DatosEstacion ventas, _) => ventas.pcpn,
              //   name: 'pcpn',
              //   dataLabelSettings: DataLabelSettings(isVisible: true),
              // ),
            ],
            
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfSparkLineChart(
                trackball: SparkChartTrackball(
                  activationMode: SparkChartActivationMode.tap,
                ),
                marker: SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all,
                ),
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                data: _datosEstacion.map((datos) => datos.tempMin).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
