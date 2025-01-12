import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore

class PreguntasScreen extends StatefulWidget {
  final String examenId; // Recibir el ID del examen

  const PreguntasScreen({super.key, required this.examenId});

  @override
  _PreguntasScreenState createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas del Examen ${widget.examenId}'),
        backgroundColor: Colors.blue, // Color de la barra de título
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Escuchar los cambios en la subcolección 'preguntas' del examen
        stream: firestore
            .collection('examenes')
            .doc(widget.examenId)
            .collection('preguntas')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar preguntas.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final preguntas = snapshot.data?.docs;

          if (preguntas == null || preguntas.isEmpty) {
            return const Center(
              child: Text('No hay preguntas disponibles para este examen.'),
            );
          }

          return ListView.builder(
            itemCount: preguntas.length,
            itemBuilder: (context, index) {
              var pregunta = preguntas[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(pregunta['enunciado']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipo: ${pregunta['tipo']}'),
                      Text('Opciones: ${pregunta['opciones'].join(', ')}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
