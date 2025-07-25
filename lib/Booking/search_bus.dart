import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/pages/seat.dart';
import 'package:saralyatra/setups.dart';

class SearchBus extends StatefulWidget {
  final String location;
  final String date;
  final String userId;

  const SearchBus({
    Key? key,
    required this.location,
    required this.date,
    required this.userId,
  }) : super(key: key);

  @override
  State<SearchBus> createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  List<dynamic> dataItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBusDetails();
  }

  Future<void> fetchBusDetails() async {
    try {
      print('Searching for date: ${widget.date}');
      print('Searching in location: ${widget.location}');

      // Reference to the correct bus ticket details collection path
      final CollectionReference locationCollection = FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('busTicketDetails') // Note: no 's' at the end
          .collection(widget.location);

      // Get all bus documents in this location
      final QuerySnapshot busDocsSnapshot = await locationCollection.get();

      print(
          'Found ${busDocsSnapshot.docs.length} bus documents in location ${widget.location}');

      // List to hold fetched data
      List<dynamic> fetchedData = [];

      // Iterate through each bus document (each doc represents a bus unique ID)
      for (var busDoc in busDocsSnapshot.docs) {
        try {
          String busUniqueId = busDoc.id;
          print('Checking bus with unique ID: $busUniqueId');

          // Get the data from this bus document and check if it matches the date
          final data = busDoc.data() as Map<String, dynamic>;

          // Convert database date format to match widget date format (yyyy/MM/dd)
          String dbDate = (data['date'] as String).replaceAll('-', '/');

          // Check if this bus document has data for the selected date
          if (dbDate == widget.date) {
            print(
                'Found matching bus: ${data['busName']} for date ${widget.date}');

            fetchedData.add({
              'product': data['busName'] ?? 'Unknown Bus',
              'pricing': data['price'] ?? '0',
              'shift': data['shift'] ?? 'Unknown',
              'busNumber': data['busNumber'] ?? 'N/A',
              'busType': data['bustype'] ?? 'Standard',
              'depMin': data['depTimeMin'] ?? '00',
              'depHr': data['depTimeHr'] ?? '00',
              'arrMin': data['arrTimeMin'] ?? '00',
              'arrHr': data['arrTimeHr'] ?? '00',
              'busUniqueID': data['busUId'] ?? busUniqueId,
              'availableSeats': data['avaliableSeat'] ?? 0,
              'reservedSeats': data['reservedSeat'] ?? 0,
            });
          } else {
            print(
                'Bus $busUniqueId has date ${data['date']}, not matching ${widget.date}');
          }
        } catch (e) {
          print('Error processing bus document ${busDoc.id}: $e');
          continue;
        }
      }

      // Update state with fetched data
      setState(() {
        dataItems = fetchedData;
        isLoading = false;
      });

      print(
          'Successfully loaded ${fetchedData.length} buses available for ${widget.date} on route ${widget.location}');
    } catch (e) {
      print('Error fetching bus details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTime(String hour, String minute) {
    return '${hour.padLeft(2, '0')}:${minute.padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Search Bus",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Colors.teal,
        backgroundColor: appbarcolor,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            )
          : dataItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_bus,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No buses found",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: dataItems.length,
                  itemBuilder: (context, index) {
                    final busData = dataItems[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeatS(
                                  uniqueIDs: busData['busUniqueID'].toString(),
                                  busName: busData['product'].toString(),
                                  shift: busData['shift'].toString(),
                                  depMin: busData['depMin'].toString(),
                                  depHr: busData['depHr'].toString(),
                                  arrMin: busData['arrMin'].toString(),
                                  arrHr: busData['arrHr'].toString(),
                                  price: busData['pricing'].toString(),
                                  date: widget.date,
                                  busUniqueID: busData['busUniqueID'],
                                  userID: widget.userId,
                                  location: widget.location,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bus Name and Type Header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        busData['product'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[800],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.teal[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        busData['busType'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.teal[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Time and Route Information
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Departure",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              formatTime(
                                                busData['depHr'].toString(),
                                                busData['depMin'].toString(),
                                              ),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.grey[600],
                                              size: 20,
                                            ),
                                            Container(
                                              height: 2,
                                              width: 40,
                                              color: Colors.grey[300],
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Arrival",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              formatTime(
                                                busData['arrHr'].toString(),
                                                busData['arrMin'].toString(),
                                              ),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Bottom Row with Price and Shift
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "${busData['shift']} Shift",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Rs. ${busData['pricing']}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
