import 'package:flutter/material.dart';
import 'maps.dart'; // Asegúrate de importar tu archivo maps.dart
import 'prices.dart';
import 'calendar.dart'; // Importa el archivo calendar.dart
import 'exam.dart'; // Importa la pantalla de detalles


class AppColors {
  static const Color color1 = Color(0xFF377899); // Color 1
  static const Color color2 = Color(0xFF1F4355); // Color 2
  static const Color color3 = Color(0xFF52B6E6); // Color 3 (Celeste)
  static const Color white = Colors.white; // Color blanco
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExamenesScreen(),
      theme: ThemeData(
        primaryColor: AppColors.color1, // Color primario
        scaffoldBackgroundColor: AppColors.white, // Color de fondo
      ),
    );
  }
}

// Clase para representar un examen
class Examen {
  final String nombre;
  final String descripcion;
  final String imagen;
  final String fecha; // Año del examen

  Examen({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.fecha,
  });
}

class ExamenesScreen extends StatefulWidget {
  const ExamenesScreen({super.key});

  @override
  _ExamenesScreenState createState() => _ExamenesScreenState();
}

class _ExamenesScreenState extends State<ExamenesScreen> {
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0; // Controlador de índice para la barra de navegación

  // Listas de exámenes para cada sección
  List<Examen> cambridgeExamenes = [
    Examen(
      nombre: 'C1 Advanced (CAE)',
      descripcion: 'Examen avanzado de inglés.',
      imagen: 'images/CAE.jpg',
      fecha: '2024',
    ),
    Examen(
      nombre: 'C2 Proficiency (CPE)',
      descripcion: 'Examen de máximo nivel en inglés.',
      imagen: 'images/CPE.jpg',
      fecha: '2024',
    ),
  ];

  List<Examen> michiganExamenes = [
    Examen(
      nombre: 'ECCE',
      descripcion: 'Examen de competencia en inglés.',
      imagen: 'images/ECCE.jpg',
      fecha: '2024',
    ),
    Examen(
      nombre: 'ECPE',
      descripcion: 'Examen de dominio en inglés.',
      imagen: 'images/ECPE.jpg',
      fecha: '2024',
    ),
  ];

  List<Examen> toeflExamenes = [
    Examen(
      nombre: 'TOEFL iBT',
      descripcion: 'Examen por internet de inglés.',
      imagen: 'images/IBT.jpg',
      fecha: '2024',
    ),
    Examen(
      nombre: 'TOEFL ITP',
      descripcion: 'Examen en papel de inglés.',
      imagen: 'images/ITP.jpg',
      fecha: '2024',
    ),
  ];

  // Listas filtradas
  List<Examen> filteredCambridgeExamenes = [];
  List<Examen> filteredMichiganExamenes = [];
  List<Examen> filteredToeflExamenes = [];

  @override
  void initState() {
    super.initState();
    // Inicializar listas filtradas
    filteredCambridgeExamenes = cambridgeExamenes;
    filteredMichiganExamenes = michiganExamenes;
    filteredToeflExamenes = toeflExamenes;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredCambridgeExamenes = cambridgeExamenes.where((examen) {
        return examen.nombre.toLowerCase().contains(query) ||
            examen.descripcion.toLowerCase().contains(query);
      }).toList();

      filteredMichiganExamenes = michiganExamenes.where((examen) {
        return examen.nombre.toLowerCase().contains(query) ||
            examen.descripcion.toLowerCase().contains(query);
      }).toList();

      filteredToeflExamenes = toeflExamenes.where((examen) {
        return examen.nombre.toLowerCase().contains(query) ||
            examen.descripcion.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

    @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas (Cambridge, Michigan, Toefl)
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exámenes Internacionales'),
          centerTitle: true,
          backgroundColor: AppColors.color3,
          bottom: _selectedIndex == 0
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
          index: _selectedIndex,
          children: [
            _buildExamenesView(), // Vista de exámenes
            Container(), // Placeholder para Inicio
            MapScreen(), // Aquí se muestra la pantalla del mapa (ubicación)
            PricesPage(), // Navegar a PricesPage
            CalendarPage(), // Nueva vista para Calendario
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
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.color2,
          unselectedItemColor: AppColors.color1,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // Método que construye la vista de exámenes con TabBarView
  Widget _buildExamenesView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
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
              ExamenesList(examenes: filteredCambridgeExamenes),
              ExamenesList(examenes: filteredMichiganExamenes),
              ExamenesList(examenes: filteredToeflExamenes),
            ],
          ),
        ),
      ],
    );
  }
}

List<Examen> cambridgeExamenes = [
  Examen(
    nombre: 'C1 Advanced (CAE)',
    descripcion: 'Examen avanzado de inglés.',
    imagen: 'images/CAE.jpg',
    fecha: '2024',
  ),
  Examen(
    nombre: 'C2 Proficiency (CPE)',
    descripcion: 'Examen de máximo nivel en inglés.',
    imagen: 'images/CPE.jpg',
    fecha: '2024',
  ),
];

List<Examen> michiganExamenes = [
  Examen(
    nombre: 'ECCE',
    descripcion: 'Examen de competencia en inglés.',
    imagen: 'images/ECCE.jpg',
    fecha: '2024',
  ),
  Examen(
    nombre: 'ECPE',
    descripcion: 'Examen de dominio en inglés.',
    imagen: 'images/ECPE.jpg',
    fecha: '2024',
  ),
];

List<Examen> toeflExamenes = [
  Examen(
    nombre: 'TOEFL iBT',
    descripcion: 'Examen por internet de inglés.',
    imagen: 'images/IBT.jpg',
    fecha: '2024',
  ),
  Examen(
    nombre: 'TOEFL ITP',
    descripcion: 'Examen en papel de inglés.',
    imagen: 'images/ITP.jpg',
    fecha: '2024',
  ),
];

// Widget que muestra la lista de exámenes
// Widget que muestra la lista de exámenes
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
                    nombre: examen.nombre,          // Pasar el nombre del examen
                    descripcion: examen.descripcion, // Pasar la descripción del examen
                    imagen: examen.imagen, examenId: '',          // Pasar la imagen del examen
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