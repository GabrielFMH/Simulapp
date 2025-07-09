import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadQuestions(List<Map<String, dynamic>> questions) async {
  final CollectionReference questionsCollection = FirebaseFirestore.instance.collection('questions');

  for (var question in questions) {
    await questionsCollection.add(question);
  }
}

void main() async {
  List<Map<String, dynamic>> preguntas = [
    {
      'enunciado': '¿Cuál es la capital de Francia?',
      'tipo': 'opción múltiple',
      'opciones': ['París', 'Londres', 'Madrid']
    },
    {
      'enunciado': '¿Cuál es la fórmula química del agua?',
      'tipo': 'respuesta corta',
      'opciones': ['H2O']
    },
  ];

  await uploadQuestions(preguntas);
}