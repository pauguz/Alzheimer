import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    final nombre = _nombreController.text.trim();
    final correo = _correoController.text.trim(); // suponiendo que esto será el nombre_usuario
    final contrasena = _contrasenaController.text.trim();
    final confirmar = _confirmarController.text.trim();

    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty || confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
      return;
    }

    if (contrasena != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    // Preparar los datos del body
    final Map<String, dynamic> body = {
      "nombre_usuario": correo,
      "nombre_completo": nombre,
      "contrasena": contrasena,
    };

    try {
      // Hacer la petición HTTP al backend
      final url = Uri.parse("https://alzheimer-api-j5o0.onrender.com/register");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Manejar respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso ✅")),
        );

        // (Opcional) volver a pantalla de login
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        final data = jsonDecode(response.body);
        String mensaje = data["detail"]?.toString() ?? "Error desconocido";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $mensaje")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Ingrese sus\ndatos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Campo: Nombre
                _buildInput("Nombre", "Ingrese su nombre", _nombreController),
                const SizedBox(height: 16),

                // Campo: Usuario / correo
                _buildInput("Usuario", "Ingrese su correo", _correoController),
                const SizedBox(height: 16),

                // Campo: Contraseña
                _buildInput("Contraseña", "Ingrese su contraseña", _contrasenaController, obscure: true),
                const SizedBox(height: 16),

                // Campo: Confirmar contraseña
                _buildInput("Confirmar contraseña", "Confirme su contraseña", _confirmarController, obscure: true),
                const SizedBox(height: 32),

                // Botón de registro
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
                    onPressed: _registrar,
                    child: const Text(
                      "Registrarse",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón Salir
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Salir"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller,
      {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEDE7F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
