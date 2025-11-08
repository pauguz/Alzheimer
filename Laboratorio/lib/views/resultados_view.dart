import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import '../models/persona.dart';

class ResultadosView extends StatelessWidget {
  final Paciente paciente;
  final String? imagenOriginalUrl;
  final String? heatmapUrl;

  const ResultadosView({
    super.key,
    required this.paciente,
    this.imagenOriginalUrl,
    this.heatmapUrl,
  });

  // 🔹 Verificar permisos de almacenamiento
  Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      } else {
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      }
    }
    return true; // iOS no requiere permiso explícito
  }

  // 🔹 Guardar PDF y abrirlo automáticamente
  Future<void> _guardarPdf(BuildContext context) async {
    final hasPermission = await _checkStoragePermission();
    if (!hasPermission) return;

    final pdf = pw.Document();

    // 🔹 Agregar página con título
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                "Reporte de resultados del paciente",
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),

            // 🔹 Texto explicativo
            pw.Text(
              "Paciente: ${paciente.nombre}\n"
                  //"Edad: ${paciente.edad}\n\n"
                  "El análisis automático de la resonancia magnética cerebral indica una probabilidad del 78% "
                  "de patrones compatibles con enfermedad de Alzheimer en etapa temprana. "
                  "Se observan leves reducciones de volumen en el hipocampo y la corteza temporal medial.",
              style: pw.TextStyle(fontSize: 12),
            ),

            pw.SizedBox(height: 20),

            // 🔹 Tabla de indicadores
            pw.Table.fromTextArray(
              headers: ["Indicador", "Resultado", "Interpretación"],
              data: [
                ["Volumen del hipocampo", "3.2 cm³", "Ligera reducción"],
                ["Corteza temporal medial", "2.8 mm", "Dentro del rango normal"],
                ["Nivel de confianza del modelo", "85%", "Alta confianza"],
              ],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(fontSize: 12),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(color: PdfColors.grey),
            ),
          ],
        ),
      ),
    );

    final pdfBytes = await pdf.save();

    // Carpeta de descargas
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      final extDir = await getExternalStorageDirectory();
      downloadsDir = Directory('${extDir!.parent.parent.parent.parent.path}/Download');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    final filePath =
        '${downloadsDir.path}/reporte_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Archivo guardado en: $filePath")),
    );

    await OpenFile.open(filePath);
  }


  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colores = {
      "Rojo": Colors.red,
      "Amarillo": Colors.orange,
      "Verde": Colors.green,
      "Azul": Colors.blue,
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "Resultado del\nanálisis MRI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Imágenes lado a lado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildImageCard(
                        title: "MRI",
                        assetPlaceholder: "assets/images/MRI_of_Human_Brain.jpg",
                        imageUrl: imagenOriginalUrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImageCard(
                        title: "Heatmap",
                        assetPlaceholder: "assets/images/heatmap.jpg",
                        imageUrl: heatmapUrl,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Leyenda de colores
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 4,
                  children: colores.entries.map((e) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 6, backgroundColor: e.value),
                        const SizedBox(width: 4),
                        Text(
                          _getDescripcionColor(e.key),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 🔹 Tabla de indicadores
                _buildIndicadores(),

                const SizedBox(height: 20),

                // 🔹 Explicación médica
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "El análisis automático de la resonancia magnética cerebral indica una probabilidad del 78% de patrones compatibles con enfermedad de Alzheimer en etapa temprana. "
                          "Se observan leves reducciones de volumen en el hipocampo y la corteza temporal medial.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Botones Descargar y Volver
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _guardarPdf(context),
                      icon: const Icon(Icons.download),
                      label: const Text("Descargar PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                      child: const Text(
                        "Volver",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 Imagen con título
  Widget _buildImageCard({
    required String title,
    required String assetPlaceholder,
    String? imageUrl,
  }) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset(assetPlaceholder, fit: BoxFit.cover),
            )
                : Image.asset(assetPlaceholder,
                height: 130, width: double.infinity, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  // 🔸 Tabla de indicadores
  Widget _buildIndicadores() {
    final data = [
      ["Volumen del hipocampo", "3.2 cm³", "Ligera reducción"],
      ["Corteza temporal medial", "2.8 mm", "Dentro del rango normal"],
      ["Nivel de confianza del modelo", "85%", "Alta confianza"],
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
          },
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey.shade300),
          ),
          children: [
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child:
                  Text("Indicador", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child:
                  Text("Resultado", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Interpretación",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...data.map((row) => TableRow(
              children: row
                  .map((cell) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cell),
              ))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }

  String _getDescripcionColor(String color) {
    switch (color) {
      case "Rojo":
        return "Deterioro alto (posible daño estructural)";
      case "Amarillo":
        return "Cambios leves o riesgo inicial";
      case "Verde":
        return "Zona normal";
      case "Azul":
        return "Sin alteraciones / referencia";
      default:
        return "";
    }
  }
}

