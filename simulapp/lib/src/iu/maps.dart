import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng _initialPosition = const LatLng(-12.046374, -77.042793); // Lima, Perú
  LatLng? _currentPosition;

  MapType _currentMapType = MapType.normal;

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  bool isMapReady = false;  // Bandera para indicar si el mapa está listo

  @override
  void initState() {
    super.initState();
    _addRedMarkers();
  }

  void _addRedMarkers() {
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

  Future<void> _drawRoute(String origin, String destination) async {
    if (origin.isEmpty && _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa un origen o habilita tu ubicación actual.")),
      );
      return;
    }

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa un destino.")),
      );
      return;
    }

    // Usar la ubicación actual si el campo de origen está vacío
    String resolvedOrigin = origin.isEmpty
        ? '${_currentPosition!.latitude},${_currentPosition!.longitude}'
        : origin;

    String apiKey = 'AIzaSyAiJofFoIKKglajZx-J0TKd7ppIKHjxfBA';
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$resolvedOrigin&destination=$destination&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      // Verifica el estado de la respuesta HTTP
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Response body: $jsonData'); // Muestra la respuesta completa para depuración

        if (jsonData['status'] == 'OK') {
          var points = jsonData['routes'][0]['overview_polyline']['points'];
          List<LatLng> polylineCoordinates = _decodePolyline(points);

          setState(() {
            _polylines.clear(); // Limpiar rutas anteriores
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
          // Muestra un error si el estado de la respuesta no es 'OK'
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al obtener la ruta: ${jsonData['status']}")),
          );
        }
      } else {
        // Si la respuesta no es 200, muestra el código de error y el mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error en la respuesta HTTP: ${response.statusCode}")),
        );
        print("Error HTTP: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Muestra el error si algo sale mal con la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error durante la solicitud: $e")),
      );
      print("Error durante la solicitud: $e");
    }
  }

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

  Future<void> _getCurrentLocation() async {
    // Verifica que el mapa esté listo antes de obtener la ubicación
    if (!isMapReady) {
      print("El mapa no está listo todavía.");
      return; // No intentar obtener la ubicación si el mapa no está listo
    }

    Location location = Location();
    try {
      var locationData = await location.getLocation();
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);

      // Verifica si el mapController está inicializado antes de usarlo
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition!, zoom: 15),
          ),
        );
      }

      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: 'Mi ubicación'),
          ),
        );
      });
    } catch (e) {
      print('Error obteniendo la ubicación: $e');
    }
  }

  void _changeMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      isMapReady = true;  // El mapa está listo
    });

    // Llamar a _getCurrentLocation una vez que el mapa esté listo
    _getCurrentLocation();
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
            onPressed: _changeMapType,
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
                    _buildInputField(Icons.location_pin, "Ubicación de origen", originController),
                    const SizedBox(height: 10),
                    _buildInputField(Icons.search, "Buscar destino", destinationController),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _drawRoute(originController.text, destinationController.text);
                      },
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
                    myLocationButtonEnabled: false,
                    markers: _markers,
                    polylines: _polylines,
                    mapType: _currentMapType,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
              backgroundColor: Colors.red,
              tooltip: 'Ver mi ubicación',
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInputField(
      IconData icon, String hintText, TextEditingController controller) {
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
