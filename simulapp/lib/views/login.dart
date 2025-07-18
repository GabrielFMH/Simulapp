import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/examen_list_viewmodel.dart';
import 'examen_list.dart';
import 'register.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = LoginViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 186, 253), // Fondo celeste

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'SimulApp',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Letras blancas para contraste
                ),
              ),
              const Text(
                'Practice your Michigan,Cambridge and Toelf exams',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Letras blancas para contraste
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.black), // Texto negro para contraste
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white, // Fondo blanco
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Colors.black54), // Etiqueta gris oscuro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(
                    color: Colors.black), // Texto negro para contraste
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white, // Fondo blanco
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Colors.black54), // Etiqueta gris oscuro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ValueListenableBuilder<bool>(
                valueListenable: _viewModel.isLoading,
                builder: (context, isLoading, _) {
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final success = await _viewModel.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login exitoso')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (_) => ExamenListViewModel(),
                                    child: const ExamenesScreen(),
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error al iniciar sesión')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Botón blanco
                      foregroundColor: Colors.lightBlue, // Texto/iconos celeste
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.lightBlue) // Indicador celeste
                        : const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, color: Colors.lightBlue),
                          ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  'No account? Register here',
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
