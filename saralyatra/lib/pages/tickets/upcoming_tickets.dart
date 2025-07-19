// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/pages/tickets/generate_ticket.dart';
// import 'package:saralyatra/setups.dart';

// class ticketUpcoming extends StatefulWidget {
//   const ticketUpcoming({super.key});

//   @override
//   State<ticketUpcoming> createState() => _ticketUpcomingState();
// }

// class _ticketUpcomingState extends State<ticketUpcoming> {
//   List<Map<String, dynamic>> dataItems = [];
//   String? str;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     CollectionReference userCollection = FirebaseFirestore.instance
//         .collection('saralyatra')
//         .doc('paymentDetails')
//         .collection('forUser');

//     QuerySnapshot querySnapshot = await userCollection.get();

//     setState(() {
//       dataItems = querySnapshot.docs.map((doc) {
//         return {
//           "name": doc["userName"],
//           "busName": doc["busName"],
//           "txn": doc["txnRefId"],
//           "contact": doc["contact"],
//           "date": doc["date"],
//           "departureTime": doc["departureTime"],
//           "location": doc["location"],
//           "price": doc["price"],
//           "selectedList": doc["selectedList"],
//           "uniqueBusID": doc["uniqueBusID"],
//           "userID": doc["userID"],
//         };
//       }).toList();
//       print("Data Fetched");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150.0,
//       child: ListView.builder(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         // ClampingScrollPhysics(),
//         shrinkWrap: true,
//         scrollDirection: Axis.vertical,
//         itemCount: dataItems.length,
//         itemBuilder: (BuildContext context, int index) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: FittedBox(
//             child: Card(
//               child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Text(
//                           "   ${dataItems[index]["location"].toString()}",
//                           style: textStyle,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: listColor,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                   "Date: ${dataItems[index]["date"].toString()}",
//                                   style: textStyle,
//                                   textAlign: TextAlign.center),
//                               Text(
//                                   "Time: ${dataItems[index]["departureTime"].toString()}",
//                                   style: textStyle,
//                                   textAlign: TextAlign.center),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               generateTicket(
//                                 userName:
//                                     dataItems[index]["userName"].toString(),
//                                 busName: dataItems[index]["busName"].toString(),
//                                 deptHr: dataItems[index]["departureTime"]
//                                     .toString(),
//                                 deptMin: "",
//                                 txnRefId:
//                                     dataItems[index]["txnRdfId"].toString(),
//                                 contact: dataItems[index]["contact"].toString(),
//                                 date: dataItems[index]["date"].toString(),
//                                 price: dataItems[index]["price"].toString(),
//                                 selectedList:
//                                     // dataItems[index]["selectedList"].toString(),
//                                     ["", ""],
//                                 uniqueBusID:
//                                     dataItems[index]["uniqueBusId"].toString(),
//                                 userID: dataItems[index]["userID"].toString(),
//                               );
//                             },
//                             child: Text('View Details', style: buttonStyle),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (_) {
//                                   return AlertDialog(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       title: Text("Are You Sure?"),
//                                       content: FittedBox(
//                                         child: SizedBox(
//                                           height: 100,
//                                           width: 200,
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                   'Cancellation charges will be applied'),
//                                               SizedBox(height: 10),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   TextButton(
//                                                     onPressed: () {
//                                                       //update db

//                                                       Navigator.pop(context);
//                                                       final snackBar = SnackBar(
//                                                         backgroundColor:
//                                                             Colors.green,
//                                                         elevation: 10,
//                                                         duration: Duration(
//                                                             milliseconds: 3000),
//                                                         content: const Text(
//                                                           "we will contact you soon",
//                                                           style: TextStyle(
//                                                               fontSize: 20),
//                                                         ),
//                                                       );
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(
//                                                               snackBar);
//                                                     },
//                                                     child: Text('Yes'),
//                                                   ),
//                                                   TextButton(
//                                                     onPressed: () {
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: Text('No'),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ));
//                                 },
//                               );
//                             },
//                             child: Text(
//                               'Cancel',
//                               style: buttonStyle,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   )),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/pages/tickets/generate_ticket.dart';
import 'package:saralyatra/setups.dart';

class ticketUpcoming extends StatefulWidget {
  const ticketUpcoming({super.key});

  @override
  State<ticketUpcoming> createState() => _TicketUpcomingState();
}

class _TicketUpcomingState extends State<ticketUpcoming> {
  List<Map<String, dynamic>> dataItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    CollectionReference userCollection = FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('paymentDetails')
        .collection('forUser');

    QuerySnapshot querySnapshot = await userCollection.get();

    setState(() {
      dataItems = querySnapshot.docs.map((doc) {
        return {
          "name": doc["userName"],
          "busName": doc["busName"],
          "txn": doc["txnRefId"],
          "contact": doc["contact"],
          "date": doc["date"],
          "departureTime": doc["departureTime"],
          "location": doc["location"],
          "price": doc["price"],
          "selectedList": doc["selectedList"],
          "uniqueBusID": doc["uniqueBusID"],
          "userID": doc["userID"],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: dataItems.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "   ${dataItems[index]["location"].toString()}",
                        style: textStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: listColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Date: ${dataItems[index]["date"].toString()}",
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Time: ${dataItems[index]["departureTime"].toString()}",
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            List<String> selectedList = dataItems[index]
                                    ["selectedList"]
                                .toString()
                                .split(',');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => generateTicket(
                                          userName: dataItems[index]["name"]
                                              .toString(),
                                          busName: dataItems[index]["busName"]
                                              .toString(),
                                          deptHr: dataItems[index]
                                                  ["departureTime"]
                                              .toString(),
                                          deptMin: "",
                                          txnRefId: dataItems[index]["txn"]
                                              .toString(),
                                          contact: dataItems[index]["contact"]
                                              .toString(),
                                          date: dataItems[index]["date"]
                                              .toString(),
                                          price: dataItems[index]["price"]
                                              .toString(),
                                          selectedList: selectedList,
                                          uniqueBusID: dataItems[index]
                                                  ["uniqueBusId"]
                                              .toString(),
                                          userID: dataItems[index]["userID"]
                                              .toString(),
                                        )));
                          },
                          child: Text('View Details', style: buttonStyle),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text("Are You Sure?"),
                                  content: FittedBox(
                                    child: SizedBox(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        children: [
                                          Text(
                                              'Cancellation charges will be applied'),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  //update db

                                                  Navigator.pop(context);
                                                  final snackBar = SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    elevation: 10,
                                                    duration: Duration(
                                                        milliseconds: 3000),
                                                    content: const Text(
                                                      "We will contact you soon",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                },
                                                child: Text('Yes'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('No'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Cancel', style: buttonStyle),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
