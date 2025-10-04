import 'package:flutter/material.dart';
import 'datos_view.dart';
import 'carga_view.dart';
import 'resultados_view.dart';
import 'historial_view.dart';
import '../models/persona.dart';

class MenuView extends StatelessWidget {
  final Persona paciente;

  const MenuView({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    final paciente= this.paciente;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                "Menu Principal - ${paciente.nombre} ${paciente.apellido}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Botón Nuevo análisis
              _MenuButton(
                title: "Nuevo análisis",
                icon: Icons.image,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CargaView(paciente: paciente,)),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Botón Historial
              _MenuButton(
                title: "Historial",
                icon: Icons.history,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HistorialView(paciente: paciente,)),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Botón Resultados
              _MenuButton(
                title: "Resultados",
                icon: Icons.bar_chart,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ResultadosView(paciente: paciente,)),
                  );
                },
              ),
              // Botón Resultados
              _MenuButton(
                title: "Datos",
                icon: Icons.bar_chart,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  DatosPacienteView(paciente: paciente)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _MenuButton({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(icon, size: 36),
      ),
    );
  }
}

