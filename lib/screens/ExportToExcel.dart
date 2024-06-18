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

// import 'dart:io';

// import 'package:excel/excel.dart';
// import 'package:helvetasfront/model/DatosEstacionHidrologica.dart';
// import 'package:path_provider/path_provider.dart';

// Future<void> exportToExcel(List<DatosEstacionHidrologica> datosList) async {
//   var excel = Excel.createExcel(); // Crear un nuevo archivo Excel
//   Sheet sheetObject = excel['Sheet1']; // Seleccionar la primera hoja

//   // Escribir los encabezados
//   sheetObject.appendRow([
//     'Nombre del Municipio',
//     'Limnimetro',
//     'Fecha Reg',
//     'ID Estación',
//     'Delete'
//   ]);

//   // Escribir los datos
//   for (var datos in datosList) {
//     sheetObject.appendRow([
//       datos.nombreMunicipio,
//       datos.limnimetro,
//       datos.fechaReg,
//       datos.idEstacion,
//       datos.delete
//     ]);
//   }

//   try {
//     // Obtener el directorio de documentos del sistema
//     Directory directory = await getApplicationDocumentsDirectory();
//     String filePath = "${directory.path}/Datos.xlsx";

//     // Guardar el archivo Excel
//     var fileBytes = excel.save();
//     File(filePath)
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(fileBytes!);

//     print('Archivo guardado en $filePath');
//   } catch (e) {
//     print('Error al guardar el archivo: $e');
//   }
// }


import 'dart:io';

import 'package:excel/excel.dart';
import 'package:helvetasfront/model/DatosEstacionHidrologica.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<void> exportToExcel(List<DatosEstacionHidrologica> datosList) async {
  print('Inicio de exportación a Excel');
  try {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    print('Añadiendo encabezados');
    sheetObject.appendRow(['Nombre del Municipio', 'Limnimetro', 'Fecha Reg', 'ID Estación', 'Delete']);

    for (var datos in datosList) {
      print('Añadiendo datos: ${datos.nombreMunicipio}');
      sheetObject.appendRow([
        datos.nombreMunicipio,
        datos.limnimetro,
        datos.fechaReg,
        datos.idEstacion,
        datos.delete
      ]);
    }
    print('Directorio obtenido: pppppppppppppp');
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = path.join(directory.path, 'Datos.xlsx');
    print('Directorio obtenido: $filePath');

    if (!directory.existsSync()) {
      print('Directorio no existe, creando...');
      directory.createSync(recursive: true);
    }

    var fileBytes = excel.save();
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    print('Archivo guardado en $filePath');
  } catch (e) {
    print('Error al guardar el archivo: $e');
  }
}
