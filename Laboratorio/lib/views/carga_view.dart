import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// Asumo que tu modelo Paciente tiene al menos un campo 'id'.
// Si no es así, ajústalo.
import '../models/persona.dart';

class CargaView extends StatefulWidget {
  final Paciente paciente;
  const CargaView({super.key, required this.paciente});

  @override
  State<CargaView> createState() => _CargaViewState();
}

class _CargaViewState extends State<CargaView> {
  String? _selectedExam;
  File? _selectedFile;
  bool _isLoading = false;

  final List<String> _examTypes = [
    "MRI",
    // "PET", // Puedes añadir más si tu backend los soporta
  ];

  /// Abre el selector de archivos para que el usuario elija una imagen.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  /// Envía la imagen al backend para ser analizada.
  Future<void> _analizarImagen() async {
    if (_selectedFile == null || _selectedExam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona un tipo de examen y una imagen.'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // IMPORTANTE: Debes gestionar el token de acceso de forma segura.
      // Esto es solo un ejemplo. Idealmente, lo obtendrías de un provider
      // o un gestor de estado después de que el usuario inicie sesión.
      const String accessToken = "TU_ACCESS_TOKEN_AQUI";

      final uri = Uri.parse(
          'https://alzheimer-api-j5o0.onrender.com/pacientes/${widget.paciente.id}/analisis/');
          
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..files.add(
          await http.MultipartFile.fromPath(
            'file', // El nombre del campo que espera tu API
            _selectedFile!.path,
          ),
        );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        _showResultDialog(
          "Análisis Exitoso ✅", 
          "Resultado: ${data['resultado_tecnico']}\n\nExplicación: ${data['resultado_explicado']}"
        );
      } else {
        final errorData = json.decode(responseBody);
        _showResultDialog(
          "Error en el Análisis ❌", 
          "Código: ${response.statusCode}\nError: ${errorData['detail'] ?? 'No se pudo procesar la solicitud.'}"
        );
      }
    } catch (e) {
      _showResultDialog("Error de Conexión 🔌",
          "No se pudo conectar con el servidor. Verifica tu conexión a internet.\nDetalle: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Muestra un diálogo con el resultado del análisis.
  void _showResultDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paciente = widget.paciente;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cargar imagen\n${paciente.nombre} ${paciente.apellidos}", textAlign: TextAlign.center,),
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
                  child: InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        child: _selectedFile == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.insert_drive_file_outlined,
                                      size: 64, color: Colors.black54),
                                  SizedBox(height: 12),
                                  Text("Toca para seleccionar un archivo"),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.file(
                                  _selectedFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón Analizar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_selectedFile != null && !_isLoading)
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: (_selectedFile != null && !_isLoading) ? _analizarImagen : null,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Analizar",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
              // Botón salir
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text("Salir", style: TextStyle(color: Colors.black87, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
