import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/persona.dart';

class ResultadosView extends StatefulWidget {
  final Persona paciente;

  const ResultadosView({super.key, required this.paciente});

  @override
  State<ResultadosView> createState() => _ResultadosViewState();
}

class _ResultadosViewState extends State<ResultadosView> {
  // Mapa con las clases y sus porcentajes iniciales
  Map<String, int> porcentajes = {
    "CN": 0,
    "MCI-E": 0,
    "MCI-P": 0,
    "AD-T": 0,
    "AD-A": 0,
  };

  // Colores para cada clase
  final Map<String, Color> colores = {
    "CN": Colors.green,
    "MCI-E": Colors.orange,
    "MCI-P": Colors.deepOrange,
    "AD-T": Colors.redAccent,
    "AD-A": Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    final paciente = widget.paciente;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),

              Text(
                "Resultados\n${paciente.nombre} ${paciente.apellido}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // Gráfico circular
              Expanded(
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PieChart(
                        PieChartData(
                          sections: porcentajes.entries.map((entry) {
                            return PieChartSectionData(
                              color: colores[entry.key],
                              value: entry.value.toDouble(),
                              title: "${entry.key}\n${entry.value}%",
                              radius: 65,
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
              ),

              // Inputs dinámicos para cada clase
              Expanded(
                child: ListView(
                  children: porcentajes.keys.map((clave) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(
                              clave,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                              ),
                              onChanged: (value) {
                                final val = int.tryParse(value) ?? 0;
                                if (val >= 0 && val <= 100) {
                                  setState(() {
                                    porcentajes[clave] = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),
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
