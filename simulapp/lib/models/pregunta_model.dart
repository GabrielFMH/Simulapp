// lib/models/question_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String enunciado;
  final List<String> opciones;
  final String respuesta;
  final String tipo;
  final String examen;

  Question({
    required this.enunciado,
    required this.opciones,
    required this.respuesta,
    required this.tipo,
    required this.examen,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Question(
      enunciado: data['enunciado'] ?? '',
      opciones: List<String>.from(data['opciones'] ?? []),
      respuesta: data['respuesta'] ?? '',
      tipo: data['tipo'] ?? '',
      examen: data['examen'] ?? '',
    );
  }
}