import 'dart:convert';
// Verifica si esta conexión es necesaria
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Para leer el archivo JSON

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Verifica que Firebase esté bien configurado
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar JSON a Firestore')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => importData(context), // Pasa el contexto para mostrar el snackbar
          child: const Text('Importar Datos'),
        ),
      ),
    );
  }

  Future<void> importData(BuildContext context) async {
    try {
      // Cargar el archivo JSON
      final String response = await rootBundle.loadString('assets/data.json');
      final List<dynamic> data = json.decode(response);

      // Guardar datos en Firestore
      final firestore = FirebaseFirestore.instance;
      for (var item in data) {
        await firestore.collection('usuarios').add(item);
        print('Documento guardado: ${item['nombre']}');
      }

      // Mostrar notificación de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos importados con éxito.')),
      );
    } catch (e) {
      print('Error al importar los datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al importar los datos.')),
      );
    }
  }
}
