import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox/provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'map_services.dart';

class RouteMapPage extends StatefulWidget {
  @override
  _RouteMapPageState createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  late final MapController _mapController;

  String accessToken = dotenv.get('MAPBOX_API', fallback: 'default_token');

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Load route points on startup
    loadRouteFromGeoJson().then((points) {
      context.read<RouteProvider>().setRoutePoints(points);
      // Zoom map to route
      if (points.isNotEmpty) {
        _mapController.move(points.first, 13);
      }
    });

    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    // Get current position and listen to updates
    Geolocator.getPositionStream(
      locationSettings:
          LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 5),
    ).listen((Position position) {
      if (position.longitude != 0.0 &&
          position.latitude != 0.0 &&
          context.mounted) {
        context
            .read<RouteProvider>()
            .setUserLocation(LatLng(position.latitude, position.longitude));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
      builder: (context, routeProvider, _) {
        final points = routeProvider.routePoints;
        final userLoc = routeProvider.userLocation;

        MapOptions mapOptions = MapOptions(
          initialCenter:
              points.isNotEmpty ? points.first : LatLng(37.7749, -122.4194),
          initialZoom: 13.0,
        );
        return Scaffold(
          appBar: AppBar(title: Text("Mapbox route with flutter_map")),
          body: FlutterMap(
            mapController: _mapController,
            options: mapOptions,
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$accessToken",
                additionalOptions: {
                  'accessToken': accessToken,
                  'id': 'mapbox.streets',
                },
              ),

              // Route Polyline
              if (points.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: points,
                      strokeWidth: 4.0,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),

              // Origin marker
              // if (points.isNotEmpty)
              //   MarkerLayer(
              //     markers: [
              //       Marker(
              //         point: points.first,
              //         child: Icon(Icons.location_on,
              //             color: Colors.green, size: 40),
              //       ),
              //       // Marker(
              //       //   point: points.last,
              //       //   child: Icon(Icons.flag, color: Colors.red, size: 40),
              //       // ),
              //     ],
              //   ),

              // User location marker
              if (userLoc != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLoc,
                      child: Icon(Icons.person_pin_circle,
                          color: Colors.orange, size: 40),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
