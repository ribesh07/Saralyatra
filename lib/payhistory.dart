// // ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';

// class Payhistory extends StatefulWidget {
//     final List<Map<String,String>> items;

//   const Payhistory({super.key,required this.items});

//   @override
//   State<Payhistory> createState() => _PayhistoryState();
// }

// class _PayhistoryState extends State<Payhistory> {
//   final List<Map<String, String>> payList = [
//     {
//       "Passengers": "128883",
//       "Amount": "2000.00",
//       "Date": "25-06-2023",
//     }
//   ];

//   // final List<Map<String, String>> payPassenger = [
//   //   {
//   //     "Passengers ID": "123",
//   //     "Entry": "koteshwor",
//   //     "Exit": "kalanki",
//   //     "Amount": "2000.00",
//   //   },
//   // ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Container(
//             child: Padding(
//           padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: SizedBox(
//                   height: 150,
//                   child: ListView.builder(
//                     itemCount: payList.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         color: Color.fromARGB(255, 9, 133, 164),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             //mainAxisAlignment: MainAxisAlignment.start,

//                             children: [
//                               SizedBox(
//                                 width: 15,
//                                 height: 80,
//                               ),
//                               Column(
//                                 //mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Number of passengers: ",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                   Text(
//                                     "Amount:",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                   // SizedBox(width: 50),
//                                   Text(
//                                     "Date: ",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 60),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "${payList[index]["Passengers"]}",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                   Text(
//                                     "${payList[index]["Amount"]}",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                   Text(
//                                     "${payList[index]["Date"]}",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SingleChildScrollView(
//                 physics: BouncingScrollPhysics(
//                   parent: AlwaysScrollableScrollPhysics(),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.7,
//                     child: ListView.builder(
//                       itemCount: widget.items.length,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               //mainAxisAlignment: MainAxisAlignment.start,

//                               children: [
//                                 SizedBox(
//                                   width: 15,
//                                   height: 80,
//                                 ),
//                                 Column(
//                                   //mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Passengers ID: ",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       "Entry: ",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       "Exit:",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       "Amount: ",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(width: 100),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "${widget.items[index]["Passengers ID"]}",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       "${widget.items[index]["Entry"]}",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       "${widget.items[index]["Exit"]}",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       "${widget.items[index]["Amount"]}",
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Payhistory extends StatefulWidget {
  final String date;
  final List<Map<String, String>> details;

  const Payhistory({super.key, required this.date, required this.details});

  @override
  State<Payhistory> createState() => _PayhistoryState();
}

class _PayhistoryState extends State<Payhistory> {
<<<<<<< HEAD
  final List<Map<String, String>> payList = [
    {
      "Passengers": "128883",
      "Amount": "2000.00",
      "Date": "25-06-2023",
    }
  ];

  final List<Map<String, String>> payPassenger = [
    {
      "Passengers ID": "123",
      "Entry": "koteshwor",
      "Exit": "kalanki",
      "Amount": "2000.00",
    },
    {
      "Passengers ID": "124",
      "Entry": "gaushala",
      "Exit": "kalanki",
      "Amount": "2000.00",
    },
    {
      "Passengers ID": "125",
      "Entry": "ratnapark",
      "Exit": "thimi",
      "Amount": "2000.00",
    },
    {
      "Passengers ID": "126",
      "Entry": "sanga",
      "Exit": "jadibuti",
      "Amount": "2000.00",
    },
    {
      "Passengers ID": "125",
      "Entry": "ratnapark",
      "Exit": "thimi",
      "Amount": "2000.00",
    },
    {
      "Passengers ID": "126",
      "Entry": "sanga",
      "Exit": "jadibuti",
      "Amount": "2000.00",
    },
    {
      "Passengers ID": "126",
      "Entry": "sanga",
      "Exit": "jadibuti",
      "Amount": "2000.00",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Container(
            child: Padding(
          padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: payList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color.fromARGB(255, 9, 133, 164),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              SizedBox(
                                width: 15,
                                height: 80,
                              ),
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Number of passengers: ",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Amount:",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  // SizedBox(width: 50),
                                  Text(
                                    "Date: ",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(width: 60),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${payList[index]["Passengers"]}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${payList[index]["Amount"]}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${payList[index]["Date"]}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      itemCount: payPassenger.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.start,

                              children: [
                                SizedBox(
                                  width: 15,
                                  height: 80,
                                ),
                                Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Passengers ID: ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "Entry: ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "Exit:",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "Amount: ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 100),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${payPassenger[index]["Passengers ID"]}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "${payPassenger[index]["Entry"]}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "${payPassenger[index]["Exit"]}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "${payPassenger[index]["Amount"]}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
=======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details for ${widget.date}")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                color: Color.fromARGB(255, 9, 133, 164),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Number of passengers:",
                                style: TextStyle(fontSize: 14)),
                            Text("Total Amount:",
                                style: TextStyle(fontSize: 14)),
                            Text("Date:", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${widget.details.length}",
                              style: TextStyle(fontSize: 14)),
                          Text(
                            "Rs. ${_calculateTotalAmount(widget.details)}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(widget.date, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: widget.details.length,
                  itemBuilder: (context, index) {
                    final item = widget.details[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Passenger ID: "),
                                Text("Entry:"),
                                Text("Exit:"),
                                Text("Amount: Rs."),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${item["Passengers ID"]}"),
                                Text(" ${item["Entry"]}"),
                                Text("${item["Exit"]}"),
                                Text("${item["Amount"]}")
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
>>>>>>> 2b2b1a4 (updated history)
      ),
    );
  }

  // Helper to calculate total amount
  String _calculateTotalAmount(List<Map<String, String>> details) {
    double total = 0;
    for (var item in details) {
      total += double.tryParse(item["Amount"] ?? '0') ?? 0;
    }
    return total.toStringAsFixed(2);
  }
}
