import 'package:flutter/material.dart';

class HistorialView extends StatelessWidget {
  final List<String> imagenes;

  const HistorialView({super.key, this.imagenes = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                "Historial",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Si no hay imágenes cargadas
              if (imagenes.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      "Aún no hay imágenes cargadas",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: imagenes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            // Acción al abrir análisis
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.insert_drive_file,
                                  size: 48, color: Colors.black54),
                              SizedBox(height: 8),
                              Text("Análisis"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Botón salir
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
                child: const Text("Salir"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
