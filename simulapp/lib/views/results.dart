import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/result_viewmodel.dart';

class ResumenScreen extends StatelessWidget {
  final List<Map<String, dynamic>> preguntas;
  final List<String?> respuestasSeleccionadas;
  final double puntaje;
  final bool aprobado;

  const ResumenScreen({
    super.key,
    required this.preguntas,
    required this.respuestasSeleccionadas,
    required this.puntaje,
    required this.aprobado,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResultViewModel(
        preguntas: preguntas,
        respuestasSeleccionadas: respuestasSeleccionadas,
        puntaje: puntaje,
        aprobado: aprobado,
      ),
      child: const _ResumenScreenContent(),
    );
  }
}

class _ResumenScreenContent extends StatelessWidget {
  const _ResumenScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ResultViewModel>(context);

    if (viewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Resumen del Examen',
                style: TextStyle(color: Colors.black))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final result = viewModel.result;
    final totalQuestions = result.preguntas.length;
    final correctAnswers =
        result.puntaje; // Assuming puntaje is the number of correct answers
    final percentageCorrect =
        totalQuestions > 0 ? (correctAnswers / totalQuestions).toDouble() : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Examen',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Porcentaje de aciertos:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            // Donut chart for percentage of correct answers
            SizedBox(
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: percentageCorrect.clamp(
                          0.0, 1.0), // Ensure value is between 0.0 and 1.0
                      backgroundColor: Colors.red,
                      color:
                          percentageCorrect <= 0.5 ? Colors.green : Colors.red,
                      strokeWidth: 10,
                    ),
                  ),
                  Text(
                    '${(percentageCorrect * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Respuestas Incorrectas',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: result.preguntas.length,
                itemBuilder: (context, index) {
                  final pregunta = result.preguntas[index];
                  final respuestaCorrecta = pregunta.respuesta;
                  final respuestaUsuario =
                      result.respuestasSeleccionadas[index];

                  if (respuestaUsuario != respuestaCorrecta &&
                      respuestaUsuario != null) {
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.lightBlue),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pregunta ${index + 1}: ${pregunta.enunciado}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tu respuesta: $respuestaUsuario',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              'Correcta: $respuestaCorrecta',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // No mostrar si es correcta
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
