// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';

// Future<void> ExportToExcel(List<Map<String, dynamic>> data) async {
//   // Crear un nuevo libro de Excel
//   final excel = Excel.createExcel();

//   // Crear una nueva hoja
//   final sheet = excel['Datos'];

//   // Agregar encabezados
//   final headers = data.isNotEmpty ? data.first.keys.toList() : [];
//   sheet.appendRow(headers);

//   // Agregar filas de datos
//   for (final row in data) {
//     final rowData = headers.map((header) => row[header]).toList();
//     sheet.appendRow(rowData);
//   }

//   // Obtener el directorio de documentos
//   final directory = await getApplicationDocumentsDirectory();
//   final filePath = '${directory.path}/datos.xlsx';

//   // Guardar el archivo Excel
//   final file = File(filePath);
//   final excelData = excel.encode();
//   if (excelData != null) {
//     await file.writeAsBytes(excelData);
//     print('Exportación exitosa: $filePath');
//   } else {
//     print('Error al codificar el archivo Excel.');
//   }

//   // Abrir el archivo en una aplicación externa (opcional)
//   // await OpenFile.open(filePath);
// }

// // Uso
// void main() async {
//   final data = [
//     {'tempMax': 30, 'tempMin': 20, 'pcpn': 5, 'fechaReg': '2024-05-28'},
//     {'tempMax': 32, 'tempMin': 22, 'pcpn': 6, 'fechaReg': '2024-05-29'},
//     // Agrega más datos según tu estructura
//   ];

//   await ExportToExcel(data);
// }
