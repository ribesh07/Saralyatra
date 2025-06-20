// // ignore_for_file: avoid_function_literals_in_foreach_calls, sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, prefer_typing_uninitialized_variables

// //import 'package:cloud_firestore/cloud_firestore.dart';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:saralyatra/Booking/seatbooking_form.dart';

// class ChooseSeat extends StatefulWidget {
//   const ChooseSeat({super.key});

//   @override
//   State<ChooseSeat> createState() => _ChooseSeatState();
// }

// class _ChooseSeatState extends State<ChooseSeat> {
//   // var isBooked
//   var countSeatLeft = 2 * 6;
//   var countSeatLastRow = 5;
//   var countSeatRight = 2 * 6;
//   var listSeatLeft = [];
//   var listSeatLastRow = [];
//   var listSeatRight = [];
//   int seatCount = 0;

//   @override
//   void initState() {
//     //l for left, c for center , r for right
//     //first param "listSeatLeft","listSeatCenter","listSeatRight" that similar like object temp that u want to save the data
//     // second param is for like how many seat on every side
//     // third param is for naming value every seat //look line 38
//     initSeatValueToList(listSeatLeft, countSeatLeft, "l");
//     initSeatValueToList(listSeatLastRow, countSeatLastRow, "c");
//     initSeatValueToList(listSeatRight, countSeatRight, "r");
//     //setVisiblitySeat();
//     super.initState();
//   }

//   initSeatValueToList(List data, count, side) {
//     var objectData;
//     //init variable to save your object data
//     for (int i = 0; i < count; i++) {
//       objectData = {
//         "id": side + "${i + 1}",
//         "isBooked": false,
//         "isAvailable": true,
//         "isSelected": false,
//         "isVisible": true,
//       };
//       //this format object for every seat has
//       setState(() {
//         data.add(objectData);
//         //add object to list
//       });
//     }
//     // print(data);
//   }

//   // setVisiblitySeat() {
//   //   setState(() {
//   //     listSeatLeft[0]["isVisible"] = false; // left column index 0
//   //     listSeatLeft[1]["isVisible"] = false; // left column index 1
//   //     listSeatLeft[3]["isVisible"] = false; // left column index 0
//   //     listSeatRight[1]["isVisible"] = false; // right column index 1
//   //     listSeatRight[2]["isVisible"] = false; // right column index 2
//   //     listSeatRight[5]["isVisible"] = false; // right column index 5
//   //   });
//   //   //this function to set where's the position of the seat that should be invisible
//   // }

//   setSelectedToBooked() {
//     listSeatLeft.forEach((seat) {
//       if (seat["isSelected"]) {
//         setState(() {
//           seat["isBooked"] = true;
//         });
//       }
//     });
//     listSeatLastRow.forEach((seat) {
//       if (seat["isSelected"]) {
//         setState(() {
//           seat["isBooked"] = true;
//         });
//       }
//     });
//     listSeatRight.forEach((seat) {
//       if (seat["isSelected"]) {
//         setState(() {
//           seat["isBooked"] = true;
//         });
//       }
//     });

//     //this function to loop every side of seat, from selected to booked, u also can this function to send to u'r serves side
//   }

//   seatBookReset() {
//     listSeatLeft.forEach((seat) {
//       if (seat["isBooked"] == true) {
//         setState(() {
//           seat["isBooked"] = false;
//         });
//       }
//     });
//     listSeatLastRow.forEach((seat) {
//       if (seat["isBooked"] = true) {
//         setState(() {
//           seat["isBooked"] = false;
//         });
//       }
//     });
//     listSeatRight.forEach((seat) {
//       if (seat["isBooked="] = true) {
//         setState(() {
//           seat["isBooked"] = true;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.purple,
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Colors.grey,
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text(
//                               "Booked",
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Colors.white,
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text("Selected"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(
//                                 width: 1,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text("available"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               // height: 100,
//               width: MediaQuery.of(context).size.width,

//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       widgetSeat(listSeatLeft, false),
//                       SizedBox(
//                         width: 90,
//                       ),
//                       widgetSeat(listSeatRight, false),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 2,
//                   ),
//                   Container(
//                     // width: 395,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: widgetSeat(listSeatLastRow, true),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   //debugPrint(dataSeat[index]["isBooked"]);
//                   if (seatCount != 0) {
//                     String hello = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => bookSeat(),
//                       ),
//                     );
//                     setSelectedToBooked();
//                     if (hello == 'hello') {
//                       seatBookReset();
//                     }
//                   }
//                 },
//                 child: Text("Booking"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget widgetSeat(List dataSeat, bool isCenter) {
//     return Container(
//       //width: MediaQuery.of(context).size.width / 3.93,
//       width: 150,
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: isCenter ? 5 : 2,
//           childAspectRatio: isCenter ? 1 : 1,
//         ),
//         itemCount: dataSeat.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Visibility(
//             //visible: dataSeat[index]["isVisible"],
//             child: GestureDetector(
//               onTap: () {
//                 print(dataSeat[index]["id"]);

//                 setState(() {
//                   dataSeat[index]["isSelected"] =
//                       !dataSeat[index]["isSelected"];
//                   print(dataSeat[index]["isSelected"]);
//                 });
//                 if (dataSeat[index]["isSelected"]) {
//                   seatCount++;
//                 } else {
//                   seatCount--;
//                 }
//                 print(seatCount);
//               },
//               child: Container(
//                 margin: EdgeInsets.all(5),
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: dataSeat[index]["isBooked"]
//                       ? Colors.grey
//                       : dataSeat[index]["isSelected"]
//                           ? Colors.white
//                           : Colors.transparent,
//                   border: Border.all(
//                     color: Colors.grey,
//                   ),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
