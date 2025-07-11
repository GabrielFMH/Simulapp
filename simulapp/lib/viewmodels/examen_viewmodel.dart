// lib/viewmodels/exam_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/examen_model.dart';

class ExamViewModel extends ChangeNotifier {
  final Examen examen;
  String tipoExamen = '';

  ExamViewModel(this.examen);

  Future<void> registrarEnHistorial(String modo) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }
      final String userId = user.uid;

      await FirebaseFirestore.instance.collection('historial').add({
        'userId': userId,
        'examenId': examen.examenId,
        'nombreExamen': examen.nombre,
        'fecha': DateTime.now(),
        'modo': modo,
        'tipoExamen': tipoExamen,
      });
      print('Registro guardado en historial.');
    } catch (e) {
      print('Error al guardar en historial: $e');
    }
  }

  void setTipoExamen(String value) {
    tipoExamen = value;
    notifyListeners();
  }
}