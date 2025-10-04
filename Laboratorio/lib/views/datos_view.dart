import 'package:flutter/material.dart';
import '../models/persona.dart';

class DatosPacienteView extends StatefulWidget {
  final Persona paciente;

  const DatosPacienteView({super.key, required this.paciente});

  @override
  State<DatosPacienteView> createState() => _DatosPacienteViewState();
}

class _DatosPacienteViewState extends State<DatosPacienteView> {
  String? _antecedentes;
  String? _estadoCivil;
  String? _alcohol;
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _educacionController = TextEditingController();

  @override
  void dispose() {
    _edadController.dispose();
    _educacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paciente = widget.paciente;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  "Datos del Paciente\n${paciente.nombre} ${paciente.apellido}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Campo: Sexo (solo lectura)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Sexo",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      )),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: paciente.sexo),
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Antecedentes familiares (Si/No)
                _buildDropdown(
                  "Antecedentes familiares",
                  ["Sí", "No"],
                  _antecedentes,
                      (val) => setState(() => _antecedentes = val),
                ),

                // Edad (numérico)
                _buildNumeric("Edad", _edadController),

                // Años de educación (numérico)
                _buildNumeric("Años de educación", _educacionController),

                // Estado civil (dropdown)
                _buildDropdown(
                  "Estado civil",
                  ["Soltero", "Casado", "Viudo", "Divorciado"],
                  _estadoCivil,
                      (val) => setState(() => _estadoCivil = val),
                ),

                // Consumo de alcohol (dropdown)
                _buildDropdown(
                  "Consumo de alcohol",
                  ["Nunca", "Ocasional", "Frecuente"],
                  _alcohol,
                      (val) => setState(() => _alcohol = val),
                ),

                const SizedBox(height: 32),

                // Botón Guardar / Siguiente
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      print("Sexo: ${paciente.sexo}");
                      print("Antecedentes: $_antecedentes");
                      print("Edad: ${_edadController.text}");
                      print("Educación: ${_educacionController.text}");
                      print("Estado civil: $_estadoCivil");
                      print("Alcohol: $_alcohol");
                    },
                    child: const Text(
                      "Siguiente",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Helpers ----------
  Widget _buildDropdown(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNumeric(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Ingrese $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
