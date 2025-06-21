// // import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:mapbox/route_map.dart';

// const backgroundColor = Color.fromARGB(255, 213, 227, 239);
// const textcolor = Color.fromARGB(255, 17, 16, 17);
// const appbarcolor = Color.fromARGB(255, 39, 136, 228);
// const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
// const listColor = Color.fromARGB(255, 153, 203, 238);

// enum BusInfo { busA, busB }

// class BusControlPanel extends StatefulWidget {
//   @override
//   _BusControlPanelState createState() => _BusControlPanelState();
// }

// class _BusControlPanelState extends State<BusControlPanel> {
//   final List<Map<String, dynamic>> routes = [
//     {
//       'busNo': 'BA-01-1234',
//       'route': 'Pashupati - Kalanki - Koteshwor',
//       'driverId': 'DRV001',
//       'active': true,
//     },
//     {
//       'busNo': 'BA-02-5678',
//       'route': 'Koteshwor - Bhaktapur - Sanga',
//       'driverId': 'DRV002',
//       'active': false,
//     },
//     {
//       'busNo': 'BA-03-4321',
//       'route': 'Koteshwor - Kalanki - Pashupati',
//       'driverId': 'DRV003',
//       'active': true,
//     },
//     {
//       'busNo': 'BA-04-8765',
//       'route': 'Sanga - Bhaktapur - Koteshwor',
//       'driverId': 'DRV004',
//       'active': false,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Get the first active bus
//     final activeBus = routes.firstWhere(
//       (bus) => bus['active'] == true,
//       orElse: () => <String, dynamic>{},
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bus Route'),
//         backgroundColor: appbarcolor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           height: double.infinity,
//           width: double.infinity,
//           child: Column(children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: routes.length,
//                 itemBuilder: (context, index) {
//                   final route = routes[index];

//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             if (route['route'] ==
//                                 'Pashupati - Kalanki - Koteshwor') {
//                               return RouteMapPage(data: 'mahasagar');
//                             } else if (route['route'] ==
//                                 'Koteshwor - Bhaktapur - Sanga') {
//                               return RouteMapPage(data: 'sanga');
//                             } else if (route['route'] ==
//                                 'Koteshwor - Kalanki - Pashupati') {
//                               return RouteMapPage(data: 'mahasagar');
//                             } else if (route['route'] ==
//                                 'Sanga - Bhaktapur - Koteshwor') {
//                               return RouteMapPage(data: 'sanga');
//                             }
//                             return Container(); // Fallback
//                           },
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 5,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Column(
//                             children: [
//                               Text(route['busNo']),
//                               Text(route['route']),
//                               Text(route['driverId']),
//                               Text(
//                                 route['active'] ? 'Active' : 'Inactive',
//                                 style: TextStyle(
//                                   color: route['active']
//                                       ? Colors.green
//                                       : Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.red,
//                             child: Icon(Icons.location_on,
//                                 color: Colors.white, size: 30),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             SizedBox(height: 20),

//             // Active Bus Info Card
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 elevation: 10,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Color.fromARGB(255, 248, 249, 251),
//                   ),
//                   padding: EdgeInsets.all(10),
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: activeBus == null
//                       ? Center(
//                           child: Text(
//                             "No active bus available",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text('🚌',
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold)),
//                                 Text('🚍',
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold)),
//                                 Text('📍',
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold)),
//                                 Text('👨‍✈️',
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(" Active Bus: Yes",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                                 SizedBox(height: 8),
//                                 Text(" Bus No: ${activeBus['busNo']}",
//                                     style: TextStyle(fontSize: 18)),
//                                 Text(" Route: ${activeBus['route']}",
//                                     style: TextStyle(fontSize: 18)),
//                                 Text(" Driver ID: ${activeBus['driverId']}",
//                                     style: TextStyle(fontSize: 18)),
//                               ],
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:mapbox/route_map.dart';

const backgroundColor = Color.fromARGB(255, 213, 227, 239);
const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);

class BusControlPanel extends StatefulWidget {
  @override
  _BusControlPanelState createState() => _BusControlPanelState();
}

class _BusControlPanelState extends State<BusControlPanel> {
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

  void _navigateToMap(String routeName) {
    Widget page;
    if (routeName.contains('Pashupati') || routeName.contains('Kalanki')) {
      page = RouteMapPage(data: 'mahasagar');
    } else if (routeName.contains('Bhaktapur') || routeName.contains('Sanga')) {
      page = RouteMapPage(data: 'sanga');
    } else {
      page = RouteMapPage(data: 'unknown');
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeBuses = routes.where((bus) => bus['active'] == true).toList();
    final inactiveBuses =
        routes.where((bus) => bus['active'] == false).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Route'),
        backgroundColor: appbarcolor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Active Buses",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: activeBuses.length,
                itemBuilder: (context, index) {
                  final bus = activeBuses[index];
                  return GestureDetector(
                    onTap: () => _navigateToMap(bus['route']),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading:
                            Icon(Icons.directions_bus, color: Colors.green),
                        title: Text(bus['busNo']),
                        subtitle:
                            Text("${bus['route']}\nDriver: ${bus['driverId']}"),
                        isThreeLine: true,
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.location_on,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text("Inactive Buses",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: inactiveBuses.length,
                itemBuilder: (context, index) {
                  final bus = inactiveBuses[index];
                  return Card(
                    color: Colors.grey[200],
                    elevation: 1,
                    child: ListTile(
                      enabled: false,
                      leading: Icon(Icons.directions_bus, color: Colors.red),
                      title: Text(bus['busNo'],
                          style: TextStyle(color: Colors.grey)),
                      subtitle: Text(
                        "${bus['route']}\nDriver: ${bus['driverId']}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      isThreeLine: true,
                      trailing: Icon(Icons.block, color: Colors.grey),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
