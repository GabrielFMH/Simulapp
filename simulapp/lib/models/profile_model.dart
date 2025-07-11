import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileData {
  final String email;
  final String username;
  final DateTime? createdAt;

  UserProfileData({
    required this.email,
    required this.username,
    this.createdAt,
  });

  factory UserProfileData.fromMap(Map<String, dynamic> data) {
    return UserProfileData(
      email: data['email'] ?? 'Sin email',
      username: data['username'] ?? 'Sin nombre',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}

class ExamHistory {
  final String nombreExamen;
  final DateTime fecha;

  ExamHistory({
    required this.nombreExamen,
    required this.fecha,
  });

  factory ExamHistory.fromMap(Map<String, dynamic> data) {
    return ExamHistory(
      nombreExamen: data['nombreExamen'] ?? 'Desconocido',
      fecha: (data['fecha'] as Timestamp).toDate(),
    );
  }
}