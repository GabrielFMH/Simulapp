// lib/models/map_model.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final LatLng position;
  final String title;
  final String snippet;

  LocationData({
    required this.position,
    required this.title,
    required this.snippet,
  });
}

class RouteData {
  final List<LatLng> polylineCoordinates;

  RouteData({required this.polylineCoordinates});
}