import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pregunta_model.dart';

class QuestionViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String tipoExamen;
  int _currentQuestionIndex = 0;
  double _puntaje = 0.0; // Changed to double to handle decimals
  int _totalPreguntas = 0;
  double _puntosPorPregunta = 0.0; // Changed to double
  bool _isLoading = true;
  String? _errorMessage;
  List<Question> _preguntas = [];
  String? _respuestaSeleccionada;
  final List<String?> _respuestasSeleccionadas = [];
  bool _examenFinalizado = false;

  QuestionViewModel(this.tipoExamen) {
    _cargarPreguntas();
  }

  int get currentQuestionIndex => _currentQuestionIndex;
  double get puntaje => _puntaje; // Changed to double
  int get totalPreguntas => _totalPreguntas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Question? get currentQuestion =>
      _preguntas.isNotEmpty ? _preguntas[_currentQuestionIndex] : null;
  List<String?> get respuestasSeleccionadas => _respuestasSeleccionadas;
  String? get respuestaSeleccionada => _respuestaSeleccionada;
  List<Question> get preguntas => _preguntas;
  bool get examenFinalizado => _examenFinalizado;

  Future<void> _cargarPreguntas() async {
    try {
      print('Cargando preguntas para el examen: $tipoExamen');
      QuerySnapshot querySnapshot = await _firestore
          .collection('preguntas')
          .where('examen', isEqualTo: tipoExamen)
          .limit(30)
          .get();

      print('Número de preguntas encontradas: ${querySnapshot.docs.length}');

      if (querySnapshot.docs.isEmpty) {
        _errorMessage = 'No se encontraron preguntas para este tipo de examen';
      } else {
        _preguntas = querySnapshot.docs
            .map((doc) => Question.fromFirestore(doc))
            .toList();
        _totalPreguntas = _preguntas.length;
        _puntosPorPregunta = 20 / (_totalPreguntas > 0 ? _totalPreguntas : 1);
      }
    } catch (e) {
      print('Error al cargar preguntas: $e');
      _errorMessage = 'Error al cargar las preguntas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void seleccionarRespuesta(String? respuesta) {
    _respuestaSeleccionada = respuesta;
    print('Respuesta seleccionada: $_respuestaSeleccionada');
    notifyListeners();
  }

  void evaluarRespuesta() {
    print(
        'Evaluando respuesta. Índice actual: $_currentQuestionIndex, Total: $_totalPreguntas, Respuesta seleccionada: $_respuestaSeleccionada');
    try {
      if (_respuestaSeleccionada != null && currentQuestion != null) {
        // Normalizar las cadenas para comparación (quitar espacios y convertir a minúsculas)
        final selected = _respuestaSeleccionada!.trim().toLowerCase();
        final correct = currentQuestion!.respuesta.trim().toLowerCase();
        print('Comparando: Seleccionada="$selected", Correcta="$correct"');
        if (selected == correct) {
          _puntaje += _puntosPorPregunta; // Add full decimal value
          print('Respuesta correcta, puntaje actualizado a $_puntaje');
        } else {
          print('Respuesta incorrecta, no se resta puntaje');
        }
        _respuestasSeleccionadas.add(_respuestaSeleccionada);
        _siguientePregunta();
      } else {
        print('Error: Respuesta seleccionada o currentQuestion es null');
      }
    } catch (e) {
      print('Excepción en evaluarRespuesta: $e');
    }
  }

  void _siguientePregunta() {
    print(
        'Intentando avanzar. Índice: $_currentQuestionIndex, Total: $_totalPreguntas');
    if (_currentQuestionIndex < _totalPreguntas - 1) {
      _currentQuestionIndex++;
      _respuestaSeleccionada = null;
      print(
          'Avanzando a pregunta ${_currentQuestionIndex + 1} de $totalPreguntas');
      notifyListeners();
    } else {
      _finalizarExamen();
    }
  }

  void _finalizarExamen() {
    double puntajeMinimoParaAprobar = 0.55 * 20;
    _examenFinalizado = true;
    print(
        'Examen finalizado. Puntaje: $_puntaje, Aprobado: ${_puntaje >= puntajeMinimoParaAprobar}');
    notifyListeners();
  }
}
