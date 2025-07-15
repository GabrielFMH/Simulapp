import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';
import '../services/google_auth.dart'; // Importa el servicio de autenticación de Google
import '../viewmodels/examen_list_viewmodel.dart'; // Importa el ViewModel de la lista de exámenes
import 'examen_list.dart'; // Importa la pantalla de la lista de exámenes

// Convertimos RegisterPage a StatefulWidget para gestionar el estado de GoogleAuth
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Instancia de GoogleAuth para la autenticación con Google
  final GoogleAuth _googleAuth = GoogleAuth();

  @override
  void dispose() {
    // Asegúrate de liberar los recursos de GoogleAuth cuando el widget se descarte
    _googleAuth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definir un ancho común para los botones para mantener la consistencia visual
    const double commonButtonWidth = 250.0; // Ajusta este valor si es necesario

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
                    // Botón de registro normal
                    SizedBox(
                      width: commonButtonWidth, // Aplica el ancho común
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                final error = await viewModel.registerUser();
                                if (error == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'User registered successfully')),
                                  );
                                  // Navegar a la pantalla de exámenes o a la pantalla de login
                                  Navigator.pop(
                                      context); // Volver a la pantalla de login
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
                              vertical: 15), // Ajusta solo el padding vertical
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
                    ),
                    const SizedBox(height: 20),
                    // Nuevo botón para "Registrarse con Google"
                    SizedBox(
                      width: commonButtonWidth, // Aplica el ancho común
                      child: ElevatedButton(
                        onPressed: () async {
                          // Ahora `error` contendrá el mensaje de error o será null si fue exitoso
                          final String? error = await _googleAuth.signIn();
                          if (error == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Registro con Google exitoso')),
                            );
                            // Navegar a la pantalla de exámenes después del registro exitoso con Google
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
                              SnackBar(
                                  content: Text(
                                      'Error al registrarse con Google: $error')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Fondo negro
                          foregroundColor: Colors.white, // Texto/iconos blancos
                          padding: const EdgeInsets.symmetric(
                              vertical: 15), // Ajusta solo el padding vertical
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.webp', // Asegúrate de que esta ruta sea correcta
                              height: 24,
                              width: 24,
                              // color: Colors.white, // Descomenta si tu logo de Google no es blanco y necesitas teñirlo
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Registrarse con Google',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
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
