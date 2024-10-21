import 'package:flutter/material.dart';

class ResumenScreen extends StatelessWidget {
  final List<Map<String, dynamic>> preguntas;
  final List<String?> respuestasSeleccionadas;
  final int puntaje;
  final bool aprobado;

  const ResumenScreen({super.key, 
    required this.preguntas,
    required this.respuestasSeleccionadas,
    required this.puntaje,
    required this.aprobado,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Examen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado del resultado
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: aprobado ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: aprobado ? Colors.green : Colors.red,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resultado: ${aprobado ? "Aprobado" : "Desaprobado"}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: aprobado ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Puntaje: $puntaje/20',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: preguntas.length,
                itemBuilder: (context, index) {
                  final pregunta = preguntas[index];
                  final respuestaCorrecta = pregunta['respuesta'];
                  final respuestaUsuario = respuestasSeleccionadas[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pregunta ${index + 1}:',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pregunta['enunciado'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Respuesta seleccionada: ${respuestaUsuario ?? "No respondida"}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Respuesta correcta: $respuestaCorrecta',
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 8),
                          if (respuestaUsuario == respuestaCorrecta)
                            const Text(
                              'Respuesta Correcta',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            )
                          else
                            const Text(
                              'Respuesta Incorrecta',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
