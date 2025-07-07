import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/examen_model.dart'; // Asegúrate de ajustar la ruta
import 'examen_list_viewmodel.dart'; // Asegúrate de ajustar la ruta

class CalendarViewModel extends ChangeNotifier {
  final ValueNotifier<Map<DateTime, List<Examen>>> events = ValueNotifier({});
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime?> selectedDay = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  late final ExamenListViewModel _examenListViewModel;

  factory CalendarViewModel.create(BuildContext context) {
    final viewModel = CalendarViewModel._internal(Provider.of<ExamenListViewModel>(context, listen: false));
    viewModel._examenListViewModel.addListener(viewModel.updateEvents);
    return viewModel;
  }

  CalendarViewModel._internal(this._examenListViewModel) {
    _initializeEvents();
  }

  void _initializeEvents() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final Map<DateTime, List<Examen>> initialEvents = _getExamDates();
      if (initialEvents.isEmpty) {
        errorMessage.value = 'No events available';
      }
      events.value = initialEvents;
    } catch (e) {
      errorMessage.value = 'Error loading events: $e';
      print('CalendarViewModel Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<DateTime, List<Examen>> _getExamDates() {
    Map<DateTime, List<Examen>> events = {};
    try {
      final allExams = [
        ..._examenListViewModel.cambridgeExamenes,
        ..._examenListViewModel.michiganExamenes,
        ..._examenListViewModel.toeflExamenes,
      ];
      print('All Exams: $allExams'); // Debug log
      for (var examen in allExams) {
        final examDate = DateTime(examen.fecha.year, examen.fecha.month, examen.fecha.day);
        events[examDate] ??= [];
        events[examDate]!.add(examen);
      }
    } catch (e) {
      print('Error in _getExamDates: $e');
    }
    return events;
  }

  void updateSelectedDay(DateTime date) {
    selectedDay.value = DateTime(date.year, date.month, date.day);
    focusedDay.value = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void updateEvents() {
    final newEvents = _getExamDates();
    if (!mapEquals(events.value, newEvents)) {
      events.value = newEvents;
    }
  }

  @override
  void dispose() {
    _examenListViewModel.removeListener(updateEvents);
    events.dispose();
    focusedDay.dispose();
    selectedDay.dispose();
    isLoading.dispose();
    errorMessage.dispose();
    super.dispose();
  }

  static CalendarViewModel of(BuildContext context, {bool listen = true}) {
    return Provider.of<CalendarViewModel>(context, listen: listen);
  }
}