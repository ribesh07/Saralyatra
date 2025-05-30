import 'package:flutter/material.dart';

class BusRoutesList extends StatelessWidget {
  final List<Map<String, dynamic>> routes = [
    {
      'busNo': 'BA-01-1234',
      'route': 'Bhaktapur - Chakrapath',
      'driverId': 'DRV001',
      'active': true,
    },
    {
      'busNo': 'BA-02-5678',
      'route': 'Gongabu - Lagankhel',
      'driverId': 'DRV002',
      'active': false,
    },
    {
      'busNo': 'BA-03-4321',
      'route': 'Sundhara - Kalanki',
      'driverId': 'DRV003',
      'active': true,
    },
    {
      'busNo': 'BA-04-8765',
      'route': 'Koteshwor - Patan',
      'driverId': 'DRV004',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: route['active'] ? Colors.green : Colors.red,
              child: Icon(Icons.directions_bus, color: Colors.white),
            ),
            title: Text('Bus No: ${route['busNo']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Route: ${route['route']}'),
                Text('Driver ID: ${route['driverId']}'),
              ],
            ),
            trailing: Text(
              route['active'] ? 'Active' : 'Inactive',
              style: TextStyle(
                color: route['active'] ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
