import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

Future<List<LatLng>> loadRouteFromGeoJson() async {
  final geoJson = await rootBundle.loadString('assets/mahasagar.geojson');
  final data = json.decode(geoJson);
  final List coords = data['coordinates'];

  final List<LatLng> points = [];

  for (final segment in coords) {
    for (final c in segment) {
      final lon = (c[0] as num).toDouble();
      final lat = (c[1] as num).toDouble();

      // Optional: Limit to 6 digits after decimal
      points.add(LatLng(
        double.parse(lat.toStringAsFixed(6)),
        double.parse(lon.toStringAsFixed(6)),
      ));
    }
  }
  return points;
}

Future<List<LatLng>> loadRouteFromGeoJsonSanga() async {
  final geoJson = await rootBundle.loadString('assets/sanga.geojson');
  final data = json.decode(geoJson);
  final List coords = data['coordinates'];

  final List<LatLng> points = [];

  for (final segment in coords) {
    for (final c in segment) {
      final lon = (c[0] as num).toDouble();
      final lat = (c[1] as num).toDouble();

      // Optional: Limit to 6 digits after decimal
      points.add(LatLng(
        double.parse(lat.toStringAsFixed(6)),
        double.parse(lon.toStringAsFixed(6)),
      ));
    }
  }
  return points;
}
