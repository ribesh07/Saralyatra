import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RouteProvider extends ChangeNotifier {
  List<LatLng> routePoints = [];
  LatLng? userLocation;

  void setRoutePoints(List<LatLng> points) {
    routePoints = points;
    notifyListeners();
  }

  void setUserLocation(LatLng location) {
    userLocation = location;
    notifyListeners();
  }
}
