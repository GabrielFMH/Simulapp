import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Asegúrate de que esta ruta sea correcta

class RegisterViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> registerUser() async {
    _isLoading = true;
    notifyListeners(); // Notifica a la UI que el estado de carga ha cambiado

    try {
      // 1. Crear el usuario en Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), // trim() para eliminar espacios en blanco
        password: passwordController.text.trim(),
      );

      // Asegúrate de que el usuario se haya creado correctamente
      if (userCredential.user == null) {
        return "No se pudo crear el usuario. Intenta de nuevo.";
      }

      // 2. Crear el modelo de usuario para Firestore
      final user = UserModel(
        uid: userCredential.user!.uid,
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        createdAt: DateTime.now(),
      );

      // 3. Guardar los datos del usuario en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());

      return null; // Retorna null si el registro fue exitoso
    } on FirebaseAuthException catch (e) {
      // Manejo específico de errores de FirebaseAuth
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'La contraseña es demasiado débil. Usa al menos 6 caracteres.';
          break;
        case 'email-already-in-use':
          errorMessage = 'El correo electrónico ya está registrado.';
          break;
        case 'invalid-email':
          errorMessage = 'El formato del correo electrónico no es válido.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'La autenticación por correo y contraseña no está habilitada.';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de red. Por favor, verifica tu conexión a internet.';
          break;
        default:
          errorMessage = 'Error de autenticación: ${e.message ?? "Ocurrió un error desconocido."}';
          break;
      }
      return errorMessage;
    } on FirebaseException catch (e) {
      // Manejo específico de otros errores de Firebase (ej. Firestore)
      return 'Error de Firebase: ${e.message ?? "Ocurrió un error inesperado con Firebase."}';
    } catch (e) {
      // Manejo de cualquier otra excepción inesperada
      return 'Ocurrió un error inesperado durante el registro: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a la UI que el estado de carga ha terminado
    }
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }
}