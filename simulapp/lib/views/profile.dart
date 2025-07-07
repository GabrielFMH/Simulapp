import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../models/profile_model.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: _UserProfileContent(),
    );
  }
}

class _UserProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ValueListenableBuilder<UserProfileData?>(
          valueListenable: viewModel.userProfile,
          builder: (context, userProfile, child) {
            if (userProfile == null) {
              return const Center(
                child: Text(
                  'No hay un usuario logueado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

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
                      userProfile.username[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userProfile.username,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userProfile.email,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Creado el: ${userProfile.createdAt != null ? userProfile.createdAt!.toLocal().toString().split(' ')[0] : 'Desconocido'}',
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
                  // Mostrar los simulacros recientes
                  ValueListenableBuilder<List<ExamHistory>>(
                    valueListenable: viewModel.examHistory,
                    builder: (context, historial, child) {
                      if (historial.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay simulacros recientes.',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: historial.length,
                          itemBuilder: (context, index) {
                            final examen = historial[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    examen.nombreExamen,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat(
                                            'd \'de\' MMMM \'de\' yyyy, h:mm:ss a \'UTC-5\'')
                                        .format(examen.fecha),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
