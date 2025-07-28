import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:saralyatra/mapbox/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'map_services.dart';

const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);

class RouteMapPage extends StatefulWidget {
  final String data;
  RouteMapPage({required this.data});
  @override
  _RouteMapPageState createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  // late final MapController _mapController;
  MapController _mapController = MapController();
  // final dataPath = widget.data;

  String accessToken = dotenv.get('MAPBOX_API');

  late WebSocketChannel channel;
  // int selectedIndex = 0;
  // String selectedMap = "";
  bool isConnected = false;
  // bool isOnline = false;
  String? address = "";
  List<dynamic> drivers = [];

  @override
  void initState() {
    super.initState();

    connectToWebSocket();
    print(accessToken);

    // Load route points on startup
    loadRouteFromGeoJson(widget.data).then((points) {
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

    Geolocator.requestPermission();
    Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high)
        .then((position) {
      context
          .read<RouteProvider>()
          .setUserLocation(LatLng(position.latitude, position.longitude));

      print(
        "Current Position: ${position.latitude}, ${position.longitude}",
      );
    }).catchError((e) {
      print("Error getting location: $e");
    });

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    // Get current position and listen to updates
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
          accuracy: geolocator.LocationAccuracy.best, distanceFilter: 5),
    ).listen((Position position) {
      if (position.longitude != 0.0 &&
          position.latitude != 0.0 &&
          context.mounted) {
        context
            .read<RouteProvider>()
            .setUserLocation(LatLng(position.latitude, position.longitude));
      }
    });

    //Driver location
  }

  @override
  void dispose() {
    // timer?.cancel();
    channel.sink.close();
    super.dispose();
  }

  void connectToWebSocket() async {
    const serverUrl =
        // 'wss://saralyatra-socket.onrender.com';
        'wss://saralyatra-socket.onrender.com';
    if (isConnected) {
      print("Already connected to $serverUrl");
      return;
    }
    try {
      Geolocator.requestPermission();

      channel = WebSocketChannel.connect(Uri.parse(serverUrl));
      isConnected = true;
      print("Connected to $serverUrl");
      channel.sink.add(jsonEncode({"type": "IDENTIFY", "role": "User"}));

      channel.stream.listen((data) {
        final message = jsonDecode(data);
        if (message['type'] == 'DRIVER_LIST') {
          setState(() {
            drivers = message['drivers'];
          });
          debugPrint("Drivers: $drivers");
          //  context.read<RouteProvider>().setDriverLocation(location);
        }
      });
    } catch (e) {
      print(" Connection failed: $e. Retrying...");
      await Future.delayed(const Duration(seconds: 5));
      connectToWebSocket();
    }
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

        // Only move camera if location changed
        if (userLoc != null && userLoc != previousLoc) {
          previousLoc = userLoc;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mapController.move(userLoc, 15.0);
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('map route'),
            backgroundColor: appbarcolor,
            actions: [
              IconButton(
                icon: Icon(Icons.gps_fixed_rounded),
                onPressed: () {
                  // _initLocation();
                  _determinePosition();
                  debugPrint("User location: $userLoc");
                  if (userLoc != null) {
                    _mapController.move(userLoc, 13.0);
                  }
                },
              )
            ],
          ),
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
                      child: Icon(Icons.person_pin_circle,
                          color: Colors.orange, size: 40),
                    ),
                  ],
                ),
              // Driver Markers
              if (drivers.isNotEmpty)
                MarkerLayer(
                  markers: drivers.map((driver) {
                    final lat = driver['latitude'];
                    final lng = driver['longitude'];
                    final username = driver['username'] ?? driver['phone'];

                    return Marker(
                      point: LatLng(lat, lng),
                      width: 60,
                      height: 60,
                      child: Column(
                        children: [
                          Icon(Icons.directions_bus_rounded,
                              color: const Color.fromARGB(255, 228, 62, 62),
                              size: 36),
                          Text(
                            username,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
