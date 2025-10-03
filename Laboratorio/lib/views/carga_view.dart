import 'package:flutter/material.dart';

class CargaView extends StatefulWidget {
  const CargaView({super.key});

  @override
  State<CargaView> createState() => _CargaViewState();
}

class _CargaViewState extends State<CargaView> {
  String? _selectedExam;
  final List<String> _examTypes = [
    "Examen 1",
    "Examen 2",
    "Examen 3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                "Cargar imagen",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // Lista desplegable
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Tipo de examen",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: _selectedExam,
                items: _examTypes
                    .map((exam) => DropdownMenuItem(
                  value: exam,
                  child: Text(exam),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExam = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Caja de carga de archivo
              Expanded(
                child: Center(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.insert_drive_file,
                              size: 64, color: Colors.black54),
                          SizedBox(height: 12),
                          Text("Seleccionar archivo"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Botón Analizar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    // Aquí irá la lógica de análisis
                  },
                  child: const Text(
                    "Analizar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
