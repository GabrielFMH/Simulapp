import 'package:flutter/material.dart';
import 'maps.dart'; // Asegúrate de importar tu archivo maps.dart
import 'prices.dart';
import 'calendar.dart'; // Importa el archivo calendar.dart
import 'examlist.dart'; // Importa el archivo examlist.dart
import 'question.dart'; // Importa el archivo question.dart para acceder a ExamenScreen

class ExamenDetalleScreen extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String imagen;
  final String examenId; // Asegúrate de tener el ID del examen

  const ExamenDetalleScreen({
    Key? key,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.examenId, // Recibir el ID del examen
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String descripcionCompleta = descripcion;

    // Mapeo de nombres a tipos de examen para coincidir con Firebase
    String tipoExamen = '';

    if (nombre == 'C1 Advanced (CAE)') {
      tipoExamen = 'CAE';
      descripcionCompleta =
          'El C1 Advanced (CAE) es un examen avanzado de inglés diseñado para estudiantes que desean demostrar habilidades de alto nivel en el idioma. Incluye comprensión auditiva, expresión escrita, y gramática avanzada, entre otras secciones. Es ideal para quienes buscan estudiar o trabajar en un entorno de habla inglesa.';
    } else if (nombre == 'C2 Proficiency (CPE)') {
      tipoExamen = 'CPE';
      descripcionCompleta =
          'El C2 Proficiency (CPE) es el examen más avanzado de inglés, que mide la capacidad de entender y producir textos complejos en inglés. Este examen está dirigido a personas que desean demostrar un dominio total del idioma en un entorno académico o profesional.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagen,
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
                descripcionCompleta,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamenScreen(tipoExamen: tipoExamen),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamenScreen(tipoExamen: tipoExamen),
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
