import 'dart:async';
// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:latlong2/latlong.dart';

import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:saralyatra/mapbox/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'map_services.dart';

class RouteMapPage extends StatefulWidget {
  final String fileName;

  const RouteMapPage({required this.fileName, super.key});
  @override
  _RouteMapPageState createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  // late final MapController _mapController;
  MapController _mapController = MapController();
  LatLng? currentLocation;
  String accessToken = dotenv.get('MAPBOX_API');
  // late LocationSettings locationSettings; // Not available in geolocator 9.0.2

  @override
  void initState() {
    super.initState();
    // _mapController = MapController();
    loadToken();

    // Load route points on startup
    loadRouteFromGeoJson(widget.fileName).then((points) {
      context.read<RouteProvider>().setRoutePoints(points);
      // Zoom map to route
      if (points.isNotEmpty) {
        _mapController.move(points.first, 13);
      }
    });
    _initLocation();
    _requestLocationPermission();
    _determinePosition();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _determinePosition();
    } else {
      print("Location permission denied");
    }
  }

  Future<String?> getMapboxToken() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('tokens')
          .doc('mapbox')
          .get();

      if (doc.exists) {
        final data = doc.data();
        final token = data?['MAPBOX_API'];
        print("Mapbox Token: $token");
        return token;
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error fetching token: $e");
      return null;
    }
  }

  Future<void> loadToken() async {
    final token = await getMapboxToken();
    print(token);
    // setState(() {
    //   accessToken = token;
    // });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    Geolocator.requestPermission();
    Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high)
        .then((position) {
      context
          .read<RouteProvider>()
          .setUserLocation(LatLng(position.latitude, position.longitude));

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        print(currentLocation);
      });
      print(
        "Current Position: ${position.latitude}, ${position.longitude}",
      );
    }).catchError((e) {
      print("Error getting location: $e");
    });

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

    // Get current position and listen to updates (compatible with geolocator 9.0.2)
    Geolocator.getPositionStream().listen((Position position) {
      if (position.longitude != 0.0 &&
          position.latitude != 0.0 &&
          context.mounted) {}
    });
  }

  Future<void> _initLocation() async {
    Location location = Location();

    if (!(await location.serviceEnabled())) {
      if (!(await location.requestService())) return;
    }

    Geolocator.requestPermission();
    Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high)
        .then((position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        print(currentLocation);
      });
      print(
        "Current Position: ${position.latitude}, ${position.longitude}",
      );
    }).catchError((e) {
      print("Error getting location: $e");
    });

    // Listen to position stream using compatible API
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  LatLng? previousLoc;
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
        // Move map to new user location
        // Only move camera if location changed
        if (userLoc != null && userLoc != previousLoc) {
          previousLoc = userLoc;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mapController.move(userLoc, 20.0);
          });
        }
        return Scaffold(
          // backgroundColor: Colors.blue,
          appBar: AppBar(title: Text(" Route"), actions: [
            IconButton(
              icon: Icon(Icons.gps_fixed_rounded),
              onPressed: () {
                // _initLocation();
                _determinePosition();
                debugPrint("User location: $userLoc");
                if (userLoc != null) {
                  _mapController.move(currentLocation!, 13.0);
                }
              },
            ),
          ]),
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
                      strokeWidth: 5.0,
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
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.person_pin_circle,
                        color: Colors.orange,
                        size: 40,
                      ),
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
