// lib/models/result_model.dart
import 'pregunta_model.dart';

class Result {
  final List<Question> preguntas;
  final List<String?> respuestasSeleccionadas;
  final double puntaje;
  final bool aprobado;

  Result({
    required this.preguntas,
    required this.respuestasSeleccionadas,
    required this.puntaje,
    required this.aprobado,
  });
}
