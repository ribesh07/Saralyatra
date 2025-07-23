// // ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';

// import 'package:saralyatra/pages/seat.dart';
// import 'package:saralyatra/setups.dart';

// class SearchBus extends StatefulWidget {
//   final String location;

//   const SearchBus({
//     Key? key,
//     required this.location,
//   }) : super(key: key);
//   // const SearchBus({super.key});

//   @override
//   State<SearchBus> createState() => _SearchBusState();
// }

// class _SearchBusState extends State<SearchBus> {
//   List<dynamic> dataItems = [
//     {
//       "product": "[Bus Details1]",
//       "pricing": "[seat and price details1]",
//       "frequency": "[Description1]"
//     },
//     {
//       "product": "[Bus Details2]",
//       "pricing": "[seat and price details2]",
//       "frequency": "[Description2]"
//     },
//     {
//       "product": "[Bus Details3]",
//       "pricing": "[seat and price details3]",
//       "frequency": "[Description3]"
//     },
//     {
//       "product": "[Bus Details4]",
//       "pricing": "[seat and price details4]",
//       "frequency": "[Description4]"
//     }
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Search Bus",
//           style: textStyleappbar,
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Color.fromARGB(255, 202, 227, 247),
//         height: double.infinity,
//         width: double.infinity,
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(
//             parent: AlwaysScrollableScrollPhysics(),
//           ),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => SeatS()));
//             },
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: dataItems.length,
//                   //separatorBuilder: (_, __) => const Divider(),
//                   itemBuilder: (context, index) {
//                     return Container(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8, right: 8),
//                             child: FittedBox(
//                               child: Card(
//                                   elevation: 8,
//                                   child: Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Column(
//                                         // mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(8),
//                                             child: Container(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               height: 100,
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 color: Color.fromARGB(
//                                                     255, 104, 232, 159),
//                                               ),
//                                               child: Text(
//                                                   dataItems[index]["product"]
//                                                       .toString(),
//                                                   style: textStyle,
//                                                   textAlign: TextAlign.center),
//                                             ),
//                                           ),

//                                           DottedLine(
//                                             direction: Axis.horizontal,
//                                             dashColor: Colors.grey,
//                                             dashGapLength: 3,
//                                             lineThickness: 3,
//                                           ),

//                                           Padding(
//                                             padding: const EdgeInsets.all(8),
//                                             child: Container(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               height: 100,
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 color: Color.fromARGB(
//                                                     255, 104, 232, 159),
//                                               ),
//                                               child: Text(
//                                                   dataItems[index]["pricing"]
//                                                       .toString(),
//                                                   style: textStyle,
//                                                   textAlign: TextAlign.center),
//                                             ),
//                                           ),
//                                           // Text(
//                                           //   "   ${dataItems[index]["frequency"].toString()}",
//                                           //   style: textStyle,
//                                           // ),
//                                         ],
//                                       ))),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/pages/seat.dart';
// import 'package:saralyatra/setups.dart';

// class SearchBus extends StatefulWidget {
//   final String location;

//   const SearchBus({
//     Key? key,
//     required this.location,
//   }) : super(key: key);
//   // const SearchBus({super.key});

//   @override
//   State<SearchBus> createState() => _SearchBusState();
// }

// class _SearchBusState extends State<SearchBus> {
//   List<dynamic> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchBusDetails();
//   }

//   Future<void> fetchBusDetails() async {
//     try {
//       // Reference to the Firestore collection
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('saralyatra')
//           .doc('busTicketDetails')
//           .collection('KTM-POK') // This is where your routes are stored
//           .where('location', isEqualTo: widget.location) // Match the location
//           .get();

//       // Map the documents to dataItems
//       final List<dynamic> fetchedData = snapshot.docs.map((doc) {
//         return {
//           'product': doc['busName'],
//           'pricing': doc['price'],
//           'shift': doc['shift'], // Assuming shift is used as frequency
//           'busNumber': doc['busNumber'],
//           'busType': doc['busType'],
//         };
//       }).toList();

//       // Update state
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
//                   context, MaterialPageRoute(builder: (context) => SeatS()));
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
//                                           child: Text(
//                                             dataItems[index]["product"]
//                                                 .toString(),
//                                             style: textStyle,
//                                             textAlign: TextAlign.center,
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
//                                           child: Text(
//                                             dataItems[index]["pricing"]
//                                                 .toString(),
//                                             style: textStyle,
//                                             textAlign: TextAlign.center,
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/pages/seat.dart';
// import 'package:saralyatra/setups.dart';

// class SearchBus extends StatefulWidget {
//   final String location;

//   const SearchBus({
//     Key? key,
//     required this.location,
//   }) : super(key: key);

//   @override
//   State<SearchBus> createState() => _SearchBusState();
// }

// class _SearchBusState extends State<SearchBus> {
//   List<dynamic> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchBusDetails();
//   }

//   // Future<void> fetchBusDetails() async {
//   //   try {
//   //     // Reference to the Firestore collection
//   //     final CollectionReference routesCollection = FirebaseFirestore.instance
//   //         .collection('saralyatra')
//   //         .doc('busTicketDetails')
//   //         .collection('list of route');

//   //     // Fetch all routes from the collection
//   //     final QuerySnapshot routesSnapshot = await routesCollection.get();

//   //     // List to hold fetched data
//   //     List<dynamic> fetchedData = [];

//   //     // Iterate through each route and check if it matches the location
//   //     for (var routeDoc in routesSnapshot.docs) {
//   //       String routeName = routeDoc.id; // Get the route name (KTM-POK, etc.)
//   //       if (routeName.contains(widget.location)) {
//   //         // Check if the route name contains the location
//   //         // Fetch the details from the unique ID document
//   //         final DocumentSnapshot busDetailsDoc =
//   //             await routesCollection.doc(routeDoc.id).get();

//   //         // Map the document data to fetchedData list
//   //         fetchedData.add({
//   //           'product': busDetailsDoc['busName'], // Bus Name
//   //           'pricing': busDetailsDoc['price'], // Price
//   //           'shift': busDetailsDoc['shift'], // Shift
//   //           'busNumber': busDetailsDoc['busNumber'], // Bus Number
//   //           'busType': busDetailsDoc['busType'], // Bus Type
//   //         });
//   //       }
//   //     }

//   //     // Update state with fetched data
//   //     setState(() {
//   //       dataItems = fetchedData;
//   //     });
//   //   } catch (e) {
//   //     print('Error fetching bus details: $e');
//   //   }
//   // }
//   Future<void> fetchBusDetails() async {
//     try {
//       // Reference to the Firestore collection
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('saralyatra')
//           .doc('busTicketDetails')
//           .collection('busTicketDetails')
//           .get();

//       // List to hold fetched data
//       List<dynamic> fetchedData = [];

//       // Debugging: Check the location parameter
//       print('Location parameter: ${widget.location}');

//       // Iterate through each document in the snapshot
//       for (var doc in snapshot.docs) {
//         // Debugging: Check each document ID
//         print('Checking document ID: ${doc.id}');

//         // Check if the document ID matches the location
//         if (doc.id == widget.location) {
//           print('Matching route found: ${doc.id}'); // Debugging

//           // Map the document data to fetchedData list
//           fetchedData.add({
//             'product': doc['busName'], // Bus Name
//             'pricing': doc['price'], // Price
//             'shift': doc['shift'], // Shift
//             'busNumber': doc['busNumber'], // Bus Number
//             'busType': doc['busType'], // Bus Type
//           });
//         }
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
//                   context, MaterialPageRoute(builder: (context) => SeatS()));
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
//                                           child: Text(
//                                             dataItems[index]["product"]
//                                                 .toString(),
//                                             style: textStyle,
//                                             textAlign: TextAlign.center,
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
//                                           child: Text(
//                                             dataItems[index]["pricing"]
//                                                 .toString(),
//                                             style: textStyle,
//                                             textAlign: TextAlign.center,
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
import 'package:dotted_line/dotted_line.dart';
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
  var uniqueID;
  var busNameP;
  var shiftP;
  var depMinP;
  var depHrP;
  var arrMinP;
  var arrHrP;
  var price;
  var busUniqueID;

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
          .collection(widget.location); // Use location parameter here

      // Fetch the documents in the subcollection
      final QuerySnapshot snapshot = await busTicketDetailsCollection.get();

      // List to hold fetched data
      List<dynamic> fetchedData = [];

      // Debugging: Check the location parameter
      print('Location parameter: ${widget.location}');

      // Iterate through each document in the snapshot
      for (var doc in snapshot.docs) {
        // Debugging: Check each document ID
        print('Checking document ID: ${doc.id}');
        uniqueID = doc.id;
        busUniqueID = doc.id;

        busNameP = doc['busName'];
        shiftP = doc['shift'];
        depMinP = doc['depTimeMin'];
        depHrP = doc['depTimeHr'];
        arrMinP = doc['arrTimeMin'];
        arrHrP = doc['arrTimeHr'];
        price = doc['price'];

        // Map the document data to fetchedData list
        fetchedData.add({
          'product': doc['busName'], // Bus Name
          'pricing': doc['price'], // Price
          'shift': doc['shift'], // Shift
          'busNumber': doc['busNumber'], // Bus Number
          'busType': doc['busType'],
          'depMin': doc['depTimeMin'], // Bus Type
          'depHr': doc['depTimeHr'], // Bus Type
          'arrMin': doc['arrTimeMin'], // Bus Type
          'arrHr': doc['arrTimeHr'], // Bus Type
          'busUniqueID': uniqueID,
        });
      }

      // Check if any data was fetched
      if (fetchedData.isEmpty) {
        print('No matching routes found.'); // Debugging
      } else {
        print('Fetched data: $fetchedData'); // Debugging
      }

      // Update state with fetched data
      setState(() {
        dataItems = fetchedData;
      });
    } catch (e) {
      print('Error fetching bus details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Bus", style: textStyleappbar),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 202, 227, 247),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeatS(
                            uniqueIDs: uniqueID.toString(),
                            busName: busNameP.toString(),
                            shift: shiftP.toString(),
                            depMin: depMinP.toString(),
                            depHr: depHrP.toString(),
                            arrMin: arrMinP.toString(),
                            arrHr: arrHrP.toString(),
                            price: price.toString(),
                            date: widget.date,
                            busUniqueID: busUniqueID,
                            userID: widget.userId,
                            location: widget.location,
                          )));
            },
            child: Column(
              children: [
                SizedBox(height: 10),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: FittedBox(
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color.fromARGB(
                                                255, 104, 232, 159),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  dataItems[index]["product"]
                                                      .toString(),
                                                  style: textStyle,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      dataItems[index]
                                                              ["busType"]
                                                          .toString(),
                                                      style: textStyle,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      dataItems[index]["shift"]
                                                          .toString(),
                                                      style: textStyle,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      DottedLine(
                                        direction: Axis.horizontal,
                                        dashColor: Colors.grey,
                                        dashGapLength: 3,
                                        lineThickness: 3,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color.fromARGB(
                                                255, 104, 232, 159),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dataItems[index]["depHr"]
                                                          .toString(),
                                                      style: textStyle,
                                                    ),
                                                    Text(" : "),
                                                    Text(
                                                      dataItems[index]["depMin"]
                                                          .toString(),
                                                      style: textStyle,
                                                    ),
                                                    Text(
                                                      " ---------> ",
                                                      style: textStyle,
                                                    ),
                                                    Text(
                                                      dataItems[index]["arrHr"]
                                                          .toString(),
                                                      style: textStyle,
                                                    ),
                                                    Text(" : "),
                                                    Text(
                                                      dataItems[index]["arrMin"]
                                                          .toString(),
                                                      style: textStyle,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      dataItems[index]
                                                              ["pricing"]
                                                          .toString(),
                                                      style: textStyle,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
