import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart'; // Para obtener la ubicación actual
import 'examlist.dart'; // Para obtener la ubicación actual


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {}; // Conjunto de líneas para trazar rutas
  LatLng _initialPosition = const LatLng(-12.046374, -77.042793); // Lima, Perú
  LatLng? _currentPosition; // Almacena la ubicación actual del usuario

  MapType _currentMapType = MapType.normal; // Tipo de mapa (normal, satélite, etc.)

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Agregar ubicaciones importantes como marcadores en rojo
    _addRedMarkers();
  }

  // Método para agregar los marcadores rojos en las ubicaciones importantes
  void _addRedMarkers() {
    // Marcador 1: Cnel. Bustios 146, Tacna 23003
    _markers.add(
      Marker(
        markerId: const MarkerId('bustios'),
        position: const LatLng(-18.011737, -70.255539),
        infoWindow: const InfoWindow(
          title: 'Cnel. Bustios 146, Tacna 23003',
          snippet: 'cultural.edu.pe',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Marcador 2: Frente al óvalo Callao, Av. Grau s/n, Tacna 23003
    _markers.add(
      Marker(
        markerId: const MarkerId('ovalo_callao'),
        position: const LatLng(-18.012800, -70.255621),
        infoWindow: const InfoWindow(
          title: 'Frente al óvalo Callao, Av. Grau s/n, Tacna 23003',
          snippet: 'best.edu.pe',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  // Método para trazar la ruta
  Future<void> _drawRoute(String origin, String destination) async {
    String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Reemplaza con tu propia clave de API

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'OK') {
        var points = jsonData['routes'][0]['overview_polyline']['points'];
        List<LatLng> polylineCoordinates = _decodePolyline(points);

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route1'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      } else {
        print("Error al obtener la ruta: ${jsonData['status']}");
      }
    } catch (e) {
      print("Error durante la solicitud a la API de Google Directions: $e");
    }
  }

  // Método para decodificar la ruta polilinear
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng(lat / 1E5, lng / 1E5);
      polyline.add(point);
    }

    return polyline;
  }

  // Método para obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    Location location = Location();
    LocationData locationData;

    try {
      locationData = await location.getLocation();
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 15),
        ),
      );
      setState(() {
        // Añadir un marcador rojo en la ubicación actual
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(
              title: 'Mi ubicación',
            ),
          ),
        );
      });
    } catch (e) {
      print('Error obteniendo la ubicación: $e');
    }
  }

  // Cambiar el tipo de mapa
  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  // Método que se ejecuta cuando el mapa es creado
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps con Rutas y Modos'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _changeMapType, // Cambiar el tipo de mapa
          ),
        ],
      ),
      body: Column(
        children: [
          // Contenedor con buscadores fuera del mapa
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Caja de texto para la ubicación de origen
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_pin, color: Colors.grey),
                      Expanded(
                        child: TextField(
                          controller: originController,
                          decoration: const InputDecoration(
                            hintText: "Ubicación de origen",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Caja de texto para la ubicación de destino
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      Expanded(
                        child: TextField(
                          controller: destinationController,
                          decoration: const InputDecoration(
                            hintText: "Buscar destino",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Llamar al método para trazar la ruta con los valores ingresados
                    _drawRoute(originController.text, destinationController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.black, // Color de fondo
                  ),
                  child: const Text("Buscar Ruta"),
                ),
              ],
            ),
          ),

          // Contenedor que contiene el mapa (no ocupa toda la pantalla)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 12,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false, // Quitamos el botón nativo para usar nuestro propio botón
                markers: _markers,
                polylines: _polylines, // Aquí se añaden las polylines para las rutas
                mapType: _currentMapType, // Tipo de mapa dinámico
              ),
            ),
          ),
        ],
      ),
      // Botón flotante para obtener la ubicación actual
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
        backgroundColor: Colors.red, // Marcará la ubicación con un marcador rojo
        tooltip: 'Ver mi ubicación',
      ),
    );
  }
}
