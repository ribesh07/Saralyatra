// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/pages/seat.dart';
// import 'package:saralyatra/setups.dart';

// class SearchBus extends StatefulWidget {
//   final String location;
//   final String date;
//   final String userId;

//   const SearchBus({
//     Key? key,
//     required this.location,
//     required this.date,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   State<SearchBus> createState() => _SearchBusState();
// }

// class _SearchBusState extends State<SearchBus> {
//   List<dynamic> dataItems = [];
//   var uniqueID;
//   var busNameP;
//   var shiftP;
//   var depMinP;
//   var depHrP;
//   var arrMinP;
//   var arrHrP;
//   var price;
//   var busUniqueID;

//   @override
//   void initState() {
//     super.initState();
//     fetchBusDetails();
//   }

//   Future<void> fetchBusDetails() async {
//     try {
//       // Reference to the Firestore collection
//       final CollectionReference busTicketDetailsCollection = FirebaseFirestore
//           .instance
//           .collection('saralyatra')
//           .doc('busTicketDetails')
//           .collection(widget.location); // Use location parameter here

//       // Fetch the documents in the subcollection
//       final QuerySnapshot snapshot = await busTicketDetailsCollection.get();

//       // List to hold fetched data
//       List<dynamic> fetchedData = [];

//       // Debugging: Check the location parameter
//       print('Location parameter: ${widget.location}');

//       // Iterate through each document in the snapshot
//       for (var doc in snapshot.docs) {
//         // Debugging: Check each document ID
//         print('Checking document ID: ${doc.id}');
//         uniqueID = doc.id;
//         busUniqueID = doc.id;

//         busNameP = doc['busName'];
//         shiftP = doc['shift'];
//         depMinP = doc['depTimeMin'];
//         depHrP = doc['depTimeHr'];
//         arrMinP = doc['arrTimeMin'];
//         arrHrP = doc['arrTimeHr'];
//         price = doc['price'];

//         // Map the document data to fetchedData list
//         fetchedData.add({
//           'product': doc['busName'], // Bus Name
//           'pricing': doc['price'], // Price
//           'shift': doc['shift'], // Shift
//           'busNumber': doc['busNumber'], // Bus Number
//           'busType': doc['busType'],
//           'depMin': doc['depTimeMin'], // Bus Type
//           'depHr': doc['depTimeHr'], // Bus Type
//           'arrMin': doc['arrTimeMin'], // Bus Type
//           'arrHr': doc['arrTimeHr'], // Bus Type
//           'busUniqueID': uniqueID,
//         });
//       }

//       // Check if any data was fetched
//       if (fetchedData.isEmpty) {
//         print('No matching routes found.'); // Debugging
//       } else {
//         print('Fetched data: $fetchedData'); // Debugging
//       }

//       // Update state with fetched data
//       setState(() {
//         dataItems = fetchedData;
//       });
//     } catch (e) {
//       print('Error fetching bus details: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Search Bus", style: textStyleappbar),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Color.fromARGB(255, 202, 227, 247),
//         height: double.infinity,
//         width: double.infinity,
//         child: SingleChildScrollView(
//           physics:
//               BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => SeatS(
//                             uniqueIDs: uniqueID.toString(),
//                             busName: busNameP.toString(),
//                             shift: shiftP.toString(),
//                             depMin: depMinP.toString(),
//                             depHr: depHrP.toString(),
//                             arrMin: arrMinP.toString(),
//                             arrHr: arrHrP.toString(),
//                             price: price.toString(),
//                             date: widget.date,
//                             busUniqueID: busUniqueID,
//                             userID: widget.userId,
//                             location: widget.location,
//                           )));
//             },
//             child: Column(
//               children: [
//                 SizedBox(height: 10),
//                 ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: dataItems.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8, right: 8),
//                             child: FittedBox(
//                               child: Card(
//                                 elevation: 8,
//                                 child: Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(8),
//                                         child: Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 100,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             color: Color.fromARGB(
//                                                 255, 104, 232, 159),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceAround,
//                                               children: [
//                                                 Text(
//                                                   dataItems[index]["product"]
//                                                       .toString(),
//                                                   style: textStyle,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: [
//                                                     Text(
//                                                       dataItems[index]
//                                                               ["busType"]
//                                                           .toString(),
//                                                       style: textStyle,
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                     Text(
//                                                       dataItems[index]["shift"]
//                                                           .toString(),
//                                                       style: textStyle,
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       DottedLine(
//                                         direction: Axis.horizontal,
//                                         dashColor: Colors.grey,
//                                         dashGapLength: 3,
//                                         lineThickness: 3,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8),
//                                         child: Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 100,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             color: Color.fromARGB(
//                                                 255, 104, 232, 159),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       dataItems[index]["depHr"]
//                                                           .toString(),
//                                                       style: textStyle,
//                                                     ),
//                                                     Text(" : "),
//                                                     Text(
//                                                       dataItems[index]["depMin"]
//                                                           .toString(),
//                                                       style: textStyle,
//                                                     ),
//                                                     Text(
//                                                       " ---------> ",
//                                                       style: textStyle,
//                                                     ),
//                                                     Text(
//                                                       dataItems[index]["arrHr"]
//                                                           .toString(),
//                                                       style: textStyle,
//                                                     ),
//                                                     Text(" : "),
//                                                     Text(
//                                                       dataItems[index]["arrMin"]
//                                                           .toString(),
//                                                       style: textStyle,
//                                                     )
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: 10,
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       dataItems[index]
//                                                               ["pricing"]
//                                                           .toString(),
//                                                       style: textStyle,
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      // Reference to the Firestore collection
      final CollectionReference busTicketDetailsCollection = FirebaseFirestore
          .instance
          .collection('saralyatra')
          .doc('busTicketDetails')
          .collection(widget.location);

      // Fetch the documents in the subcollection
      final QuerySnapshot snapshot = await busTicketDetailsCollection.get();

      // List to hold fetched data
      List<dynamic> fetchedData = [];

      // Iterate through each document in the snapshot
      for (var doc in snapshot.docs) {
        fetchedData.add({
          'product': doc['busName'],
          'pricing': doc['price'],
          'shift': doc['shift'],
          'busNumber': doc['busNumber'],
          'busType': doc['busType'],
          'depMin': doc['depTimeMin'],
          'depHr': doc['depTimeHr'],
          'arrMin': doc['arrTimeMin'],
          'arrHr': doc['arrTimeHr'],
          'busUniqueID': doc.id,
        });
      }

      // Update state with fetched data
      setState(() {
        dataItems = fetchedData;
        isLoading = false;
      });
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
