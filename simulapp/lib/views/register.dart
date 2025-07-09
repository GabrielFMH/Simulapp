import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Colors.lightBlue, // Fondo celeste
            appBar: AppBar(
              backgroundColor: Colors.lightBlue, // Color celeste para el AppBar
              elevation: 0, // Elimina la sombra para un diseño más limpio
            ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Letras blancas para contraste
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Practice your Michigan, Cambridge and TOEFL exams',
                      textAlign: TextAlign.center, // Centrar el texto
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Letras blancas para contraste
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: viewModel.usernameController,
                      style: const TextStyle(
                          color: Colors.black), // Texto negro para contraste
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Fondo blanco
                        labelText: 'Username',
                        labelStyle: TextStyle(
                            color: Colors.black54), // Etiqueta gris oscuro
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: Colors.black54),
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
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          color: Colors.black), // Texto negro para contraste
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Fondo blanco
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.black54), // Etiqueta gris oscuro
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
                      controller: viewModel.passwordController,
                      obscureText: true,
                      style: const TextStyle(
                          color: Colors.black), // Texto negro para contraste
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Fondo blanco
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color: Colors.black54), // Etiqueta gris oscuro
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
                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              final error = await viewModel.registerUser();
                              if (error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('User registered successfully')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $error')),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Botón blanco
                        foregroundColor:
                            Colors.lightBlue, // Texto/iconos celeste
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.lightBlue) // Indicador celeste
                          : const Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.lightBlue),
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
