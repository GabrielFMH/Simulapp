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
  final TextEditingController _respuestaController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _puntosController = TextEditingController();
  final TextEditingController _tiempoLimiteController = TextEditingController();
  final List<TextEditingController> _opcionesControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _enunciadoController.dispose();
    _respuestaController.dispose();
    _tipoController.dispose();
    _puntosController.dispose();
    _tiempoLimiteController.dispose();
    for (var controller in _opcionesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Función para agregar una nueva pregunta a la subcolección 'preguntas'
  void _agregarPregunta() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Reemplazar 'examenID' con el ID del examen correspondiente
        await _firestore
            .collection('examenes')  // Colección de exámenes
            .doc('examenID')  // Documento del examen (reemplazar con el ID dinámico)
            .collection('preguntas')  // Subcolección de preguntas
            .add({
          'enunciado': _enunciadoController.text,
          'opciones': _opcionesControllers.map((c) => c.text).toList(),
          'respuesta': _respuestaController.text,
          'tipo': _tipoController.text,
          'puntos': int.tryParse(_puntosController.text) ?? 0,
          'tiempo_limite': int.tryParse(_tiempoLimiteController.text) ?? 30,
        });

        // Limpiar los campos después de agregar la pregunta
        _enunciadoController.clear();
        for (var controller in _opcionesControllers) {
          controller.clear();
        }
        _respuestaController.clear();
        _tipoController.clear();
        _puntosController.clear();
        _tiempoLimiteController.clear();

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
                decoration:
                    const InputDecoration(labelText: 'Respuesta correcta'),
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
              TextFormField(
                controller: _puntosController,
                decoration: const InputDecoration(labelText: 'Puntos'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa los puntos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tiempoLimiteController,
                decoration: const InputDecoration(labelText: 'Tiempo límite (segundos)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el tiempo límite';
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
