import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class LoginViewModel {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<bool> login(String email, String password) async {
    isLoading.value = true; // Set loading to true
    try {
      // 1. **Real Firebase Authentication Logic Here**
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), // Use trim() for clean input
        password: password.trim(),
      );

      // If no exception is thrown, login was successful
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors
      print('Firebase Auth Error: ${e.code} - ${e.message}'); // For debugging
      // You might want to store the error message in the ViewModel
      // or pass it back to the UI for display (e.g., via another ValueNotifier)
      return false; // Login failed due to Firebase error
    } catch (e) {
      // Handle any other unexpected errors
      print('General Login Error: $e'); // For debugging
      return false; // Login failed due to an unexpected error
    } finally {
      isLoading.value = false; // Always set loading to false
    }
  }
}