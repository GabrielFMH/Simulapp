import 'package:flutter/material.dart';

// Definición de colores de la aplicación (se mantiene aquí por simplicidad al ser un dato estático de la app)
class AppColors {
  static const Color color1 = Color(0xFF377899); // Color 1
  static const Color color2 = Color(0xFF1F4355); // Color 2
  static const Color color3 = Color(0xFF52B6E6); // Color 3 (Celeste)
  static const Color white = Colors.white; // Color blanco
}

// Clase para representar un examen
class Examen {
  final String nombre;
  final String descripcion;
  final String imagen;
  final DateTime
      fecha; // Cambiado a DateTime para mejor integración con el calendario
  final String examenId;

  Examen({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.fecha,
    required this.examenId,
  });
}

// Datos estáticos de exámenes
final List<Examen> allCambridgeExamenes = [
  Examen(
    nombre: 'C1 Advanced (CAE)',
    descripcion: 'Examen avanzado de inglés.',
    imagen: 'assets/images/CAE.jpg',
    fecha: DateTime(2025, 7, 15), examenId: 'CAE', // 15 de julio de 2025
  ),
  Examen(
    nombre: 'C2 Proficiency (CPE)',
    descripcion: 'Examen de máximo nivel en inglés.',
    imagen: 'assets/images/CPE.jpg',
    fecha: DateTime(2025, 7, 20), examenId: 'CPE', // 20 de julio de 2025
  ),
];

final List<Examen> allMichiganExamenes = [
  Examen(
    nombre: 'ECCE',
    descripcion: 'Examen de competencia en inglés.',
    imagen: 'assets/images/ECCE.jpg',
    fecha: DateTime(2025, 7, 10), examenId: 'ECCE', // 10 de julio de 2025
  ),
  Examen(
    nombre: 'ECPE',
    descripcion: 'Examen de dominio en inglés.',
    imagen: 'assets/images/ECPE.jpg',
    fecha: DateTime(2025, 7, 25), examenId: 'ECPE', // 25 de julio de 2025
  ),
];

final List<Examen> allToeflExamenes = [
  Examen(
    nombre: 'TOEFL iBT',
    descripcion: 'Examen por internet de inglés.',
    imagen: 'assets/images/IBT.jpg',
    fecha: DateTime(2025, 7, 12), examenId: 'TOELF', // 12 de julio de 2025
  ),
  Examen(
    nombre: 'TOEFL ITP',
    descripcion: 'Examen en papel de inglés.',
    imagen: 'assets/images/ITP.jpg',
    fecha: DateTime(2025, 7, 18), examenId: 'TOELF', // 18 de julio de 2025
  ),
];
