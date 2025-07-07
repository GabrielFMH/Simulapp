import 'package:flutter/material.dart';
import '../models/examen_model.dart'; // Asegúrate de ajustar la ruta según tu estructura

class ExamenListViewModel extends ChangeNotifier {
  // Listas originales de exámenes (privadas)
  final List<Examen> _cambridgeExamenes = allCambridgeExamenes;
  final List<Examen> _michiganExamenes = allMichiganExamenes;
  final List<Examen> _toeflExamenes = allToeflExamenes;

  // Listas filtradas (privadas)
  List<Examen> _filteredCambridgeExamenes = [];
  List<Examen> _filteredMichiganExamenes = [];
  List<Examen> _filteredToeflExamenes = [];

  // Índice de la pestaña seleccionada
  int _selectedIndex = 0;

  // Controlador de texto para la búsqueda
  final TextEditingController searchController = TextEditingController();

  ExamenListViewModel() {
    // Inicializar listas filtradas
    _filteredCambridgeExamenes = List.from(_cambridgeExamenes);
    _filteredMichiganExamenes = List.from(_michiganExamenes);
    _filteredToeflExamenes = List.from(_toeflExamenes);

    // Escuchar cambios en el campo de búsqueda
    searchController.addListener(_onSearchChanged);
  }

  // Getters públicos para las listas originales
  List<Examen> get cambridgeExamenes => _cambridgeExamenes;
  List<Examen> get michiganExamenes => _michiganExamenes;
  List<Examen> get toeflExamenes => _toeflExamenes;

  // Getters públicos para las listas filtradas y el índice
  List<Examen> get filteredCambridgeExamenes => _filteredCambridgeExamenes;
  List<Examen> get filteredMichiganExamenes => _filteredMichiganExamenes;
  List<Examen> get filteredToeflExamenes => _filteredToeflExamenes;
  int get selectedIndex => _selectedIndex;

  // Lógica de filtrado
  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();

    _filteredCambridgeExamenes = _cambridgeExamenes.where((examen) =>
        examen.nombre.toLowerCase().contains(query) ||
        examen.descripcion.toLowerCase().contains(query)).toList();

    _filteredMichiganExamenes = _michiganExamenes.where((examen) =>
        examen.nombre.toLowerCase().contains(query) ||
        examen.descripcion.toLowerCase().contains(query)).toList();

    _filteredToeflExamenes = _toeflExamenes.where((examen) =>
        examen.nombre.toLowerCase().contains(query) ||
        examen.descripcion.toLowerCase().contains(query)).toList();

    notifyListeners();
  }

  // Actualizar el índice de la barra de navegación
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}