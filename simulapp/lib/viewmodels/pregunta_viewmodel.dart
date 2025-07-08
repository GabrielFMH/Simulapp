// lib/viewmodels/question_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pregunta_model.dart';

class QuestionViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String tipoExamen;
  int _currentQuestionIndex = 0;
  int _puntaje = 0;
  int _totalPreguntas = 0;
  double _puntosPorPregunta = 0;
  bool _isLoading = true;
  String? _errorMessage;
  List<Question> _preguntas = [];
  String? _respuestaSeleccionada;
  final List<String?> _respuestasSeleccionadas = [];

  QuestionViewModel(this.tipoExamen) {
    _cargarPreguntas();
  }

  int get currentQuestionIndex => _currentQuestionIndex;
  int get puntaje => _puntaje;
  int get totalPreguntas => _totalPreguntas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Question? get currentQuestion =>
      _preguntas.isNotEmpty ? _preguntas[_currentQuestionIndex] : null;
  List<String?> get respuestasSeleccionadas => _respuestasSeleccionadas;
  String? get respuestaSeleccionada => _respuestaSeleccionada;
  List<Question> get preguntas => _preguntas;

  Future<void> _cargarPreguntas() async {
    try {
      print('Cargando preguntas para el examen: $tipoExamen');
      QuerySnapshot querySnapshot = await _firestore
          .collection('preguntas')
          .where('examen', isEqualTo: tipoExamen)
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
    notifyListeners();
  }

  void evaluarRespuesta() {
    if (_respuestaSeleccionada == currentQuestion?.respuesta) {
      _puntaje += _puntosPorPregunta.toInt();
    } else {
      _puntaje -= 1;
    }
    _respuestasSeleccionadas.add(_respuestaSeleccionada);
    _siguientePregunta();
  }

  void _siguientePregunta() {
    if (_currentQuestionIndex < _totalPreguntas - 1) {
      _currentQuestionIndex++;
      _respuestaSeleccionada = null;
      notifyListeners();
    } else {
      _finalizarExamen();
    }
  }

  void _finalizarExamen() {
    double puntajeMinimoParaAprobar = 0.55 * 20;
    bool aprobado = _puntaje >= puntajeMinimoParaAprobar;
    // Navigation handled in View
  }
}
