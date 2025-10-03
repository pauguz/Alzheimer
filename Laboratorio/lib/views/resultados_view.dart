import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultadosView extends StatefulWidget {
  const ResultadosView({super.key});

  @override
  State<ResultadosView> createState() => _ResultadosViewState();
}

class _ResultadosViewState extends State<ResultadosView> {
  int positivo = 0; // Inicialmente 0
  int get negativo => 100 - positivo;

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
                "Resultados",
                style: TextStyle(
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
                          sections: [
                            PieChartSectionData(
                              color: Colors.redAccent,
                              value: positivo.toDouble(),
                              title: "Positivo\n$positivo%",
                              radius: 70,
                              titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            PieChartSectionData(
                              color: Colors.blueAccent,
                              value: negativo.toDouble(),
                              title: "Negativo\n$negativo%",
                              radius: 70,
                              titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Input numérico
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Positivo (%): "),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      ),
                      onChanged: (value) {
                        final val = int.tryParse(value) ?? 0;
                        if (val >= 0 && val <= 100) {
                          setState(() {
                            positivo = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
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
    );
  }
}
