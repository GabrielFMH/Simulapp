// lib/views/examen_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Para ChangeNotifierProvider y Consumer
import '../models/examen_model.dart'; // Importa el modelo (para AppColors y Examen)
import '../viewmodels/examen_list_viewmodel.dart'; // Importa el ViewModel
import '../src/iu/maps.dart'; // Asegúrate de importar tu archivo maps.dart
import '../src/iu/prices.dart';
import '../src/iu/calendar.dart'; // Importa el archivo calendar.dart
import '../src/iu/exam.dart'; // Importa la pantalla de detalles
import '../views/profile.dart';
//import '../src/iu/profile.dart'; // Importa la pantalla de perfil

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) =>
            ExamenListViewModel(), // Proporciona el ViewModel a la vista
        child: const ExamenesScreen(),
      ),
      theme: ThemeData(
        primaryColor: AppColors.color1, // Color primario
        scaffoldBackgroundColor: AppColors.white, // Color de fondo
      ),
    );
  }
}

class ExamenesScreen extends StatelessWidget {
  const ExamenesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamenListViewModel>(
      builder: (context, viewModel, child) {
        return DefaultTabController(
          length: 3, // Número de pestañas (Cambridge, Michigan, Toefl)
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Exámenes Internacionales'),
              centerTitle: true,
              backgroundColor: AppColors.color3,
              bottom: viewModel.selectedIndex == 0
                  ? const TabBar(
                      tabs: [
                        Tab(text: 'Cambridge'),
                        Tab(text: 'Michigan'),
                        Tab(text: 'Toefl'),
                      ],
                      indicatorColor: AppColors.color2,
                    )
                  : null, // Solo mostrar TabBar en la pantalla de exámenes
            ),
            body: IndexedStack(
              index: viewModel.selectedIndex,
              children: [
                _buildExamenesView(context, viewModel), // Vista de exámenes
                const UserProfile(), // Placeholder para Inicio
                const MapScreen(), // Aquí se muestra la pantalla del mapa (ubicación)
                const PricesPage(), // Navegar a PricesPage
                const CalendarPage(), // Nueva vista para Calendario
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColors.color3,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view, color: AppColors.color2),
                  label: 'Menú',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: AppColors.color2),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_pin, color: AppColors.color2),
                  label: 'Ubicación',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money, color: AppColors.color2),
                  label: 'Precios',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today, color: AppColors.color2),
                  label: 'Calendario',
                ),
              ],
              currentIndex: viewModel.selectedIndex,
              selectedItemColor: AppColors.color2,
              unselectedItemColor: AppColors.color1,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              onTap: viewModel
                  .updateSelectedIndex, // Llama al método del ViewModel
            ),
          ),
        );
      },
    );
  }

  // Método que construye la vista de exámenes con TabBarView
  Widget _buildExamenesView(
      BuildContext context, ExamenListViewModel viewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller:
                viewModel.searchController, // Usa el controlador del ViewModel
            decoration: InputDecoration(
              hintText: 'Buscar',
              prefixIcon: const Icon(Icons.search, color: AppColors.color2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.color2),
              ),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              ExamenesList(examenes: viewModel.filteredCambridgeExamenes),
              ExamenesList(examenes: viewModel.filteredMichiganExamenes),
              ExamenesList(examenes: viewModel.filteredToeflExamenes),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget que muestra la lista de exámenes (se mantiene casi igual, pero ahora recibe la lista del ViewModel)
class ExamenesList extends StatelessWidget {
  final List<Examen> examenes;

  const ExamenesList({required this.examenes, super.key});

  @override
  Widget build(BuildContext context) {
    if (examenes.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron exámenes',
          style: TextStyle(color: AppColors.color2, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: examenes.length, // Número de exámenes en la lista
      itemBuilder: (context, index) {
        final examen = examenes[index];
        return Card(
          margin: const EdgeInsets.all(8),
          color: AppColors.color1, // Color de fondo de la tarjeta
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                examen.imagen, // Ruta de la imagen del examen
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              examen.nombre,
              style: const TextStyle(color: AppColors.white),
            ),
            subtitle: Text(
              examen.descripcion,
              style: const TextStyle(color: AppColors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: AppColors.white), // Color del icono
            onTap: () {
              // Navegar a la pantalla de detalles usando ExamenDetalleScreen de exam.dart
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamenDetalleScreen(
                    nombre: examen.nombre, // Pasar el nombre del examen
                    descripcion:
                        examen.descripcion, // Pasar la descripción del examen
                    imagen: examen.imagen,
                    examenId: '', // Pasar la imagen del examen
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
