import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/persona.dart';
import '../models/analisis.dart';
import '../viewmodels/login_viewmodel.dart';
import 'resultados_view.dart';

class HistorialView extends StatefulWidget {
  final Paciente paciente;

  const HistorialView({super.key, required this.paciente});

  @override
  State<HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  List<Analysis> analisis = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarAnalisis();
  }

  // 🔹 Cargar análisis reales del backend
  Future<void> cargarAnalisis() async {
    try {
      final token = Provider.of<LoginViewModel>(context, listen: false).token;

      if (token == null) {
        debugPrint("⛔ ERROR: Token nulo, no se puede consultar análisis.");
        return;
      }

      final url = Uri.parse(
        "https://alzheimer-api-j5o0.onrender.com/pacientes/${widget.paciente.id}/analisis/",
      );

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);   // ← FIX
        final List<dynamic> data = jsonDecode(decoded);

        setState(() {
          analisis = data.map((json) => Analysis.fromJson(json)).toList();
          cargando = false;
        });
      }
 else {
        setState(() => cargando = false);
      }
    } catch (e) {
      debugPrint("❌ Error al cargar análisis: $e");
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Si NO hay análisis → agregar ejemplo
    final bool hayAnalisis = analisis.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),

              Text(
                "Historial y Resultados\n${widget.paciente.nombre} ${widget.paciente.apellidos}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              if (cargando)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: hayAnalisis ? analisis.length : 1,
                    itemBuilder: (context, index) {
                      if (!hayAnalisis) {
                        return _buildCardEjemplo();
                      }

                      final item = analisis[index];
                      final fullMRI = item.rutaImagenMRI.isNotEmpty
                          ? "https://alzheimer-api-j5o0.onrender.com/${item.rutaImagenMRI}"
                          : null;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResultadosView(
                                  paciente: widget.paciente,
                                  imagenOriginalUrl: fullMRI,
                                  analisis: item,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.analytics,
                                  size: 48, color: Colors.blue),
                              const SizedBox(height: 8),
                              Text(
                                "Análisis #${item.id}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.fecha.split("T")[0],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                child: const Text("Volver"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardEjemplo() {
    return const Card(
      elevation: 4,
      child: Center(
        child: Text(
          "Ejemplo de análisis\n(no hay resultados)",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
