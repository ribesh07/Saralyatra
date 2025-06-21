import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

const backgroundColor = Color.fromARGB(255, 213, 227, 239);
const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);

Future<List<LatLng>> loadRouteFromGeoJson(String data) async {
  final geoJson = await rootBundle.loadString('assets/${data}.geojson');
  final decoded = json.decode(geoJson);
  final List coords = decoded['coordinates'];

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
