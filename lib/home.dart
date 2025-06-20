// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

<<<<<<< HEAD
<<<<<<< HEAD
import 'package:device_apps/device_apps.dart';
import 'package:driver/main.dart';
import 'package:driver/mapbox/route_map.dart';
=======
import 'package:device_apps/device_apps.dart';
import 'package:driver/main.dart';
>>>>>>> 2b2b1a4 (updated history)
import 'package:driver/setups.dart';
import 'package:driver/toggleer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
<<<<<<< HEAD
=======
import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
>>>>>>> d40005e (feat: driver side UI)
=======
>>>>>>> 2b2b1a4 (updated history)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
<<<<<<< HEAD
  int selectedIndex = 0;
  String selectedMap = '';

  final List<Map<String, String>> items = [
    {"title": "Koteshwar-Kalanki-satdobato", "label": " 1"},
    {"title": "Satdobato-Kalanki-koteshwar", "label": "2"},
    {"title": "Koteshwar-Thimi-Sanga", "label": " 3"},
    {"title": "Thimi-Sanga-Koteshwar", "label": "4"},
  ];

  // void openOtherApp() async {
  //   bool isInstalled = await DeviceApps.isAppInstalled('com.example.mapbox');
  //   if (isInstalled) {
  //     DeviceApps.openApp(' com.example.mapbox');
  //   } else {
  //     print("App not installed");
  //   }
  // }

  Widget customCard({
    required String title,
    required VoidCallback onTap,
    required String label,
=======
  int selectedIndex = -1;

  final List<Map<String, String>> items = [
    {"title": "Koteshwar-Kalanki-satdobato"},
    {"title": "Satdobato-Kalanki-koteshwar"},
    {"title": "Koteshwar-Thimi-Sanga"},
    {"title": "Thimi-Sanga-Koteshwar"},
  ];

  Widget customCard({
    required String title,
    required VoidCallback onTap,
>>>>>>> d40005e (feat: driver side UI)
    bool isSelected = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      // margin: EdgeInsets.all(16),
      child:
<<<<<<< HEAD

=======
>>>>>>> d40005e (feat: driver side UI)
          // padding: EdgeInsets.all(16),
          InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width / 0.2,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
            border:
<<<<<<< HEAD
                Border.all(color: Color.fromARGB(255, 30, 115, 213), width: 3),
=======
            border: Border.all(color: Colors.cyan, width: 3),
>>>>>>> d40005e (feat: driver side UI)
=======
                Border.all(color: Color.fromARGB(255, 223, 231, 239), width: 3),
>>>>>>> 2b2b1a4 (updated history)
            color: isSelected ? listColor : Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
<<<<<<< HEAD
                "Route No: $label",
=======
                'Route',
>>>>>>> d40005e (feat: driver side UI)
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 8),
              Text(
                title,
<<<<<<< HEAD
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
=======
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
>>>>>>> d40005e (feat: driver side UI)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
<<<<<<< HEAD
=======
      backgroundColor: backgroundColor,
>>>>>>> 2b2b1a4 (updated history)
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
                    // Text('Offline  '),
                    // Switch(
                    //   value: isSwitched,
                    //   onChanged: (bool newValue) {
                    //     setState(() {
                    //       isSwitched = newValue;
                    //     });
                    //   },
                    //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //   activeColor: Colors.green, // Thumb color when ON
                    //   activeTrackColor: Colors.green[200], // Track color when ON
                    //   inactiveThumbColor: Colors.grey, // Thumb color when OFF
                    //   inactiveTrackColor:
                    //       Colors.grey[300], // Track color when OFF
                    // ),
                    // Text('  Online'),
                    SwipeToggle(),
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
                            children: [Text('Name: '), Text("XXXXX")],
                          ),
                          Row(
                            children: [Text('Driver ID : '), Text("XXXXX")],
                          ),
                          Row(
                            children: [Text('Bus ID: '), Text('XXXXXX')],
                          ),
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
                            isSelected: index == selectedIndex,
                            onTap: () {
                              setState(() {
                                selectedMap = items[index]['title']!;
                                print(selectedMap);
                                selectedIndex = index;
                              });
                            },
                            label: items[index]['label'] ?? "",
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
<<<<<<< HEAD
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
=======
>>>>>>> 2b2b1a4 (updated history)
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //       builder: (context) => const RouteMapPage()),
                        // );
                        print('hola');

                        //Map navigations
                      },
                    )),
              ],
            ),
=======
      body: Container(
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
                  Text('Offline  '),
                  Switch(
                    value: isSwitched,
                    onChanged: (bool newValue) {
                      setState(() {
                        isSwitched = newValue;
                      });
                    },
                    activeColor: Colors.green, // Thumb color when ON
                    activeTrackColor: Colors.green[200], // Track color when ON
                    inactiveThumbColor: Colors.grey, // Thumb color when OFF
                    inactiveTrackColor:
                        Colors.grey[300], // Track color when OFF
                  ),
                  Text('  Online'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [Text('Name: '), Text("XXXXX")],
                        ),
                        Row(
                          children: [Text('Driver ID : '), Text("XXXXX")],
                        ),
                        Row(
                          children: [Text('Bus ID: '), Text('XXXXXX')],
                        ),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.cyan, width: 3),
                  ),
                  child: SizedBox(
                    height: 240,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return customCard(
                          title: items[index]['title']!,
                          isSelected: index == selectedIndex,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
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
                  margin: const EdgeInsets.only(top: 100.0),
                  child: ElevatedButton(
                    child: Text('Map'),
                    onPressed: () {
                      //Map navigations
                    },
                  )),
            ],
>>>>>>> d40005e (feat: driver side UI)
          ),
        ),
      ),
    );
  }
}
