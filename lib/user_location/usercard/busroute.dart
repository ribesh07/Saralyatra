import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../route_map.dart';

const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);

class BusControlPanel extends StatefulWidget {
  @override
  _BusControlPanelState createState() => _BusControlPanelState();
}

class _BusControlPanelState extends State<BusControlPanel> {
  List<Map<String, dynamic>> routes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllDriverRoutes();
  }

  /// Fetch all routes from Firestore
  Future<void> fetchAllDriverRoutes() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('driverRoute')
          .get();
      print("Fetching routes from Firestore... $snapshot");

      final List<Map<String, dynamic>> fetchedRoutes = snapshot.docs.map((doc) {
        final data = doc.data();
        print("Fetched Route Data: $data");
        return {
          'busNo': data['busNo'] ?? 'Unknown',
          'route': data['title'] ?? 'No route',
          'status': data['status'] ?? false, // Firestore field 'active'
        };
      }).toList();

      setState(() {
        routes = fetchedRoutes;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching routes: $e');
      setState(() => isLoading = false);
    }
  }

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
    final activeBuses = routes.where((bus) => bus['status'] == true).toList();
    final inactiveBuses =
        routes.where((bus) => bus['status'] == false).toList();
    print("Active Buses: $activeBuses");
    print("Inactive Buses: $inactiveBuses");

    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Route'),
        backgroundColor: appbarcolor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Active Buses",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildBusList(activeBuses, active: true),
                    SizedBox(height: 20),
                    Text("Inactive Buses",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildBusList(inactiveBuses, active: false),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBusList(List<Map<String, dynamic>> buses,
      {required bool active}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: buses.length,
      itemBuilder: (context, index) {
        final bus = buses[index];
        return GestureDetector(
          onTap: active ? () => _navigateToMap(bus['route']) : null,
          child: Card(
            elevation: active ? 4 : 1,
            color: active ? null : Colors.grey[200],
            child: ListTile(
              enabled: active,
              leading: Icon(Icons.directions_bus,
                  color: active ? Colors.green : Colors.red),
              title: Text(
                bus['busNo'],
                style: TextStyle(color: active ? Colors.black : Colors.grey),
              ),
              subtitle: Text(bus['route']),
              trailing: active
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.location_on,
                            color: Colors.white, size: 20),
                      ),
                    )
                  : Icon(Icons.block, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
