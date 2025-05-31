import 'package:flutter/material.dart';
// import 'package:mapbox/main.dart';
// import 'package:mapbox/main.dart';
import 'package:mapbox/route_map.dart';

enum BusInfo { busA, busB }

class BusControlPanel extends StatefulWidget {
  @override
  _BusControlPanelState createState() => _BusControlPanelState();
}

class _BusControlPanelState extends State<BusControlPanel> {
  bool isBhaktapurActive = false;
  bool isChakrapathActive = false;
  final List<Map<String, dynamic>> routes = [
    {
      'busNo': 'BA-01-1234',
      'route': 'Pashupati - Kalanki - Koteshwor',
      'driverId': 'DRV001',
      'active': true,
    },
    {
      'busNo': 'BA-02-5678',
      'route': 'Koteshwor - Bhaktapur - Sanga',
      'driverId': 'DRV002',
      'active': false,
    },
    {
      'busNo': 'BA-03-4321',
      'route': 'Koteshwor - Kalanki - Pashupati',
      'driverId': 'DRV003',
      'active': true,
    },
    {
      'busNo': 'BA-04-8765',
      'route': 'Sanga - Bhaktapur - Koteshwor',
      'driverId': 'DRV004',
      'active': false,
    },
  ];

  // Simulating an active bus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Route'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          Expanded(
              child: ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (route['route'] ==
                            'Pashupati - Kalanki - Koteshwor') {
                          return RouteMapPage(data: 'mahasagar');
                        } else if (route['route'] ==
                            'Koteshwor - Bhaktapur - Sanga') {
                          return RouteMapPage(
                            data: 'sanga',
                          );
                        } else if (route['route'] ==
                            'Koteshwor - Kalanki - Pashupati') {
                          return RouteMapPage(data: 'mahasagar');
                        } else if (route['route'] ==
                            'Sanga - Bhaktapur - Koteshwor') {
                          return RouteMapPage(
                            data: 'sanga',
                          );
                        }
                        return Container(); // Fallback
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 239, 118),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(route['busNo']),
                          Text(route['route']),
                          Text(route['driverId']),
                          Text(
                            route['active'] ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color:
                                  route['active'] ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ), // Chakrapath Button
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.location_on,
                            color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),

          // Spacer to push the button to the bottom
          SizedBox(height: 20),
          // Bus Info Card
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // ignore: deprecated_member_use
              color: Colors.red.withOpacity(0.9),
            ),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              margin: EdgeInsets.only(
                bottom: 40,
              ),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '🚌',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '🚍',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '📍',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '👨‍✈️',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" Active Bus: Yes",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(" Bus No: BA-12-3456",
                          style: TextStyle(fontSize: 18)),
                      Text(" Route: Bhaktapur - Chakrapath",
                          style: TextStyle(fontSize: 18)),
                      Text(" Driver ID: DRV1023",
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
