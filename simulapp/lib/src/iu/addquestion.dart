import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agregar Preguntas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AgregarPreguntaScreen(),
    );
  }
}

class AgregarPreguntaScreen extends StatefulWidget {
  const AgregarPreguntaScreen({super.key});

  @override
  _AgregarPreguntaScreenState createState() => _AgregarPreguntaScreenState();
}

class _AgregarPreguntaScreenState extends State<AgregarPreguntaScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controladores para los campos del formulario
  final TextEditingController _enunciadoController = TextEditingController();
  final TextEditingController _examenController = TextEditingController();
  final TextEditingController _respuestaController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final List<TextEditingController> _opcionesControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _enunciadoController.dispose();
    _examenController.dispose();
    _respuestaController.dispose();
    _tipoController.dispose();
    for (var controller in _opcionesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Función para agregar una nueva pregunta a Firestore
  void _agregarPregunta() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('preguntas').add({
          'enunciado': _enunciadoController.text,
          'examen': _examenController.text,
          'opciones': _opcionesControllers.map((c) => c.text).toList(),
          'respuesta': _respuestaController.text,
          'tipo': _tipoController.text,
        });

        // Limpiar los campos después de agregar la pregunta
        _enunciadoController.clear();
        _examenController.clear();
        for (var controller in _opcionesControllers) {
          controller.clear();
        }
        _respuestaController.clear();
        _tipoController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pregunta agregada exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar la pregunta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pregunta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _enunciadoController,
                decoration: const InputDecoration(labelText: 'Enunciado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el enunciado';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _examenController,
                decoration: const InputDecoration(labelText: 'Examen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el examen';
                  }
                  return null;
                },
              ),
              ..._opcionesControllers.asMap().entries.map((entry) {
                int index = entry.key;
                return TextFormField(
                  controller: entry.value,
                  decoration: InputDecoration(labelText: 'Opción ${index + 1}'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la opción ${index + 1}';
                    }
                    return null;
                  },
                );
              }),
              TextFormField(
                controller: _respuestaController,
                decoration: const InputDecoration(labelText: 'Respuesta correcta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la respuesta correcta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el tipo de pregunta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarPregunta,
                child: const Text('Agregar Pregunta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
