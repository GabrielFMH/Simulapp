import 'package:flutter/material.dart';
import 'maps.dart'; // Asegúrate de importar tu archivo maps.dart
import 'prices.dart';
import 'calendar.dart'; // Importa el archivo calendar.dart
import 'examlist.dart'; // Importa el archivo examlist.dart
import 'preguntas_screen.dart';



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
    // Aquí puedes definir descripciones adicionales para cada examen, basándote en el nombre del examen
    String descripcionCompleta = descripcion;

    if (nombre == 'C1 Advanced (CAE)') {
      descripcionCompleta =
          'El C1 Advanced (CAE) es un examen avanzado de inglés diseñado para estudiantes que desean demostrar habilidades de alto nivel en el idioma. Incluye comprensión auditiva, expresión escrita, y gramática avanzada, entre otras secciones. Es ideal para quienes buscan estudiar o trabajar en un entorno de habla inglesa.';
    } else if (nombre == 'C2 Proficiency (CPE)') {
      descripcionCompleta =
          'El C2 Proficiency (CPE) es el examen más avanzado de inglés, que mide la capacidad de entender y producir textos complejos en inglés. Este examen está dirigido a personas que desean demostrar un dominio total del idioma en un entorno académico o profesional.';
    } else if (nombre == 'ECCE') {
      descripcionCompleta =
          'El ECCE (Examination for the Certificate of Competency in English) es un examen de inglés que certifica una competencia intermedia-alta en el idioma. Está dirigido a personas que necesitan demostrar que pueden manejar el inglés en situaciones cotidianas y laborales.';
    } else if (nombre == 'ECPE') {
      descripcionCompleta =
          'El ECPE (Examination for the Certificate of Proficiency in English) es un examen de inglés de nivel avanzado que evalúa las habilidades lingüísticas necesarias para un contexto académico o profesional de alto nivel. Es ideal para quienes quieren demostrar un excelente manejo del inglés.';
    } else if (nombre == 'TOEFL iBT') {
      descripcionCompleta =
          'El TOEFL iBT (Test of English as a Foreign Language - Internet Based Test) es un examen reconocido internacionalmente que mide la capacidad de usar y entender inglés en un entorno académico, especialmente en universidades y centros de estudios en países de habla inglesa.';
    } else if (nombre == 'TOEFL ITP') {
      descripcionCompleta =
          'El TOEFL ITP (Institutional Testing Program) es una variante del examen TOEFL diseñada para medir las habilidades de comprensión auditiva, gramática y comprensión lectora en inglés, utilizada por instituciones educativas y empresas para evaluar el nivel de inglés de los candidatos.';
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
            // Imagen del examen
            Image.asset(
              imagen,
              height: 650,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Descripción más completa del examen
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                descripcionCompleta,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Botones de Contrareloj y Modo Chill
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreguntasScreen(examenId: 'KoXMWUvT8UdQf1TWaH2b/preguntas/tBr2dx5QT2mRRSKx71QN'),
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
                          builder: (context) => PreguntasScreen(examenId: examenId),
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
