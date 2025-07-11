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

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        // Obtener el token de ID de Google
        final googleAuth = await user.authentication;
        final String? idToken = googleAuth.idToken;

        if (idToken != null) {
          // Crear una credencial de Firebase con el token de ID de Google
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: idToken,
            accessToken: googleAuth.accessToken,
          );

          // Autenticar al usuario en Firebase con la credencial
          final UserCredential authResult =
              await FirebaseAuth.instance.signInWithCredential(credential);

          // Crear el usuario en Firestore si no existe
          await _createUserInFirestore(authResult.user!);
        }
      }
      return user;
    } catch (error) {
      print('Error durante el inicio de sesión con Google: $error');
      return null;
    }
  }

  Future<void> _createUserInFirestore(User user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'username': user.displayName ?? 'No username',
        'createdAt': DateTime.now(),
        'photoUrl': user.photoURL,
      });
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut(); // Cerrar sesión en Firebase también
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