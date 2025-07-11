import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:provider/provider.dart';
import '../models/examen_model.dart';
import '../viewmodels/calendar_viewmodel.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarViewModel.create(context),
      child: const _CalendarPageContent(),
    );
  }
}

class _CalendarPageContent extends StatelessWidget {
  const _CalendarPageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Exámenes'),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: viewModel.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ValueListenableBuilder<String?>(
            valueListenable: viewModel.errorMessage,
            builder: (context, errorMessage, child) {
              if (errorMessage != null) {
                return Center(child: Text(errorMessage));
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ValueListenableBuilder<Map<DateTime, List<Examen>>>(
                      valueListenable: viewModel.events,
                      builder: (context, events, child) {
                        if (events.isEmpty) {
                          return const Center(child: Text('No events to display'));
                        }
                        return EventCalendar(
                          calendarType: CalendarType.GREGORIAN,
                          calendarLanguage: 'en',
                          events: events.entries
                              .map((entry) => Event(
                                    child: Text(entry.value.map((e) => e.nombre).join(", ")),
                                    dateTime: CalendarDateTime(
                                      year: entry.key.year,
                                      month: entry.key.month,
                                      day: entry.key.day,
                                      calendarType: CalendarType.GREGORIAN,
                                    ),
                                  ))
                              .toList(),
                          onDateTimeReset: (date) {
                            final selectedDate = DateTime(date.year, date.month, date.day);
                            viewModel.updateSelectedDay(selectedDate);
                          },
                          onChangeDateTime: (date) {
                            final selectedDate = DateTime(date.year, date.month, date.day);
                            viewModel.updateSelectedDay(selectedDate);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      height: 300.0,
                      child: _buildEventList(context, viewModel),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventList(BuildContext context, CalendarViewModel viewModel) {
    return ValueListenableBuilder<DateTime?>(
      valueListenable: viewModel.selectedDay,
      builder: (context, selectedDay, child) {
        final events = selectedDay != null ? viewModel.events.value[selectedDay] ?? [] : [];
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
                '${examen.descripcion} - Fecha: ${selectedDay?.day}/${selectedDay?.month}/${selectedDay?.year}',
                style: const TextStyle(color: AppColors.color2),
              ),
            );
          },
        );
      },
    );
  }
}