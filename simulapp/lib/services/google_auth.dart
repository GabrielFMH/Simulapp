import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);
  final StreamController<GoogleSignInAccount?> _userController =
      StreamController.broadcast();
  final StreamController<bool> _authorizationController =
      StreamController.broadcast();

  GoogleAuth() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _userController.add(account);
      _checkAuthorization(account);
    });
  }

  Stream<GoogleSignInAccount?> get currentUser => _userController.stream;
  Stream<bool> get isAuthorized => _authorizationController.stream;

  Future<void> _checkAuthorization(GoogleSignInAccount? account) async {
    bool authorized = account != null;
    if (kIsWeb && account != null) {
      authorized = await _googleSignIn.canAccessScopes(scopes);
    }
    _authorizationController.add(authorized);
  }

  /// Inicia sesión con Google y autentica en Firebase.
  /// Retorna null si la operación fue exitosa, o un String con el mensaje de error.
  Future<String?> signIn() async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      
      if (user == null) {
        // El usuario canceló el inicio de sesión
        return 'Inicio de sesión con Google cancelado.';
      }

      // Obtener el token de ID de Google
      final GoogleSignInAuthentication googleAuth = await user.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        return 'No se pudo obtener el ID Token de Google.';
      }

      // Crear una credencial de Firebase con el token de ID de Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: googleAuth.accessToken, // accessToken también es útil
      );

      // Autenticar al usuario en Firebase con la credencial
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Si la autenticación de Firebase fue exitosa, crear el usuario en Firestore
      if (authResult.user != null) {
        await _createUserInFirestore(authResult.user!);
        return null; // Éxito: retorna null
      } else {
        return 'No se pudo autenticar el usuario en Firebase.';
      }
    } on FirebaseAuthException catch (e) {
      // Errores específicos de Firebase Auth
      print('Error de Firebase Auth durante el inicio de sesión con Google: ${e.code} - ${e.message}');
      return 'Error de autenticación: ${e.message}';
    } catch (error) {
      // Otros errores generales
      print('Error general durante el inicio de sesión con Google: $error');
      return 'Error desconocido: $error';
    }
  }

  /// Crea o actualiza el documento del usuario en Firestore.
  Future<void> _createUserInFirestore(User user) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      // Si el documento no existe, crearlo
      await userDocRef.set({
        'email': user.email,
        'username': user.displayName ?? user.email?.split('@')[0] ?? 'No username', // Intenta usar el nombre de usuario de Google, o parte del email
        'createdAt': FieldValue.serverTimestamp(), // Usa un timestamp del servidor
        'photoUrl': user.photoURL,
      });
    } else {
      // Si el documento ya existe, puedes actualizarlo si es necesario (ej. photoURL, displayName)
      // Por ahora, no haremos nada si ya existe, pero es una opción.
      // await userDocRef.update({
      //   'lastLogin': FieldValue.serverTimestamp(),
      // });
    }
  }

  /// Cierra la sesión de Google y Firebase.
  Future<void> signOut() async {
    await _googleSignIn.disconnect(); // Desconecta la cuenta de Google
    await FirebaseAuth.instance.signOut(); // Cierra sesión en Firebase
  }

  Future<bool> requestScopes() async {
    final bool authorized = await _googleSignIn.requestScopes(scopes);
    _authorizationController.add(authorized);
    return authorized;
  }

  void dispose() {
    _userController.close();
    _authorizationController.close();
  }
}