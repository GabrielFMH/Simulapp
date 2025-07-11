import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile_model.dart';
import '../main.dart';

class ProfileViewModel extends ChangeNotifier {
  final ValueNotifier<UserProfileData?> userProfile = ValueNotifier(null);
  final ValueNotifier<List<ExamHistory>> examHistory = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ProfileViewModel() {
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      userProfile.value = null;
      examHistory.value = [];
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid);
      final historialRef = FirebaseFirestore.instance
          .collection('historial')
          .where('userId', isEqualTo: currentUser.uid);

      final userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        userProfile.value = UserProfileData.fromMap(
            userSnapshot.data() as Map<String, dynamic>);
      }

      final historialSnapshot = await historialRef.get();
      if (historialSnapshot.docs.isNotEmpty) {
        examHistory.value = historialSnapshot.docs
            .map((doc) => ExamHistory.fromMap(doc.data()))
            .toList();
      }
    } catch (e) {
      print('Error loading profile: $e');
      userProfile.value = null;
      examHistory.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signOut();
      userProfile.value = null; // Limpia los datos del perfil
      examHistory.value = [];   // Limpia el historial

      print('User logged out successfully');

      // *** ¡USA EL GLOBALKEY PARA LA NAVEGACIÓN! ***
      // Esto navega a la ruta nombrada '/login' que debe estar definida en tu MaterialApp.
      navigatorKey.currentState?.pushReplacementNamed('/login');

    } catch (e) {
      print('Error logging out: $e');
    } finally {
      isLoading.value = false;
      notifyListeners(); // Notifica a los listeners (la UI) para que se actualicen
    }
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        isLoading.value = false;
        return;
      }

      // Lógica para eliminar datos de Firestore y la cuenta de Firebase Auth
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).delete();
      final historialRef = FirebaseFirestore.instance.collection('historial').where('userId', isEqualTo: currentUser.uid);
      final historialSnapshot = await historialRef.get();
      for (var doc in historialSnapshot.docs) {
        await doc.reference.delete();
      }
      await currentUser.delete();

      userProfile.value = null;
      examHistory.value = [];
      print('Account deleted successfully');

      // *** ¡USA EL GLOBALKEY PARA LA NAVEGACIÓN DESPUÉS DE ELIMINAR! ***
      navigatorKey.currentState?.pushReplacementNamed('/login');

    } catch (e) {
      print('Error deleting account: $e');
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        print('Re-authentication required to delete account');
        // Aquí podrías querer mostrar un SnackBar o Dialog en la UI para re-autenticar
      }
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    userProfile.dispose();
    examHistory.dispose();
    isLoading.dispose();
    super.dispose();
  }
}