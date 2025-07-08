// lib/views/examen_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/viewmodels/pregunta_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../src/iu/results.dart';
import '../../firebase_options.dart';
import '../models/pregunta_model.dart';

class ExamenScreen extends StatelessWidget {
  final String tipoExamen;

  const ExamenScreen({super.key, required this.tipoExamen, required String modo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuestionViewModel(tipoExamen),
      child: const _ExamenScreenContent(),
    );
  }
}

class _ExamenScreenContent extends StatelessWidget {
  const _ExamenScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestionViewModel>(context);

    // Estado de carga
    if (viewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Examen de Inglés')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Estado de error
    if (viewModel.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Examen de Inglés')),
        body: Center(child: Text(viewModel.errorMessage!)),
      );
    }

    // Verificar si hay preguntas disponibles
    final currentQuestion = viewModel.currentQuestion;
    if (currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Examen de Inglés')),
        body: const Center(child: Text('No hay preguntas disponibles')),
      );
    }

    // Mostrar la pregunta actual
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Pregunta ${viewModel.currentQuestionIndex + 1} de ${viewModel.totalPreguntas}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.enunciado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              children: currentQuestion.opciones.map((opcion) {
                return RadioListTile<String>(
                  title: Text(opcion),
                  value: opcion,
                  groupValue: viewModel.respuestaSeleccionada,
                  onChanged: (value) => viewModel.seleccionarRespuesta(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModel.respuestaSeleccionada != null
                  ? viewModel.evaluarRespuesta
                  : null,
              child: const Text('Enviar respuesta'),
            ),
            const SizedBox(height: 20),
            Text('Puntaje: ${viewModel.puntaje}'),
          ],
        ),
      ),
    );
  }
}
