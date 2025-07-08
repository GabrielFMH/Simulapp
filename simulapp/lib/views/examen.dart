// lib/views/exam_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/examen_viewmodel.dart'; // Adjust path
//import '../src/iu/question.dart';
import 'pregunta.dart';
import '../models/examen_model.dart';



class ExamenDetalleScreen extends StatelessWidget {
  final Examen examen;

  const ExamenDetalleScreen({
    super.key,
    required this.examen,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamViewModel(examen),
      child: const _ExamenDetalleScreenContent(),
    );
  }
}

class _ExamenDetalleScreenContent extends StatelessWidget {
  const _ExamenDetalleScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExamViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.examen.nombre),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              viewModel.examen.imagen,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                viewModel.examen.descripcion,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await viewModel.registrarEnHistorial('Contrareloj');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamenScreen(
                            tipoExamen: viewModel.examen.examenId, // Usar examenId
                            modo: 'Contrareloj', // Modo como parámetro adicional
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text(
                      'Contrareloj',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await viewModel.registrarEnHistorial('Modo Prueba');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamenScreen(
                            tipoExamen: viewModel.examen.examenId, // Usar examenId
                            modo: 'Modo Prueba', // Modo como parámetro adicional
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      'Modo Prueba',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}