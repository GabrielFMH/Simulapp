import 'package:firebase_core/firebase_core.dart';
// Asegúrate de que esta importación esté aquí
import '../../firebase_options.dart'; // Archivo generado por Firebase CLI

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }
}