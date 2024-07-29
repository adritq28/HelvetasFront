// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class GraficaScreen extends StatelessWidget {
//   final List<double> tempMaxList;
//   final List<DateTime> fechaRegList;

//   GraficaScreen({required this.tempMaxList, required this.fechaRegList});

//   @override
//   Widget build(BuildContext context) {
//     List<FlSpot> spots = [];

//     for (int i = 0; i < tempMaxList.length; i++) {
//       spots.add(FlSpot(i.toDouble(), tempMaxList[i]));
//     }

//     return Scaffold(
//       //backgroundColor: Color(0xFF164092),
//       appBar: AppBar(
//   title: Text('Gráfica de Temperatura Máxima'),
//   actions: [
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.white,
//             size: 25,
//           ),
//         ),
//         Icon(
//           Icons.more_vert,
//           color: Colors.white,
//           size: 28,
//         ),
//       ],
//     ),
//   ],
// ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: LineChart(
//           LineChartData(
//             titlesData: FlTitlesData(
//               bottomTitles: SideTitles(
//                 showTitles: true,
//                 getTitles: (value) {
//                   int index = value.toInt();
//                   if (index >= 0 && index < fechaRegList.length) {
//                     return DateFormat('MM/dd')
//                         .format(DateTime.parse(fechaRegList[index].toString()));
//                   }
//                   return '';
//                 },
//               ),
//               leftTitles: SideTitles(
//                 showTitles: true,
//                 getTextStyles: (context, value) => const TextStyle(
//                   color: Color(0xff68737d),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 getTitles: (value) {
//                   return value.toString();
//                 },
//                 margin: 8,
//                 reservedSize: 30,
//               ),
//             ),
//             borderData: FlBorderData(
//               show: true,
//               border: Border.all(color: const Color(0xff37434d), width: 1),
//             ),
//             minX: 0,
//             maxX: tempMaxList.length.toDouble() - 1,
//             minY:
//                 tempMaxList.reduce((curr, next) => curr < next ? curr : next) -
//                     5,
//             maxY:
//                 tempMaxList.reduce((curr, next) => curr > next ? curr : next) +
//                     5,
//             lineBarsData: [
//               LineChartBarData(
//                 spots: spots,
//                 isCurved: true,
//                 colors: [Colors.blue],
//                 barWidth: 4,
//                 isStrokeCapRound: true,
//                 belowBarData: BarAreaData(
//                   show: false,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
