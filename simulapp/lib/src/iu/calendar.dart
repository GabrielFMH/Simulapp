// calendar.dart
import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'examlist.dart'; // Importa el archivo principal que contiene las listas de exámenes

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Examen>> _events;
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

    // Añadir los exámenes Cambridge con fechas en octubre 2024
    for (var examen in cambridgeExamenes) {
      DateTime examDate =
          DateTime(2024, 10, 15); // Nueva fecha fija en octubre para Cambridge
      if (events[examDate] == null) {
        events[examDate] = [];
      }
      events[examDate]?.add(examen);
    }

    // Añadir los exámenes Michigan con fechas en octubre 2024
    for (var examen in michiganExamenes) {
      DateTime examDate =
          DateTime(2024, 10, 20); // Nueva fecha fija en octubre para Michigan
      if (events[examDate] == null) {
        events[examDate] = [];
      }
      events[examDate]?.add(examen);
    }

    // Añadir los exámenes TOEFL con fechas en octubre 2024
    for (var examen in toeflExamenes) {
      DateTime examDate =
          DateTime(2024, 10, 10); // Nueva fecha fija en octubre para TOEFL
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            EventCalendar(
              calendarType: CalendarType.GREGORIAN,
              calendarLanguage: 'en',
              events: _events.entries
                  .map((entry) => Event(
                        child: Text(entry.value
                            .map((e) => e.nombre)
                            .join(", ")), // Mostrar nombres de los exámenes
                        dateTime: CalendarDateTime(
                          year: entry.key.year,
                          month: entry.key.month,
                          day: entry.key.day,
                          calendarType: CalendarType.GREGORIAN,
                        ),
                      ))
                  .toList(),
              onDateTimeReset: (date) {
                setState(() {
                  _selectedDay = DateTime(date.year, date.month, date.day);
                  _focusedDay = DateTime(date.year, date.month, date.day);
                });
              },
              onChangeDateTime: (date) {
                setState(() {
                  _selectedDay = DateTime(date.year, date.month, date.day);
                  _focusedDay = DateTime(date.year, date.month, date.day);
                });
              },
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height:
                  300.0, // Añadir un tamaño fijo para evitar el desbordamiento
              child: _buildEventList(),
            ),
          ],
        ),
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
            '${examen.descripcion} - Fecha: ${_selectedDay?.day}/${_selectedDay?.month}/${_selectedDay?.year}',
            style: const TextStyle(color: AppColors.color2),
          ),
        );
      },
    );
  }
}