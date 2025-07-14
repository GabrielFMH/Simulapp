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
        appBar: AppBar(
            title: const Text('Examen de Inglés',
                style: TextStyle(color: Colors.black))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Examen de Inglés',
                style: TextStyle(color: Colors.black))),
        body: Center(
            child: Text(viewModel.errorMessage!,
                style: const TextStyle(color: Colors.black))),
      );
    }

    final currentQuestion = viewModel.currentQuestion;
    if (currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Examen de Inglés',
                style: TextStyle(color: Colors.black))),
        body: const Center(
            child: Text('No hay preguntas disponibles',
                style: TextStyle(color: Colors.black))),
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
        title: Row(
          children: [
            Text(
              'Pregunta ${viewModel.currentQuestionIndex + 1} de ${viewModel.totalPreguntas}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LinearProgressIndicator(
                value: (viewModel.currentQuestionIndex + 1) /
                    viewModel.totalPreguntas,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 5,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 40, 175, 238),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.35, // Máximo 25% de la pantalla
              child: SingleChildScrollView(
                child: Text(
                  currentQuestion.enunciado,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: currentQuestion.opciones.map((opcion) {
                  final isSelected = viewModel.respuestaSeleccionada == opcion;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(255, 42, 181, 245)
                          : Colors.white,
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: RadioListTile<String>(
                      title: Text(opcion,
                          style: const TextStyle(color: Colors.black)),
                      value: opcion,
                      groupValue: viewModel.respuestaSeleccionada,
                      activeColor: Colors.white,
                      selectedTileColor: Colors.lightBlue,
                      onChanged: (value) {
                        print('Opción seleccionada: $value');
                        viewModel.seleccionarRespuesta(value);
                      },
                    ),
                  );
                }).toList(),
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.lightBlue,
              ),
              child: const Text('Enviar respuesta',
                  style: TextStyle(color: Colors.lightBlue)),
            ),
            const SizedBox(height: 20),
            Text('Puntaje: ${viewModel.puntaje}',
                style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
