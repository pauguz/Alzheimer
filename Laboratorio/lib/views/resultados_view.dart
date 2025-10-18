import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

  @override
  Widget build(BuildContext context) {
    final Map<String, int> porcentajes = {
      "CN": 20,
      "MCI-E": 20,
      "MCI-P": 20,
      "AD-T": 20,
      "AD-A": 20,
    };

    final Map<String, Color> colores = {
      "CN": Colors.green,
      "MCI-E": Colors.orange,
      "MCI-P": Colors.deepOrange,
      "AD-T": Colors.redAccent,
      "AD-A": Colors.purple,
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                // 🔹 Título
                Text(
                  "Resultados\n${paciente.nombre} ${paciente.apellidos}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Dos imágenes lado a lado
                Row(
                  children: [
                    Expanded(
                      child: _buildImageCard(
                        title: "MRI",
                        imageUrl: imagenOriginalUrl,
                        assetPlaceholder: "assets/images/MRI_of_Human_Brain.jpg",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImageCard(
                        title: "Heatmap",
                        imageUrl: heatmapUrl,
                        assetPlaceholder: "assets/images/heatmap.jpg",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔹 Explicación bajo las imágenes
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Explicación:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "La imagen original representa el corte cerebral obtenido por MRI, "
                              "mientras que el mapa de calor resalta las áreas con mayor actividad "
                              "o cambios patológicos potenciales. "
                              "Los porcentajes indican la probabilidad estimada de cada clase "
                              "de deterioro cognitivo según el análisis del modelo.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Gráfico circular centrado
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: porcentajes.entries.map((entry) {
                            return PieChartSectionData(
                              color: colores[entry.key],
                              value: entry.value.toDouble(),
                              title: "${entry.key}\n${entry.value}%",
                              radius: 70,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Botón volver
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text("Volver"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 Widget auxiliar para mostrar imágenes
  Widget _buildImageCard({
    required String title,
    required String assetPlaceholder,
    String? imageUrl,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(assetPlaceholder, fit: BoxFit.cover),
              )
                  : Image.asset(assetPlaceholder, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
