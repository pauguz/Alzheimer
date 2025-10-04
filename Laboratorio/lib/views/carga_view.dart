import 'package:flutter/material.dart';
import '../models/persona.dart';
import 'menu_view.dart';

class CargaView extends StatefulWidget {
  final Persona paciente;
  const CargaView({super.key, required this.paciente});


  @override
  State<CargaView> createState() => _CargaViewState();
}

class _CargaViewState extends State<CargaView> {
  String? _selectedExam;
  final List<String> _examTypes = [
    "MRI",
    "PET",
  ];

  @override
  Widget build(BuildContext context) {
    final paciente=widget.paciente;
    return Scaffold(
      appBar: AppBar(

        title:  Text("Cargar imagen\n${paciente.nombre} ${paciente.apellido}"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

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
