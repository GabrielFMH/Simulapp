// lib/viewmodels/map_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/map_model.dart'; // Ensure this path is correct
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapViewModel extends ChangeNotifier {
  final ValueNotifier<Set<Marker>> markers = ValueNotifier({});
  final ValueNotifier<Set<Polyline>> polylines = ValueNotifier({});
  final ValueNotifier<LatLng> initialPosition =
      ValueNotifier(const LatLng(-12.046374, -77.042793)); // Lima, Perú
  final ValueNotifier<LatLng?> currentPosition = ValueNotifier(null);
  final ValueNotifier<MapType> currentMapType = ValueNotifier(MapType.normal);
  final ValueNotifier<bool> isMapReady = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  late GoogleMapController mapController;

  MapViewModel() {
    _initializeMarkers();
  }

  void _initializeMarkers() {
    // Using your custom LocationData from map_model.dart
    final bustios = LocationData(
      position: const LatLng(-18.011737, -70.255539),
      title: 'Cnel. Bustios 146, Tacna 23003',
      snippet: 'cultural.edu.pe',
    );
    final ovaloCallao = LocationData(
      position: const LatLng(-18.012800, -70.255621),
      title: 'Frente al óvalo Callao, Av. Grau s/n, Tacna 23003',
      snippet: 'best.edu.pe',
    );

    markers.value.add(bustios.toMarker(const MarkerId('bustios')));
    markers.value.add(ovaloCallao.toMarker(const MarkerId('ovalo_callao')));
  }

  Future<void> getCurrentLocation() async {
    if (!isMapReady.value) {
      errorMessage.value = 'Map not ready';
      return;
    }

    // Using the prefixed location package
    loc.Location location = loc.Location();
    try {
      // Fetch device location (this is loc.LocationData)
      var locationData = await location.getLocation();
      currentPosition.value =
          LatLng(locationData.latitude!, locationData.longitude!);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPosition.value!, zoom: 15)),
      );
      // Using your custom LocationData from map_model.dart
      final currentLocation = LocationData(
        position: currentPosition.value!,
        title: 'Mi ubicación',
        snippet: '',
      );
      markers.value
          .add(currentLocation.toMarker(const MarkerId('currentLocation')));
    } catch (e) {
      errorMessage.value = 'Error getting location: $e';
      print('Location Error: $e');
    }
  }

  Future<void> drawRoute() async {
    String resolvedOrigin = originController.text.isEmpty
        ? (currentPosition.value != null
            ? '${currentPosition.value!.latitude},${currentPosition.value!.longitude}'
            : 'No location available')
        : originController.text;

    String? getApiKey() {
      try {
        return dotenv.env['GOOGLE_MAPS_API_KEY'];
      } catch (e) {
        print('Error al cargar la clave API: $e');
        return null;
      }
    }

    String? apiKey = getApiKey();
    if (apiKey == null) {
      errorMessage.value = 'API key not found';
      return;
    }

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$resolvedOrigin&destination=${destinationController.text}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'OK') {
          var points = jsonData['routes'][0]['overview_polyline']['points'];
          List<LatLng> polylineCoordinates = _decodePolyline(points);
          polylines.value = {
            Polyline(
              polylineId: const PolylineId('route1'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          };
        } else {
          errorMessage.value = 'Route error: ${jsonData['status']}';
        }
      } else {
        errorMessage.value = 'HTTP error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Request error: $e';
      print('Route Error: $e');
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

  void changeMapType() {
    currentMapType.value = currentMapType.value == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapReady.value = true;
    getCurrentLocation();
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }
}

// Extension to convert LocationData to Marker
extension LocationDataExtension on LocationData {
  Marker toMarker(MarkerId markerId) {
    return Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }
}
