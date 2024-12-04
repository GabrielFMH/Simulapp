import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actualmente autenticado
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No hay un usuario logueado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // Referencia al documento del usuario en Firestore
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDoc.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Información del usuario no encontrada',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Extraer datos del usuario
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String email = userData['email'] ?? 'Sin email';
          final String username = userData['username'] ?? 'Sin nombre';
          final DateTime? createdAt = userData['createdAt'] != null
              ? (userData['createdAt'] as Timestamp).toDate()
              : null;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar y detalles del usuario
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  username,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Creado el: ${createdAt != null ? createdAt.toLocal().toString().split(' ')[0] : 'Desconocido'}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Divider(),
                // Título de simulacros recientes
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Simulacros recientes',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 10),
                // Simulacros recientes
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(
                            'historial') // Asegúrate del nombre correcto
                        .where('userId', isEqualTo: currentUser.uid)
                        .orderBy('fecha', descending: true)
                        .limit(3) // Mostrar solo los últimos 3
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay simulacros recientes',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        );
                      }

                      final simulacros = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: simulacros.length,
                        itemBuilder: (context, index) {
                          final simulacro =
                              simulacros[index].data() as Map<String, dynamic>;
                          final String examenId =
                              simulacro['examenId'] ?? 'ID desconocido';
                          final DateTime? fecha = simulacro['fecha'] != null
                              ? (simulacro['fecha'] as Timestamp).toDate()
                              : null;

                          return ListTile(
                            leading: const Icon(Icons.quiz, color: Colors.blueAccent),
                            title: Text(
                              'Examen: $examenId',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Fecha: ${fecha != null ? fecha.toLocal().toString().split(' ')[0] : 'Desconocida'}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProfile(),
  ));
}
