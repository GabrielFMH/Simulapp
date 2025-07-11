// lib/views/map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_viewmodel.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: const _MapScreenContent(),
    );
  }
}

class _MapScreenContent extends StatelessWidget {
  const _MapScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps con Rutas y Modos'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: viewModel.changeMapType,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _buildInputField(
                        context, Icons.location_pin, "Ubicación de origen", viewModel.originController),
                    const SizedBox(height: 10),
                    _buildInputField(context, Icons.search, "Buscar destino",
                        viewModel.destinationController),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: viewModel.drawRoute,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text("Buscar Ruta"),
                    ),
                  ],
                ),
              ),
              Expanded(
                // Se eliminó el ValueListenableBuilder que causaba el bloqueo.
                // Ahora el mapa se construye directamente.
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  // Usamos ValueListenableBuilder para que la UI reaccione a los cambios
                  // en el ViewModel (nuevos marcadores, rutas, cambio de tipo de mapa).
                  child: ValueListenableBuilder(
                    valueListenable: viewModel.markers,
                    builder: (_, markers, __) => ValueListenableBuilder(
                      valueListenable: viewModel.polylines,
                      builder: (_, polylines, __) => ValueListenableBuilder(
                        valueListenable: viewModel.currentMapType,
                        builder: (_, mapType, __) => GoogleMap(
                          onMapCreated: viewModel.onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: viewModel.initialPosition.value,
                            zoom: 12,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: markers,
                          polylines: polylines,
                          mapType: mapType,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
          ValueListenableBuilder<String?>(
            valueListenable: viewModel.errorMessage,
            builder: (context, errorMessage, child) {
              if (errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                });
              }
              return const SizedBox.shrink();
            },
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: viewModel.getCurrentLocation,
              backgroundColor: Colors.red,
              tooltip: 'Ver mi ubicación',
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context, IconData icon, String hintText,
      TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}