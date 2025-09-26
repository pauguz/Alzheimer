import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE6F9E6), // verde claro de fondo
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Consumer<LoginViewModel>(
                  builder: (context, vm, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Deteccion de Alzheimer", // título provisional
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Inicio de Sesión",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          onChanged: (value) => vm.email = value,
                          decoration: const InputDecoration(
                            labelText: "Usuario",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color(0xFFD9D9D9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) => vm.password = value,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color(0xFFD9D9D9),
                          ),
                        ),
                        const SizedBox(height: 24),
                        vm.isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo[900],
                            ),
                            onPressed: () async {
                              bool success = await vm.validateLogin();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Login correcto ✅"),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Credenciales inválidas ❌"),
                                  ),
                                );
                              }
                            },
                            child: const Text("Ingresar"),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text("¿No está registrado?"),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                          ),
                          onPressed: () {
                            // Aquí iría navegación a pantalla de registro
                          },
                          child: const Text("Registrar"),
                        ),
                        const SizedBox(height: 16),
                        const Text("O ingrese mediante"),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey),
                          ),
                          onPressed: () {
                            // Aquí implementas login con Google
                          },
                          icon: Image.network(
                            "assets/images/g-logo.png",
                            height: 20,
                          ),
                          label: const Text(
                            "Google",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
    );
  }
}
