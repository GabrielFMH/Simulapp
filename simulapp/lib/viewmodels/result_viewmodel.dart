// lib/viewmodels/result_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/result_model.dart';
import '../models/pregunta_model.dart';

class ResultViewModel extends ChangeNotifier {
  late Result _result;
  bool _isLoading = false;

  ResultViewModel({
    required List<Map<String, dynamic>> preguntas,
    required List<String?> respuestasSeleccionadas,
    required double puntaje,
    required bool aprobado,
  }) {
    _initializeResult(preguntas, respuestasSeleccionadas, puntaje, aprobado);
  }

  Result get result => _result;
  bool get isLoading => _isLoading;

  void _initializeResult(List<Map<String, dynamic>> preguntas, List<String?> respuestasSeleccionadas, double puntaje, bool aprobado) {
    _isLoading = true;
    notifyListeners();

    try {
      // Convertir Map a List<Question> usando una lógica similar a fromFirestore
      final questionList = preguntas.map((map) => Question(
        enunciado: map['enunciado'] ?? '',
        opciones: List<String>.from(map['opciones'] ?? []),
        respuesta: map['respuesta'] ?? '',
        examen: map['examen'] ?? '', tipo: '',
      )).toList();

      _result = Result(
        preguntas: questionList,
        respuestasSeleccionadas: respuestasSeleccionadas,
        puntaje: puntaje,
        aprobado: aprobado,
      );
    } catch (e) {
      print('Error initializing result: $e');
      // Manejo de error (puedes establecer un estado de error si es necesario)
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}