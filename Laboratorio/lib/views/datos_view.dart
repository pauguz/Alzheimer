import 'package:flutter/material.dart';
import '../models/persona.dart';

import 'package:flutter/material.dart';
import '../models/persona.dart';

import 'package:flutter/material.dart';
import '../models/persona.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import '../models/persona.dart';
import 'dart:math';

class DatosPacienteView extends StatefulWidget {
  final Paciente? paciente;
  final bool esRegistro; // true = registro nuevo, false = edición

  const DatosPacienteView({
    super.key,
    this.paciente,
    this.esRegistro = false,
  });

  @override
  State<DatosPacienteView> createState() => _DatosPacienteViewState();
}

class _DatosPacienteViewState extends State<DatosPacienteView> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  String? _sexo;
  String? _antecedentes;
  String? _alcohol;

  @override
  void initState() {
    super.initState();
    /*
    // Manejo seguro de paciente opcional
    _sexo = widget.paciente?.sexo.isNotEmpty == true ? widget.paciente!.sexo : null;
    _correoController.text = widget.paciente?.correo ?? '';
    */

    // Si es registro, generar código único
    if (widget.esRegistro) {
      _codigoController.text = _generarCodigoPaciente();
    }
  }

  String _generarCodigoPaciente() {
    final random = Random();
    final numero = 10000 + random.nextInt(89999);
    return "PAC$numero";
  }

  @override
  void dispose() {
    _correoController.dispose();
    _fechaNacimientoController.dispose();
    _codigoController.dispose();
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
                  widget.esRegistro
                      ? "Registro de Nuevo Paciente"
                      : "Editar Datos de Paciente\n${paciente?.nombre ?? ''} ${paciente?.apellidos ?? ''}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // 🔹 Campo: Sexo (Sí/No)
                _buildDropdown(
                  "Sexo",
                  ["Masculino", "Femenino"],
                  _sexo,
                      (val) => setState(() => _sexo = val),
                ),

                // 🔹 Campo: Correo de contacto
                _buildTextField(
                  label: "Correo de contacto",
                  controller: _correoController,
                  hint: "Ingrese correo electrónico",
                  keyboard: TextInputType.emailAddress,
                ),

                // 🔹 Fecha de nacimiento
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

                // 🔹 Antecedentes familiares (Sí / No)
                _buildDropdown(
                  "Antecedentes familiares",
                  ["Sí", "No"],
                  _antecedentes,
                      (val) => setState(() => _antecedentes = val),
                ),

                // 🔹 Consumo de alcohol (Sí / No)
                _buildDropdown(
                  "Consumo de alcohol",
                  ["Sí", "No"],
                  _alcohol,
                      (val) => setState(() => _alcohol = val),
                ),

                // 🔹 Código del paciente (solo en registro)
                if (widget.esRegistro) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Código de paciente",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codigoController,
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
                ],

                const SizedBox(height: 24),

                // 🔹 Botón Guardar / Siguiente
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
                      print("=== ${widget.esRegistro ? "REGISTRO NUEVO" : "ACTUALIZACIÓN"} ===");
                      print("Sexo: $_sexo");
                      print("Correo: ${_correoController.text}");
                      print("Fecha nacimiento: ${_fechaNacimientoController.text}");
                      print("Antecedentes: $_antecedentes");
                      print("Alcohol: $_alcohol");
                      if (widget.esRegistro) print("Código: ${_codigoController.text}");
                    },
                    child: const Text(
                      "Guardar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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
  Widget _buildDropdown(
      String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}


