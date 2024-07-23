import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficaScreen extends StatelessWidget {
  final List<Map<String, dynamic>> datos;

  GraficaScreen({required this.datos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return '${date.day}/${date.month}';
                },
                reservedSize: 22,
                margin: 8,
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  return value.toString();
                },
                reservedSize: 28,
                margin: 12,
              ),
            ),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: datos.map((dato) {
                  final dateStr = dato['fechaReg']?.toString();
                  final tempMaxStr = dato['tempMax']?.toString();
                  if (dateStr != null && tempMaxStr != null) {
                    final date = DateTime.tryParse(dateStr);
                    final tempMax = double.tryParse(tempMaxStr);
                    if (date != null && tempMax != null) {
                      return FlSpot(date.millisecondsSinceEpoch.toDouble(), tempMax);
                    }
                  }
                  return null;
                }).whereType<FlSpot>().toList(),
                isCurved: true,
                colors: [Colors.red],
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: datos.map((dato) {
                  final dateStr = dato['fechaReg']?.toString();
                  final tempMinStr = dato['tempMin']?.toString();
                  if (dateStr != null && tempMinStr != null) {
                    final date = DateTime.tryParse(dateStr);
                    final tempMin = double.tryParse(tempMinStr);
                    if (date != null && tempMin != null) {
                      return FlSpot(date.millisecondsSinceEpoch.toDouble(), tempMin);
                    }
                  }
                  return null;
                }).whereType<FlSpot>().toList(),
                isCurved: true,
                colors: [Colors.blue],
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: datos.map((dato) {
                  final dateStr = dato['fechaReg']?.toString();
                  final tempAmbStr = dato['tempAmb']?.toString();
                  if (dateStr != null && tempAmbStr != null) {
                    final date = DateTime.tryParse(dateStr);
                    final tempAmb = double.tryParse(tempAmbStr);
                    if (date != null && tempAmb != null) {
                      return FlSpot(date.millisecondsSinceEpoch.toDouble(), tempAmb);
                    }
                  }
                  return null;
                }).whereType<FlSpot>().toList(),
                isCurved: true,
                colors: [Colors.green],
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
