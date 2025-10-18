import 'package:flutter/material.dart';
import '../models/persona.dart';
import 'resultados_view.dart';

class HistorialView extends StatelessWidget {
  final List<String> imagenes;
  final Paciente paciente;

  const HistorialView({
    super.key,
    this.imagenes = const [],
    required this.paciente,
  });

  @override
  Widget build(BuildContext context) {
    // Elemento de ejemplo si no hay imágenes reales
    final List<String> elementos = imagenes.isEmpty
        ? ["Ejemplo de análisis sin imagen"]
        : imagenes;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "Historial y Resultados\n${paciente.nombre} ${paciente.apellidos}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Lista de análisis
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: elementos.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          // Abrir vista de resultados
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultadosView(paciente: paciente),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.analytics, size: 48, color: Colors.blue),
                            SizedBox(height: 8),
                            Text("Análisis de ejemplo"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
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
    );
  }
}
