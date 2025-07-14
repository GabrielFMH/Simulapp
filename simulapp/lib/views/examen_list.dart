// lib/views/examen_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Para ChangeNotifierProvider y Consumer
import '../models/examen_model.dart'; // Importa el modelo (para AppColors y Examen)
import '../viewmodels/examen_list_viewmodel.dart'; // Importa el ViewModel
//import '../src/iu/maps.dart'; // Asegúrate de importar tu archivo maps.dart
import 'map.dart';
//import '../src/iu/prices.dart';
import 'price.dart';
//import '../src/iu/calendar.dart'; // Importa el archivo calendar.dart
import 'examen.dart';
//import '../src/iu/exam.dart'; // Importa la pantalla de detalles
import 'calendar.dart';
import 'profile.dart';
//import '../src/iu/profile.dart'; // Importa la pantalla de perfil

class ExamenesScreen extends StatelessWidget {
  const ExamenesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamenListViewModel>(
      builder: (context, viewModel, child) {
        return DefaultTabController(
          length: 3, // Número de pestañas (Cambridge, Michigan, Toefl)
          child: Scaffold(
            backgroundColor:
                const Color.fromARGB(255, 166, 222, 248), // Fondo celeste
            appBar: AppBar(
              backgroundColor: Colors.lightBlue, // Color celeste para el AppBar
              elevation: 0, // Elimina la sombra para un diseño más limpio
              bottom: viewModel.selectedIndex == 0
                  ? const TabBar(
                      tabs: [
                        Tab(text: 'Cambridge'),
                        Tab(text: 'Michigan'),
                        Tab(text: 'Toefl'),
                      ],
                      labelColor: Colors
                          .white, // Texto blanco para pestañas seleccionadas
                      unselectedLabelColor: Colors
                          .white70, // Texto blanco suave para no seleccionadas
                      indicatorColor: Colors.white, // Indicador blanco
                    )
                  : null, // Solo mostrar TabBar en la pantalla de exámenes
            ),
            body: IndexedStack(
              index: viewModel.selectedIndex,
              children: [
                _buildExamenesView(context, viewModel), // Vista de exámenes
                const UserProfile(), // Placeholder para Perfil
                const MapScreen(), // Pantalla del mapa (ubicación)
                const PricesPage(), // Navegar a PricesPage
                const CalendarPage(), // Vista para Calendario
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.lightBlue, // Fondo celeste
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view, color: Colors.lightBlue),
                  label: 'Exams',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.lightBlue),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_pin, color: Colors.lightBlue),
                  label: 'Ubication',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money, color: Colors.lightBlue),
                  label: 'Prices',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today, color: Colors.lightBlue),
                  label: 'Calendary',
                ),
              ],
              currentIndex: viewModel.selectedIndex,
              selectedItemColor:
                  Colors.lightBlue, // Ítems seleccionados en celeste
              unselectedItemColor: Colors
                  .lightBlueAccent, // Ítems no seleccionados en celeste claro
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
            style: const TextStyle(
                color: Colors.black), // Texto negro para contraste
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white, // Fondo blanco
              hintText: 'Buscar',
              hintStyle: TextStyle(color: Colors.black54), // Pista gris oscuro
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
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

class ExamenesList extends StatelessWidget {
  final List<Examen> examenes;

  const ExamenesList({required this.examenes, super.key});

  @override
  Widget build(BuildContext context) {
    if (examenes.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron exámenes',
          style: TextStyle(color: Colors.white, fontSize: 18), // Texto blanco
        ),
      );
    }

    return ListView.builder(
      itemCount: examenes.length,
      itemBuilder: (context, index) {
        final examen = examenes[index];
        return Card(
          margin: const EdgeInsets.all(8),
          color: Colors.white, // Fondo blanco para la tarjeta
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                examen.imagen,
                fit: BoxFit.cover,
                // --- MODIFICACIONES AQUÍ ---
                cacheWidth:
                    64, // Decodifica la imagen a un máximo de 128px de ancho
                cacheHeight:
                    64, // Decodifica la imagen a un máximo de 128px de alto
                // -------------------------
              ),
            ),
            title: Text(
              examen.nombre,
              style: const TextStyle(color: Colors.lightBlue), // Texto celeste
            ),
            subtitle: Text(
              examen.descripcion,
              style: const TextStyle(
                  color: Colors.black54), // Subtítulo gris oscuro
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.lightBlue), // Icono celeste
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamenDetalleScreen(examen: examen),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
