import 'dart:async';
import 'dart:convert';
// import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;

// import 'package:mapbox/routeMap.dart';

import 'package:provider/provider.dart';
import 'package:saralyatra/mapbox/provider.dart';
import 'package:saralyatra/mapbox/route_map.dart';

import 'map_services.dart';

Future<void> onTheLoad() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  Geolocator.checkPermission().then((status) {
    if (status == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
  });

  Geolocator.requestPermission();
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    print("Function triggered at: ${DateTime.now()}");
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox Directions',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();
  LatLng? currentLocation;
  List<LatLng> routePoints = [];

  final LatLng destination =
      LatLng(27.672676, 85.341719); //27.672676, 85.341719

  late LocationSettings locationSettings;

  String accessToken = dotenv.get('MAPBOX_API');
  @override
  void initState() {
    super.initState();
    loadToken();
    _initLocation();
    onTheLoad();
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
    setState(() {
      // accessToken = token;
    });
  }

  Future<void> _initLocation() async {
    loc.Location location = loc.Location();

    if (!(await location.serviceEnabled())) {
      if (!(await location.requestService())) return;
    }

    if (await location.hasPermission() == loc.PermissionStatus.denied) {
      if (await location.requestPermission() != loc.PermissionStatus.granted)
        return;
    }

    // final loc = await location.getLocation();

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: geolocator.LocationAccuracy.high,
        distanceFilter: 10,
        forceLocationManager: true,
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
        // foregroundNotificationConfig: const ForegroundNotificationConfig(
        //   notificationText: "Getting location in background",
        //   notificationTitle: "Location Service",
        //   enableWakeLock: true,
        // )
      );
    }
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    ).then((position) async {
      var accuracy = await Geolocator.getLocationAccuracy();
      print("Accuracy: $accuracy");

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      _getRoute(currentLocation!, destination);

      print("Current Position: ${position.latitude}, ${position.longitude}");
      print('destination: ${destination.latitude}, ${destination.longitude}');
      print("Route Points: $routePoints");
    }).catchError((e) {
      print("Error getting location: $e");
    });

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  Future<void> _getRoute(LatLng start, LatLng end) async {
    print("start to route: $start");
    // String accessToken = dotenv.get('MAPBOX_ACCESS_TOKEN');
    print("Access Token: $accessToken");
    // Replace this
    final url = Uri.parse(
      "https://api.mapbox.com/directions/v5/mapbox/driving/"
      "${start.longitude},${start.latitude};${end.longitude},${end.latitude}"
      "?geometries=geojson&overview=full&access_token=$accessToken",
    );
    // final url = Uri.parse(
    //     "https://api.mapbox.com/directions/v5/mapbox/driving/"
    //     "${start.longitude},${start.latitude};${end.longitude},${end.latitude}"
    //     "?geometries=geojson&overview=full&access_token=$accessToken",
    //   );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'];
      print("Route Coordinates: $coords");
      setState(() {
        routePoints = coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MapOptions mapOptions = MapOptions(
      initialCenter: currentLocation ?? LatLng(37.7749, -122.4194),
      initialZoom: 13.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Mapbox Directions"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _initLocation();
              if (currentLocation != null) {
                mapController.move(currentLocation!, 13.0);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => RouteMap(),
                    builder: (context) => RouteMapPage(fileName: 'sanga'),
                  ));
            },
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              // loadRouteFromGeoJson().then((points) {
              //   print("Loaded Route Points: $points");
              //   setState(() {
              //     routePoints = points;
              //   });
              // });
              loadRouteFromGeoJsonSanga().then((points) {
                print("Loaded Route Points: $points");
                setState(() {
                  routePoints = points;
                });
              });
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: mapOptions,
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$accessToken",
                  additionalOptions: {
                    'access_token': accessToken,
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation!,
                      width: 30,
                      height: 30,
                      child:
                          Icon(Icons.my_location, color: Colors.blue, size: 30),
                    ),
                    Marker(
                      point: destination,
                      width: 60,
                      height: 60,
                      child:
                          Icon(Icons.location_pin, color: Colors.red, size: 30),
                    ),
                  ],
                ),
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                          points: routePoints,
                          strokeWidth: 5.0,
                          color: Color.fromRGBO(27, 125, 205, 1))
                    ],
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _initLocation();
          if (currentLocation != null) {
            mapController.move(currentLocation!, 13.0);
          }
        },
        child: Icon(Icons.my_location),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
