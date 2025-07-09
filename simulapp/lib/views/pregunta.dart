// lib/views/examen_screen.dart
import 'package:flutter/material.dart';
import '../viewmodels/pregunta_viewmodel.dart';
import 'package:provider/provider.dart';
import 'results.dart';

class ExamenScreen extends StatelessWidget {
  final String tipoExamen;
  final String modo;

  const ExamenScreen({super.key, required this.tipoExamen, required this.modo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuestionViewModel(tipoExamen),
      child: const _ExamenScreenContent(),
    );
  }
}

class _ExamenScreenContent extends StatefulWidget {
  const _ExamenScreenContent();

  @override
  _ExamenScreenContentState createState() => _ExamenScreenContentState();
}

class _ExamenScreenContentState extends State<_ExamenScreenContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<QuestionViewModel>(context, listen: false);
    if (viewModel.examenFinalizado) {
      print('Detectado examen finalizado en didChangeDependencies');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final preguntas = viewModel.preguntas
            .map((q) => {
                  'enunciado': q.enunciado,
                  'opciones': q.opciones,
                  'respuesta': q.respuesta,
                })
            .toList();
        final respuestasSeleccionadas = viewModel.respuestasSeleccionadas;
        final puntaje = viewModel.puntaje;
        final aprobado = puntaje >= 0.55 * 20;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResumenScreen(
              preguntas: preguntas,
              respuestasSeleccionadas: respuestasSeleccionadas,
              puntaje: puntaje,
              aprobado: aprobado,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestionViewModel>(context);
    print(
        'Building screen. Current index: ${viewModel.currentQuestionIndex}, Total: ${viewModel.totalPreguntas}, Finalizado: ${viewModel.examenFinalizado}');

    if (viewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Examen de Inglés')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Examen de Inglés')),
        body: Center(child: Text(viewModel.errorMessage!)),
      );
    }

    final currentQuestion = viewModel.currentQuestion;
    if (currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Examen de Inglés')),
        body: const Center(child: Text('No hay preguntas disponibles')),
      );
    }

    if (viewModel.examenFinalizado && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('Forzando navegación a ResumenScreen desde build');
        final preguntas = viewModel.preguntas
            .map((q) => {
                  'enunciado': q.enunciado,
                  'opciones': q.opciones,
                  'respuesta': q.respuesta,
                })
            .toList();
        final respuestasSeleccionadas = viewModel.respuestasSeleccionadas;
        final puntaje = viewModel.puntaje;
        final aprobado = puntaje >= 0.55 * 20;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResumenScreen(
              preguntas: preguntas,
              respuestasSeleccionadas: respuestasSeleccionadas,
              puntaje: puntaje,
              aprobado: aprobado,
            ),
          ),
        );
      });
    }

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
                  onChanged: (value) {
                    print('Opción seleccionada: $value');
                    viewModel.seleccionarRespuesta(value);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(
                    'Botón "Enviar respuesta" presionado. Índice: ${viewModel.currentQuestionIndex}');
                if (viewModel.respuestaSeleccionada != null) {
                  viewModel.evaluarRespuesta();
                } else {
                  print('No se seleccionó ninguna respuesta');
                }
              },
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
