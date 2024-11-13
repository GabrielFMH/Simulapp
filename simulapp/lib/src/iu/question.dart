import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'results.dart';
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
      title: 'Examen de Inglés',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          buttonColor: Colors.blueAccent,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
    );
  }
}

class ExamenScreen extends StatefulWidget {
  final String tipoExamen; // Tipo de examen recibido

  const ExamenScreen({super.key, required this.tipoExamen});

  @override
  _ExamenScreenState createState() => _ExamenScreenState();
}

class _ExamenScreenState extends State<ExamenScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _puntaje = 0;
  int _totalPreguntas = 0;
  double _puntosPorPregunta = 0;
  bool _isLoading = true;

  List<DocumentSnapshot> _preguntas = [];
  Map<String, dynamic> _currentPregunta = {}; // Inicializado como un mapa vacío
  final List<String?> _respuestasSeleccionadas = [];
  String? _respuestaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  void _cargarPreguntas() async {
    try {
      // Filtrar preguntas por el tipo de examen
      print('Cargando preguntas para el examen: \${widget.tipoExamen}');
      QuerySnapshot querySnapshot = await _firestore
          .collection('preguntas')
          .where('examen', isEqualTo: widget.tipoExamen)
          .get();

      print('Número de preguntas encontradas: \${querySnapshot.docs.length}');

      setState(() {
        _preguntas = querySnapshot.docs;
        _totalPreguntas = _preguntas.length;
        _puntosPorPregunta = 20 / (_totalPreguntas > 0 ? _totalPreguntas : 1); // Evitar división por cero

        if (_preguntas.isNotEmpty) {
          _currentPregunta = _preguntas[_currentQuestionIndex].data() as Map<String, dynamic>;
        } else {
          print('No se encontraron preguntas para este examen.');
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar preguntas: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _evaluarRespuesta() {
    if (_respuestaSeleccionada == _currentPregunta['respuesta']) {
      _puntaje += _puntosPorPregunta.toInt();
    } else {
      _puntaje -= 1;
    }
    _respuestasSeleccionadas.add(_respuestaSeleccionada);
    _siguientePregunta();
  }

  void _siguientePregunta() {
    if (_currentQuestionIndex < _totalPreguntas - 1) {
      setState(() {
        _currentQuestionIndex++;
        _respuestaSeleccionada = null;
        _currentPregunta = _preguntas[_currentQuestionIndex].data() as Map<String, dynamic>;
      });
    } else {
      _finalizarExamen();
    }
  }

  void _finalizarExamen() {
    double puntajeMinimoParaAprobar = 0.55 * 20;
    bool aprobado = _puntaje >= puntajeMinimoParaAprobar;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResumenScreen(
          preguntas: _preguntas.map((doc) => doc.data() as Map<String, dynamic>).toList(),
          respuestasSeleccionadas: _respuestasSeleccionadas,
          puntaje: _puntaje,
          aprobado: aprobado,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Examen de Inglés'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Verificar si hay un enunciado disponible en la pregunta actual
    String enunciado = _currentPregunta['enunciado'] ?? 'Enunciado no disponible';

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${_currentQuestionIndex + 1} de $_totalPreguntas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              enunciado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              children: (_currentPregunta['opciones'] as List<dynamic>? ?? []).map((opcion) {
                return RadioListTile<String>(
                  title: Text(opcion),
                  value: opcion,
                  groupValue: _respuestaSeleccionada,
                  onChanged: (value) {
                    setState(() {
                      _respuestaSeleccionada = value;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _respuestaSeleccionada != null ? _evaluarRespuesta : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Enviar respuesta'),
            ),
            const SizedBox(height: 20),
            Text(
              'Puntaje: $_puntaje',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}