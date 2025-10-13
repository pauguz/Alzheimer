import 'package:flutter/material.dart';
import '../models/persona.dart';

class DatosPacienteView extends StatefulWidget {
  final Persona paciente;

  const DatosPacienteView({super.key, required this.paciente});

  @override
  State<DatosPacienteView> createState() => _DatosPacienteViewState();
}

class _DatosPacienteViewState extends State<DatosPacienteView> {
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  String? _antecedentes;
  String? _alcohol;

  @override
  void initState() {
    super.initState();
    _sexoController.text = widget.paciente.sexo;
    _correoController.text = widget.paciente.correo;
  }

  @override
  void dispose() {
    _sexoController.dispose();
    _correoController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1980),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _fechaNacimientoController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
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

                // Campo: Sexo (editable)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sexo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _sexoController,
                  decoration: InputDecoration(
                    hintText: "Ingrese sexo (Masculino / Femenino)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo: Correo de contacto (editable)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Correo de contacto",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Ingrese correo electrónico",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo: Fecha de nacimiento (datepicker)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Fecha de nacimiento",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _fechaNacimientoController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Seleccione una fecha",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _seleccionarFecha(context),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Antecedentes familiares (Sí / No)
                _buildDropdown(
                  "Antecedentes familiares",
                  ["Sí", "No"],
                  _antecedentes,
                      (val) => setState(() => _antecedentes = val),
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
                      print("Sexo: ${_sexoController.text}");
                      print("Correo: ${_correoController.text}");
                      print("Fecha de nacimiento: ${_fechaNacimientoController.text}");
                      print("Antecedentes: $_antecedentes");
                      print("Alcohol: $_alcohol");
                    },
                    child: const Text(
                      "Guardar",
                      style: TextStyle(color: Colors.white),
                    ),
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
                  child: const Text("Salir"),
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
}
