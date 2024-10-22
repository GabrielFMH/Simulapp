import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register.dart';  // Importa la página de registro
import 'examlist.dart';  // Importa la página de examlist

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      // Iniciar sesión con Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Obtener datos adicionales del usuario desde Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        print("User data: ${userDoc.data()}");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successful')));

        // Redirigir a la página de lista de exámenes
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExamenesScreen()),  // Cambia ExamList por ExamenesScreen
        );
      } else {
        print("User not found in Firestore.");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User not found in Firestore')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SimulApp'),
        backgroundColor: Colors.lightBlue,  // Color celeste para el AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 100, color: Colors.blue),  // Icono azul
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,  // Texto azul
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,  // Color celeste para el botón
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navegar a la página de registro
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: const Text(
                  'No account? Register here',
                  style: TextStyle(color: Colors.blue),  // Texto del botón azul
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
