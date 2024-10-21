// calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'examlist.dart'; // Importa el archivo principal que contiene las listas de exámenes

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Examen>> _events;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _events = _getExamDates(); // Obtener las fechas de exámenes
  }

  // Método para obtener las fechas de los exámenes
  Map<DateTime, List<Examen>> _getExamDates() {
    Map<DateTime, List<Examen>> events = {};

    // Añadir los exámenes Cambridge con fechas al azar
    for (var examen in cambridgeExamenes) {
      DateTime examDate =
          DateTime(2024, 6, 15); // Fecha fija de ejemplo para Cambridge
      if (events[examDate] == null) {
        events[examDate] = [];
      }
      events[examDate]?.add(examen);
    }

    // Añadir los exámenes Michigan con fechas al azar
    for (var examen in michiganExamenes) {
      DateTime examDate =
          DateTime(2024, 7, 20); // Fecha fija de ejemplo para Michigan
      if (events[examDate] == null) {
        events[examDate] = [];
      }
      events[examDate]?.add(examen);
    }

    // Añadir los exámenes TOEFL con fechas al azar
    for (var examen in toeflExamenes) {
      DateTime examDate =
          DateTime(2024, 8, 10); // Fecha fija de ejemplo para TOEFL
      if (events[examDate] == null) {
        events[examDate] = [];
      }
      events[examDate]?.add(examen);
    }

    return events;
  }

  // Método para construir la vista del calendario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Exámenes'),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2022),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.color1,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.color2,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppColors.color3,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  // Construir lista de eventos
  Widget _buildEventList() {
    final events = _events[_selectedDay] ?? [];

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final examen = events[index];
        return ListTile(
          title: Text(
            examen.nombre,
            style: const TextStyle(color: AppColors.color2),
          ),
          subtitle: Text(
            examen.descripcion,
            style: const TextStyle(color: AppColors.color2),
          ),
        );
      },
    );
  }
}
