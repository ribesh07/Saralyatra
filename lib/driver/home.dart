// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:latlong2/latlong.dart';
import 'package:saralyatra/driver/toggleer.dart';
import 'package:saralyatra/mapbox/route_map.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:saralyatra/setups.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? name;
  String? drivername;
  String? userid;
  String? driverID;

  // ADD THIS LINE

  bool isLoading = true;

  Timer? timer;
  late WebSocketChannel channel;
  int selectedIndex = 0;
  String selectedMap = "";
  bool isConnected = false;
  bool isOnline = false;
  String? address = "";
  List<dynamic> drivers = [];
  final List<Map<String, dynamic>> items = [
    {
      'busNo': 'BA-01-1234',
      'label': "1",
      'title': 'Pashupati - Kalanki - Koteshwor',
      'driverId': 'DRV001',
      'active': true,
    },
    {
      'busNo': 'BA-02-5678',
      'label': '2',
      'title': 'Koteshwor - Bhaktapur - Sanga',
      'driverId': 'DRV002',
      'active': false,
    },
    {
      'busNo': 'BA-03-4321',
      'label': '3',
      'title': 'Koteshwor - Kalanki - Pashupati',
      'driverId': 'DRV003',
      'active': true,
    },
    {
      'busNo': 'BA-04-8765',
      'label': '4',
      'title': 'Sanga - Bhaktapur - Koteshwor',
      'driverId': 'DRV004',
      'active': true,
    },
  ];

  late String selectedRoute;
  addDetails() async {
    return await FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('driverDetailsDatabase')
        .collection('driverRoute')
        .doc(selectedRoute)
        .update({'routes': items});
  }
  // void openOtherApp() async {
  //   bool isInstalled = await DeviceApps.isAppInstalled('com.example.mapbox');
  //   if (isInstalled) {
  //     DeviceApps.openApp(' com.example.mapbox');
  //   } else {
  //     print("App not installed");
  //   }
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _driverData;
  LatLng? currentLocation;
  late LocationSettings locationSettings;

  void getdata() async {
    final usern = await SharedpreferenceHelper().getUserName1();
    final useid = await SharedpreferenceHelper().getDriverId();
    final driveriDD = await SharedpreferenceHelper().getDriverIdd();
    print("Driver ID is : $driveriDD");
    print("name : $usern");
    print("User ID is : $useid");
    setState(() {
      name = usern;
      driverID = driveriDD;
      userid = useid;
    });
    print("Driver ID is : $driverID");
    print("name : $name");
  }

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    _fetchDriverData();
    onTheLoad();
    // addDetails();
  }

  @override
  // void initState() {
  //   super.initState();

  //   getdata();
  // }

  void connectToWebSocket() async {
    const serverUrl =
        'wss://saralyatra-socket.onrender.com'; // Replace with your server URL
    if (isConnected) {
      print("Already connected to $serverUrl");
      return;
    }
    try {
      Geolocator.requestPermission();
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
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
      channel = WebSocketChannel.connect(Uri.parse(serverUrl));
      isConnected = true;
      print("Connected to $serverUrl");
      channel.sink.add(jsonEncode({
        "type": "IDENTIFY",
        "role": "Driver",
        "phone": "9999999999",
        "latitude": currentLocation!.latitude,
        "longitude": currentLocation!.longitude
      }));

      channel.stream.listen(
        (message) async {
          print(" Received response : $message");
        },
      );
    } catch (e) {
      print(" Connection failed: $e. Retrying...");
      await Future.delayed(const Duration(seconds: 5));
      connectToWebSocket();
    }
  }

  @override
  void dispose() {
    // timer?.cancel();
    channel.sink.close(); //should only stop with toggle need to work
    super.dispose();
  }

  void startSending() {
    // int count = 0;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var message = jsonEncode({
        "type": "IDENTIFY",
        "role": "Driver",
        "phone": _driverData?['contact'],
        "username": _driverData?['username'],
        "latitude": currentLocation!.latitude,
        "longitude": currentLocation!.longitude
      });
      channel.sink.add(message);
      // count++;
      // print('Sent: $message');
      debugPrint("Message sent: $message");
    });

    channel.stream.listen((data) {
      final message = jsonDecode(data);
      if (message['type'] == 'DRIVER_LIST') {
        setState(() {
          drivers = message['drivers'];
        });
        debugPrint("Drivers: $drivers");
      }
    });
    // channel.sink.add(message);
    setState(() => isOnline = true);
  }

  void stopSending() {
    timer?.cancel();
    var message = jsonEncode({
      "type": "IDENTIFY",
      "role": "Driver",
      "phone": _driverData?['contact'],
      "username": _driverData?['username'],
      "latitude": currentLocation!.latitude,
      "longitude": currentLocation!.longitude,
      "offline": "true"
    });
    channel.sink.add(message);
    channel.sink.close();
    setState(() => isOnline = false);
  }

  Future<void> _fetchDriverData() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(_currentUser!.uid)
          .get();
      setState(() {
        _driverData = userDoc.data() as Map<String, dynamic>?;
        if (_driverData != null) {
          name = _driverData!['username'];
          driverID = _driverData!['dcardId'];
          print("Driver ID is : $driverID");
        } else {
          print("No driver data found for user: ${_driverData}");
        }
      });
      print("Driver Data: $_driverData");
    }
    final localToken = await SharedpreferenceHelper().getSessionToken();
    final doc = await FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('driverDetailsDatabase')
        .collection('drivers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final serverToken = doc['sessionToken'];

    if (localToken != serverToken) {
      // Force logout — session is invalidated
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login_page()));
    }
  }

  Future<void> onTheLoad() async {
    Geolocator.checkPermission().then((status) {
      if (status == LocationPermission.denied) {
        Geolocator.requestPermission();
      }
    });

    Geolocator.requestPermission();
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "Getting location in background",
            notificationTitle: "Location Service",
            enableWakeLock: true,
          ));
    }
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });
      });
      // debugPrint("Function triggered at: ${DateTime.now()}");
      // debugPrint(
      //     " Current Location is : ${currentLocation!.latitude} , ${currentLocation!.longitude}");
    });
  }

  // Widget customCard({
  //   required String title,
  //   required VoidCallback onTap,
  //   required String label,
  //   bool isSelected = false,
  // }) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     elevation: 4,
  //     // margin: EdgeInsets.all(16),
  //     child:

  //         // padding: EdgeInsets.all(16),
  //         InkWell(
  //       onTap: onTap,
  //       child: Container(
  //         width: MediaQuery.of(context).size.width / 0.2,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           borderRadius: BorderRadius.circular(12),
  //           border:
  //               Border.all(color: Color.fromARGB(255, 223, 231, 239), width: 3),
  //           color: isSelected ? listColor : Colors.white,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Route No: $label",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             // SizedBox(height: 8),
  //             Text(
  //               title,
  //               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget customCard({
    required String title,
    required VoidCallback onTap,
    required String label,
    required int index,
    required int selectedIndex,
    required ValueChanged<int?> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: index == selectedIndex
                ? Color.fromARGB(255, 185, 221, 255)
                : Colors.white,
          ),
          child: Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: selectedIndex,
                onChanged: onChanged,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Route No: $label",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // bool isOnline = false;
  double dragPosition = .0;
  @override
  Widget build(BuildContext context) {
    const double toggleWidth = 300;
    const double toggleHeight = 50;
    const double knobSize = 35;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SwipeToggle(),
                    GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          dragPosition += details.delta.dx;
                          dragPosition =
                              dragPosition.clamp(0, toggleWidth - knobSize);
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        setState(() {
                          isOnline =
                              dragPosition > (toggleWidth - knobSize) / 2;
                          dragPosition =
                              isOnline ? toggleWidth - 1.5 * knobSize : 0;
                          if (isOnline) {
                            addDetails();
                            startSending();
                          } else {
                            addDetails();
                            stopSending();
                          }
                          //update database
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: toggleWidth,
                        height: toggleHeight,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: isOnline
                              ? Color.fromARGB(255, 3, 179, 255)
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                isOnline ? "Online" : "Offline",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 100),
                              left: dragPosition,
                              child: Container(
                                alignment: Alignment.center,
                                width: knobSize,
                                height: knobSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    //height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color.fromARGB(255, 187, 193, 197),
                          width: 3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Name : ${name?.toUpperCase()}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Driver ID : ${driverID ?? 'N/A'}'),
                            ],
                          ),
                          // Row(
                          //   children: [Text('Bus ID: '), Text('XXXXXX')],
                          // ),
                          Row(
                            children: [Text('Route: '), Text('XXXXXX')],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromARGB(255, 185, 207, 219),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Color.fromARGB(255, 134, 136, 137), width: 3),
                    ),
                    child: SizedBox(
                      height: 240,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return customCard(
                            title: items[index]['title']!,
                            label: items[index]['label'] ?? '',
                            index: index,
                            selectedIndex: selectedIndex,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                selectedRoute = items[index]['busNo']!;
                                selectedMap = items[index]['title']!;
                              });
                            },
                            onChanged: (int? value) {
                              setState(() {
                                selectedIndex = value!;
                                selectedMap = items[value]['title']!;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      child: Text('Map'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            if (selectedMap == 'Koteshwar-Kalanki-satdobato') {
                              return RouteMapPage(
                                fileName: 'mahasagar',
                              );
                            } else if (selectedMap ==
                                'Satdobato-Kalanki-koteshwar') {
                              return RouteMapPage(fileName: 'mahasagar');
                            } else if (selectedMap == 'Koteshwar-Thimi-Sanga') {
                              return RouteMapPage(fileName: 'sanga');
                            } else if (selectedMap == 'Thimi-Sanga-Koteshwar') {
                              return RouteMapPage(fileName: 'sanga');
                            } else {
                              return RouteMapPage(fileName: 'mahasagar');
                            }
                          }),
                        );

                        //Map navigations
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
