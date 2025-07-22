// // ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, avoid_unnecessary_containers

// //import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/seatbooking_form.dart';
// import 'package:saralyatra/pages/setups/seats_layout.dart';

// import 'package:saralyatra/setups.dart';

// class SeatS extends StatefulWidget {
//   final String uniqueIDs;
//   final String busName;
//   final String shift;
//   final String depMin;
//   final String depHr;
//   final String arrMin;
//   final String arrHr;
//   final String price;
//   final String date;

//   SeatS({
//     Key? key,
//     required this.uniqueIDs,
//     required this.busName,
//     required this.shift,
//     required this.depMin,
//     required this.depHr,
//     required this.arrMin,
//     required this.arrHr,
//     required this.price,
//     required this.date,
//   }) : super(key: key);

//   @override
//   State<SeatS> createState() => _SeatSState();
// }

// class _SeatSState extends State<SeatS> {
//   //var index = [];
//   var selectedseats = [];
//   //1st Row
//   bool _isSelectedL1 = false;
//   bool _isBookedL1 = false;
//   bool _isSelectedL2 = false;
//   bool _isbookedL2 = false;
//   bool _isSelectedR1 = false;
//   bool _isBookedR1 = false;
//   bool _isSelectedR2 = false;
//   bool _isBookedR2 = false;
//   //2nd Row
//   bool _isSelectedL3 = false;
//   bool _isBookedL3 = false;
//   bool _isSelectedL4 = false;
//   bool _isbookedL4 = false;
//   bool _isSelectedR3 = false;
//   bool _isBookedR3 = false;
//   //3rd row
//   bool _isSelectedR4 = false;
//   bool _isBookedR4 = false;
//   bool _isSelectedL5 = false;
//   bool _isBookedL5 = false;
//   bool _isSelectedL6 = false;
//   bool _isbookedL6 = false;
//   bool _isSelectedR5 = false;
//   bool _isBookedR5 = false;
//   bool _isSelectedR6 = false;
//   bool _isBookedR6 = false;
//   //4th Row
//   bool _isSelectedL7 = false;
//   bool _isBookedL7 = false;
//   bool _isSelectedL8 = false;
//   bool _isbookedL8 = false;
//   bool _isSelectedR7 = false;
//   bool _isBookedR7 = false;
//   bool _isSelectedR8 = false;
//   bool _isBookedR8 = false;
//   //5th Row
//   bool _isSelectedL9 = false;
//   bool _isBookedL9 = false;
//   bool _isSelectedL10 = false;
//   bool _isbookedL10 = false;
//   bool _isSelectedR9 = false;
//   bool _isBookedR9 = false;
//   bool _isSelectedR10 = false;
//   bool _isBookedR10 = false;
//   //6th Row
//   bool _isSelectedL11 = false;
//   bool _isBookedL11 = false;
//   bool _isSelectedL12 = false;
//   bool _isbookedL12 = false;
//   bool _isSelectedR11 = false;
//   bool _isBookedR11 = false;
//   bool _isSelectedR12 = false;
//   bool _isBookedR12 = false;
//   // last row
//   bool _isSelectedL13 = false;
//   bool _isBookedL13 = false;
//   bool _isSelectedL14 = false;
//   bool _isbookedL14 = false;
//   bool _isSelectedR13 = false;
//   bool _isBookedR13 = false;
//   bool _isSelectedR14 = false;
//   bool _isBookedR14 = false;
//   bool _isSelectedC1 = false;
//   bool _isBookedC1 = false;
// //..
// //..

//   @override
//   void initState() {
//     super.initState();
//     _blockBooked();
//   }

//   Future<void> _seatBookStoreDatabase() async {
//     final data = {
//       'bookC1': _isBookedC1,
//       'bookL1': _isBookedL1,
//       'bookL2': _isbookedL2,
//       'bookL3': _isBookedL3,
//       'bookL4': _isbookedL4,
//       'bookL5': _isBookedL5,
//       'bookL6': _isbookedL6,
//       'bookL7': _isBookedL7,
//       'bookL8': _isbookedL8,
//       'bookL9': _isBookedL9,
//       'bookL10': _isbookedL10,
//       'bookL11': _isBookedL11,
//       'bookL12': _isbookedL12,
//       'bookL13': _isBookedL13,
//       'bookL14': _isbookedL14,
//       'bookR1': _isBookedR1,
//       'bookR2': _isBookedR2,
//       'bookR3': _isBookedR3,
//       'bookR4': _isBookedR4,
//       'bookR5': _isBookedR5,
//       'bookR6': _isBookedR6,
//       'bookR7': _isBookedR7,
//       'bookR8': _isBookedR8,
//       'bookR9': _isBookedR9,
//       'bookR10': _isBookedR10,
//       'bookR11': _isBookedR11,
//       'bookR12': _isBookedR12,
//       'bookR13': _isBookedR13,
//       'bookR14': _isBookedR14,
//     };

//     // Access the Firestore instance
//     FirebaseFirestore firestore = FirebaseFirestore.instance;

//     // Reference the document in the Firestore database
//     DocumentReference documentReference = firestore
//         .collection('saralyatra')
//         .doc('busTicketDetails')
//         .collection('buses')
//         .doc(widget.uniqueIDs);

//     // Store the data in the Firestore document
//     try {
//       await documentReference.set(data);
//       print('Data stored successfully');
//     } catch (e) {
//       print('Error storing data: $e');
//     }
//   }

//   Future<void> _blockBooked() async {
//     // Access the Firestore instance
//     FirebaseFirestore firestore = FirebaseFirestore.instance;

//     // Reference the document in the Firestore database
//     DocumentReference documentReference = firestore
//         .collection('saralyatra')
//         .doc('busTicketDetails')
//         .collection('buses')
//         .doc(widget.uniqueIDs);

//     // Fetch the data from the Firestore document
//     try {
//       DocumentSnapshot documentSnapshot = await documentReference.get();

//       if (documentSnapshot.exists) {
//         Map<String, dynamic>? data =
//             documentSnapshot.data() as Map<String, dynamic>?;

//         if (data != null) {
//           setState(() {
//             _isBookedC1 = data['bookC1'] ?? false;
//             _isBookedL1 = data['bookL1'] ?? false;
//             _isbookedL2 = data['bookL2'] ?? false;
//             _isBookedL3 = data['bookL3'] ?? false;
//             _isbookedL4 = data['bookL4'] ?? false;
//             _isBookedL5 = data['bookL5'] ?? false;
//             _isbookedL6 = data['bookL6'] ?? false;
//             _isBookedL7 = data['bookL7'] ?? false;
//             _isbookedL8 = data['bookL8'] ?? false;
//             _isBookedL9 = data['bookL9'] ?? false;
//             _isbookedL10 = data['bookL10'] ?? false;
//             _isBookedL11 = data['bookL11'] ?? false;
//             _isbookedL12 = data['bookL12'] ?? false;
//             _isBookedL13 = data['bookL13'] ?? false;
//             _isbookedL14 = data['bookL14'] ?? false;
//             _isBookedR1 = data['bookR1'] ?? false;
//             _isBookedR2 = data['bookR2'] ?? false;
//             _isBookedR3 = data['bookR3'] ?? false;
//             _isBookedR4 = data['bookR4'] ?? false;
//             _isBookedR5 = data['bookR5'] ?? false;
//             _isBookedR6 = data['bookR6'] ?? false;
//             _isBookedR7 = data['bookR7'] ?? false;
//             _isBookedR8 = data['bookR8'] ?? false;
//             _isBookedR9 = data['bookR9'] ?? false;
//             _isBookedR10 = data['bookR10'] ?? false;
//             _isBookedR11 = data['bookR11'] ?? false;
//             _isBookedR12 = data['bookR12'] ?? false;
//             _isBookedR13 = data['bookR13'] ?? false;
//             _isBookedR14 = data['bookR14'] ?? false;
//           });

//           print('Data fetched successfully');
//         } else {
//           print('No data found in document');
//         }
//       } else {
//         print('Document does not exist');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

// //..
// // functions
//   //1st Row left
//   setSeatSelectedL1() {
//     setState(() {
//       if (_isBookedL1 == true) {
//         //isbooked from database to update
//         _isSelectedL1 = false;
//       } else {
//         _isSelectedL1 = !_isSelectedL1;
//       }
//     });
//   }

//   setSeatBookedL1() {
//     setState(() {
//       if (_isSelectedL1 == true) {
//         _isBookedL1 = true;
//       }
//     });
//   }

//   setSeatSelectedL2() {
//     setState(() {
//       if (_isbookedL2 == true) {
//         _isSelectedL2 = false;
//       } else {
//         _isSelectedL2 = !_isSelectedL2;
//       }
//     });
//   }

//   setSeatBookedL2() {
//     setState(() {
//       if (_isSelectedL2 == true) {
//         _isbookedL2 = true;
//       }
//     });
//   }

//   // 1st Row right
//   setSeatSelectedR1() {
//     setState(() {
//       if (_isBookedR1 == true) {
//         _isSelectedR1 = false;
//       } else {
//         _isSelectedR1 = !_isSelectedR1;
//       }
//     });
//   }

//   setSeatBookedR1() {
//     setState(() {
//       if (_isSelectedR1 == true) {
//         _isBookedR1 = true;
//       }
//     });
//   }

//   setSeatSelectedR2() {
//     setState(() {
//       if (_isBookedR2 == true) {
//         _isSelectedR2 = false;
//       } else {
//         _isSelectedR2 = !_isSelectedR2;
//       }
//     });
//   }

//   setSeatBookedR2() {
//     setState(() {
//       if (_isSelectedR2 == true) {
//         _isBookedR2 = true;
//       }
//     });
//   }

//   //2nd Row

//   //2nd Row left
//   setSeatSelectedL3() {
//     setState(() {
//       if (_isBookedL3 == true) {
//         _isSelectedL3 = false;
//       } else {
//         _isSelectedL3 = !_isSelectedL3;
//       }
//     });
//   }

//   setSeatBookedL3() {
//     setState(() {
//       if (_isSelectedL3 == true) {
//         _isBookedL3 = true;
//       }
//     });
//   }

//   setSeatSelectedL4() {
//     setState(() {
//       if (_isbookedL4 == true) {
//         _isSelectedL4 = false;
//       } else {
//         _isSelectedL4 = !_isSelectedL4;
//       }
//     });
//   }

//   setSeatBookedL4() {
//     setState(() {
//       if (_isSelectedL4 == true) {
//         _isbookedL4 = true;
//       }
//     });
//   }

//   //2nd Row right
//   setSeatSelectedR3() {
//     setState(() {
//       if (_isBookedR3 == true) {
//         _isSelectedR3 = false;
//       } else {
//         _isSelectedR3 = !_isSelectedR3;
//       }
//     });
//   }

//   setSeatBookedR3() {
//     setState(() {
//       if (_isSelectedR3 == true) {
//         _isBookedR3 = true;
//       }
//     });
//   }

//   setSeatSelectedR4() {
//     setState(() {
//       if (_isBookedR4 == true) {
//         _isSelectedR4 = false;
//       } else {
//         _isSelectedR4 = !_isSelectedR4;
//       }
//     });
//   }

//   setSeatBookedR4() {
//     setState(() {
//       if (_isSelectedR4 == true) {
//         _isBookedR4 = true;
//       }
//     });
//   }

//   // 3rd row

//   //3rd Row left

//   setSeatSelectedL5() {
//     setState(() {
//       if (_isBookedL5 == true) {
//         _isSelectedL5 = false;
//       } else {
//         _isSelectedL5 = !_isSelectedL5;
//       }
//     });
//   }

//   setSeatBookedL5() {
//     setState(() {
//       if (_isSelectedL5 == true) {
//         _isBookedL5 = true;
//       }
//     });
//   }

//   setSeatSelectedL6() {
//     setState(() {
//       if (_isbookedL6 == true) {
//         _isSelectedL6 = false;
//       } else {
//         _isSelectedL6 = !_isSelectedL6;
//       }
//     });
//   }

//   setSeatBookedL6() {
//     setState(() {
//       if (_isSelectedL6 == true) {
//         _isbookedL6 = true;
//       }
//     });
//   }

//   // 3rd Row right
//   setSeatSelectedR5() {
//     setState(() {
//       if (_isBookedR5 == true) {
//         _isSelectedR5 = false;
//       } else {
//         _isSelectedR5 = !_isSelectedR5;
//       }
//     });
//   }

//   setSeatBookedR5() {
//     setState(() {
//       if (_isSelectedR5 == true) {
//         _isBookedR5 = true;
//       }
//     });
//   }

//   setSeatSelectedR6() {
//     setState(() {
//       if (_isBookedR6 == true) {
//         _isSelectedR6 = false;
//       } else {
//         _isSelectedR6 = !_isSelectedR6;
//       }
//     });
//   }

//   setSeatBookedR6() {
//     setState(() {
//       if (_isSelectedR6 == true) {
//         _isBookedR6 = true;
//       }
//     });
//   }

//   //4th Row

//   //4th Row left
//   setSeatSelectedL7() {
//     setState(() {
//       if (_isBookedL7 == true) {
//         _isSelectedL7 = false;
//       } else {
//         _isSelectedL7 = !_isSelectedL7;
//       }
//     });
//   }

//   setSeatBookedL7() {
//     setState(() {
//       if (_isSelectedL7 == true) {
//         _isBookedL7 = true;
//       }
//     });
//   }

//   setSeatSelectedL8() {
//     setState(() {
//       if (_isbookedL8 == true) {
//         _isSelectedL8 = false;
//       } else {
//         _isSelectedL8 = !_isSelectedL8;
//       }
//     });
//   }

//   setSeatBookedL8() {
//     setState(() {
//       if (_isSelectedL8 == true) {
//         _isbookedL8 = true;
//       }
//     });
//   }

//   // 4th Row right
//   setSeatSelectedR7() {
//     setState(() {
//       if (_isBookedR7 == true) {
//         _isSelectedR7 = false;
//       } else {
//         _isSelectedR7 = !_isSelectedR7;
//       }
//     });
//   }

//   setSeatBookedR7() {
//     setState(() {
//       if (_isSelectedR7 == true) {
//         _isBookedR7 = true;
//       }
//     });
//   }

//   setSeatSelectedR8() {
//     setState(() {
//       if (_isBookedR8 == true) {
//         _isSelectedR8 = false;
//       } else {
//         _isSelectedR8 = !_isSelectedR8;
//       }
//     });
//   }

//   setSeatBookedR8() {
//     setState(() {
//       if (_isSelectedR8 == true) {
//         _isBookedR8 = true;
//       }
//     });
//   }

//   //5th Row

//   //5th Row left
//   setSeatSelectedL9() {
//     setState(() {
//       if (_isBookedL9 == true) {
//         _isSelectedL9 = false;
//       } else {
//         _isSelectedL9 = !_isSelectedL9;
//       }
//     });
//   }

//   setSeatBookedL9() {
//     setState(() {
//       if (_isSelectedL9 == true) {
//         _isBookedL9 = true;
//       }
//     });
//   }

//   setSeatSelectedL10() {
//     setState(() {
//       if (_isbookedL10 == true) {
//         _isSelectedL10 = false;
//       } else {
//         _isSelectedL10 = !_isSelectedL10;
//       }
//     });
//   }

//   setSeatBookedL10() {
//     setState(() {
//       if (_isSelectedL10 == true) {
//         _isbookedL10 = true;
//       }
//     });
//   }

//   //5th Row right
//   setSeatSelectedR9() {
//     setState(() {
//       if (_isBookedR9 == true) {
//         _isSelectedR9 = false;
//       } else {
//         _isSelectedR9 = !_isSelectedR9;
//       }
//     });
//   }

//   setSeatBookedR9() {
//     setState(() {
//       if (_isSelectedR9 == true) {
//         _isBookedR9 = true;
//       }
//     });
//   }

//   setSeatSelectedR10() {
//     setState(() {
//       if (_isBookedR10 == true) {
//         _isSelectedR10 = false;
//       } else {
//         _isSelectedR10 = !_isSelectedR10;
//       }
//     });
//   }

//   setSeatBookedR10() {
//     setState(() {
//       if (_isSelectedR10 == true) {
//         _isBookedR10 = true;
//       }
//     });
//   }

//   //6th Row

//   //6th Row left

//   setSeatSelectedL11() {
//     setState(() {
//       if (_isBookedL11 == true) {
//         _isSelectedL11 = false;
//       } else {
//         _isSelectedL11 = !_isSelectedL11;
//       }
//     });
//   }

//   setSeatBookedL11() {
//     setState(() {
//       if (_isSelectedL11 == true) {
//         _isBookedL11 = true;
//       }
//     });
//   }

//   setSeatSelectedL12() {
//     setState(() {
//       if (_isbookedL12 == true) {
//         _isSelectedL12 = false;
//       } else {
//         _isSelectedL12 = !_isSelectedL12;
//       }
//     });
//   }

//   setSeatBookedL12() {
//     setState(() {
//       if (_isSelectedL12 == true) {
//         _isbookedL12 = true;
//       }
//     });
//   }

//   // 6th Row right
//   setSeatSelectedR11() {
//     setState(() {
//       if (_isBookedR11 == true) {
//         _isSelectedR11 = false;
//       } else {
//         _isSelectedR11 = !_isSelectedR11;
//       }
//     });
//   }

//   setSeatBookedR11() {
//     setState(() {
//       if (_isSelectedR11 == true) {
//         _isBookedR11 = true;
//       }
//     });
//   }

//   setSeatSelectedR12() {
//     setState(() {
//       if (_isBookedR12 == true) {
//         _isSelectedR12 = false;
//       } else {
//         _isSelectedR12 = !_isSelectedR12;
//       }
//     });
//   }

//   setSeatBookedR12() {
//     setState(() {
//       if (_isSelectedR12 == true) {
//         _isBookedR12 = true;
//       }
//     });
//   }

//   //last Row

//   //last Row left
//   setSeatSelectedL13() {
//     setState(() {
//       if (_isBookedL13 == true) {
//         _isSelectedL13 = false;
//       } else {
//         _isSelectedL13 = !_isSelectedL13;
//       }
//     });
//   }

//   setSeatBookedL13() {
//     setState(() {
//       if (_isSelectedL13 == true) {
//         _isBookedL13 = true;
//       }
//     });
//   }

//   setSeatSelectedL14() {
//     setState(() {
//       if (_isbookedL14 == true) {
//         _isSelectedL14 = false;
//       } else {
//         _isSelectedL14 = !_isSelectedL14;
//       }
//     });
//   }

//   setSeatBookedL14() {
//     setState(() {
//       if (_isSelectedL14 == true) {
//         _isbookedL14 = true;
//       }
//     });
//   }

//   // last Row right
//   setSeatSelectedR13() {
//     setState(() {
//       if (_isBookedR13 == true) {
//         _isSelectedR13 = false;
//       } else {
//         _isSelectedR13 = !_isSelectedR13;
//       }
//     });
//   }

//   setSeatBookedR13() {
//     setState(() {
//       if (_isSelectedR13 == true) {
//         _isBookedR13 = true;
//       }
//     });
//   }

//   setSeatSelectedR14() {
//     setState(() {
//       if (_isBookedR14 == true) {
//         _isSelectedR14 = false;
//       } else {
//         _isSelectedR14 = !_isSelectedR14;
//       }
//     });
//   }

//   setSeatBookedR14() {
//     setState(() {
//       if (_isSelectedR14 == true) {
//         _isBookedR14 = true;
//       }
//     });
//   }

//   // last Row center
//   setSeatSelectedC1() {
//     setState(() {
//       if (_isBookedC1 == true) {
//         _isSelectedC1 = false;
//       } else {
//         _isSelectedC1 = !_isSelectedC1;
//       }
//     });
//   }

//   setSeatBookedC1() {
//     setState(() {
//       if (_isSelectedC1 == true) {
//         _isBookedC1 = true;
//       }
//     });
//   }

//   resetBooked() {
//     setState(() {
//       _blockBooked();
//       _isSelectedL1 = false;
//       // _isBookedL1 = false;
//       _isSelectedL2 = false;
//       // _isbookedL2 = false;
//       _isSelectedR1 = false;
//       // _isBookedR1 = false;
//       _isSelectedR2 = false;
//       // _isBookedR2 = false;
//       //2nd Row
//       _isSelectedL3 = false;
//       // _isBookedL3 = false;
//       _isSelectedL4 = false;
//       // _isbookedL4 = false;
//       _isSelectedR3 = false;
//       // _isBookedR3 = false;
//       //3rd row
//       _isSelectedR4 = false;
//       // _isBookedR4 = false;
//       _isSelectedL5 = false;
//       // _isBookedL5 = false;
//       _isSelectedL6 = false;
//       // _isbookedL6 = false;
//       _isSelectedR5 = false;
//       // _isBookedR5 = false;
//       _isSelectedR6 = false;
//       // _isBookedR6 = false;
//       //4th Row
//       _isSelectedL7 = false;
//       // _isBookedL7 = false;
//       _isSelectedL8 = false;
//       // _isbookedL8 = false;
//       _isSelectedR7 = false;
//       // _isBookedR7 = false;
//       _isSelectedR8 = false;
//       // _isBookedR8 = false;
//       //5th Row
//       _isSelectedL9 = false;
//       // _isBookedL9 = false;
//       _isSelectedL10 = false;
//       // _isbookedL10 = false;
//       _isSelectedR9 = false;
//       // _isBookedR9 = false;
//       _isSelectedR10 = false;
//       // _isBookedR10 = false;
//       //6th Row
//       _isSelectedL11 = false;
//       // _isBookedL11 = false;
//       _isSelectedL12 = false;
//       // _isbookedL12 = false;
//       _isSelectedR11 = false;
//       // _isBookedR11 = false;
//       _isSelectedR12 = false;
//       // _isBookedR12 = false;
//       // last row
//       _isSelectedL13 = false;
//       // _isBookedL13 = false;
//       _isSelectedL14 = false;
//       // _isbookedL14 = false;
//       _isSelectedR13 = false;
//       // _isBookedR13 = false;
//       _isSelectedR14 = false;
//       // _isBookedR14 = false;
//       _isSelectedC1 = false;
//       // _isBookedC1 = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Choose Seat",
//           style: textStyleappbar,
//         ),
//         backgroundColor: appbarcolor,
//       ),
//       backgroundColor: backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           physics: BouncingScrollPhysics(
//             parent: AlwaysScrollableScrollPhysics(),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Container(
//               height: 720,
//               width: MediaQuery.of(context).size.width,
//               child: FittedBox(
//                 child: Card(
//                   elevation: 50,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 10, top: 70),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "Available: ",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Container(
//                                       height: 18,
//                                       width: 18,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: Colors.grey.shade500),
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: Colors.white,
//                                       ))
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               child: Text(
//                                 "  Booked: ",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Container(
//                                 height: 18,
//                                 width: 18,
//                                 decoration: BoxDecoration(
//                                   border:
//                                       Border.all(color: Colors.grey.shade500),
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Colors.grey.shade500,
//                                 )),
//                             Container(
//                               child: Text(
//                                 "   Selected: ",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Container(
//                                 height: 18,
//                                 width: 18,
//                                 decoration: BoxDecoration(
//                                   border:
//                                       Border.all(color: Colors.grey.shade500),
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Colors.red,
//                                 )),
//                             SizedBox(
//                               width: 5,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         //1st Row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             //1st Row left
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL1();
//                                 print(_isSelectedL1);
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L1'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedL1 //from db to update
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL1
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),

//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL2();
//                                 print(_isSelectedL2);
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L2'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isbookedL2
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL2
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 90,
//                             ),
//                             // 1st Row right
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR1();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R1'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR1
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR1
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR2();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R2'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR2
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR2
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               //right gap
//                               width: 10,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         // 2nd Row
//                         Row(
//                           children: [
//                             //2nd Row left
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL3();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L3'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedL3
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL3
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL4();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L4'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isbookedL4
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL4
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 90,
//                             ),
//                             // 2nd Row right
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR3();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R3'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR3
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR3
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR4();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R4'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR4
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR4
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               //right gap
//                               width: 10,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         //3rd Row

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             //3rd Row left
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL5();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L5'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedL5
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL5
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL6();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L6'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isbookedL6
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL6
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 90,
//                             ),
//                             // 3rd Row right
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR5();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R5'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR5
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR5
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR6();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R6'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR6
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR6
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               //right gap
//                               width: 10,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         //4th Row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             //4th Row left
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL7();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L7'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedL7
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL7
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL8();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L8'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isbookedL8
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL8
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 90,
//                             ),
//                             // 4th Row right
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR7();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R7'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR7
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR7
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR8();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R8'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR8
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR8
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               //right gap
//                               width: 10,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         // 5th Row
//                         Row(
//                           children: [
//                             //5th Row left
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL9();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L9'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedL9
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL9
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL10();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L10'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isbookedL10
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL10
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 90,
//                             ),
//                             // 5th Row right
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR9();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R9'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR9
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR9
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR10();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R10'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR10
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR10
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               //right gap
//                               width: 10,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         //6th Row

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             //6th Row left
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL11();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L11'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedL11
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL11
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL12();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L12'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isbookedL12
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL12
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 90,
//                             ),
//                             // 6th Row right
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR11();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R11'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR11
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR11
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR12();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R12'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR12
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR12
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               //right gap
//                               width: 10,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),

//                         // last Row

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             //last Row left
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL13();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L13'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedL13
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL13
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedL14();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'L14'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isbookedL14
//                                         ? Colors.grey.shade500
//                                         : _isSelectedL14
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),

//                             SizedBox(
//                               width: 15,
//                             ),
//                             // last Row center
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedC1();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'C1'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedC1
//                                         ? Colors.grey.shade500
//                                         : _isSelectedC1
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 15,
//                             ),

//                             // last  Row right
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR13();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R13'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR13
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR13
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setSeatSelectedR14();
//                               },
//                               child: Container(
//                                 child: SeatsLayout(ID: 'R14'),
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.transparent),
//                                     borderRadius: BorderRadius.circular(18),
//                                     color: _isBookedR14
//                                         ? Colors.grey.shade500
//                                         : _isSelectedR14
//                                             ? Colors.red
//                                             : Colors.transparent),
//                               ),
//                             ),
//                             SizedBox(
//                               //right gap
//                               width: 10,
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 50,
//                         ),

//                         //bookButton

//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Card(
//                             elevation: 10,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(50)),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                   color: Colors.blue),
//                               child: TextButton(
//                                 onPressed: () async {
//                                   setSeatBookedL1();
//                                   setSeatBookedL2();
//                                   setSeatBookedR1();
//                                   setSeatBookedR2();
//                                   //2nd Row
//                                   setSeatBookedL3();
//                                   setSeatBookedL4();
//                                   setSeatBookedR3();
//                                   setSeatBookedR4();
//                                   //3rd Row
//                                   setSeatBookedL5();
//                                   setSeatBookedL6();
//                                   setSeatBookedR5();
//                                   setSeatBookedR6();
//                                   //4th Row
//                                   setSeatBookedL7();
//                                   setSeatBookedL8();
//                                   setSeatBookedR7();
//                                   setSeatBookedR8();
//                                   //5th Row
//                                   setSeatBookedL9();
//                                   setSeatBookedL10();
//                                   setSeatBookedR9();
//                                   setSeatBookedR10();
//                                   //6th Row
//                                   setSeatBookedL11();
//                                   setSeatBookedL12();
//                                   setSeatBookedR11();
//                                   setSeatBookedR12();
//                                   //last Row
//                                   setSeatBookedL13();
//                                   setSeatBookedL14();
//                                   setSeatBookedR13();
//                                   setSeatBookedR14();
//                                   setSeatBookedC1();

//                                   if (_isSelectedL1 == true ||
//                                       _isSelectedL2 == true ||
//                                       _isSelectedR1 ||
//                                       _isSelectedR2 ||
//                                       _isSelectedL3 == true ||
//                                       _isSelectedL4 == true ||
//                                       _isSelectedR3 ||
//                                       _isSelectedR4 ||
//                                       _isSelectedL5 == true ||
//                                       _isSelectedL6 == true ||
//                                       _isSelectedR5 ||
//                                       _isSelectedR6 ||
//                                       _isSelectedL7 == true ||
//                                       _isSelectedL8 == true ||
//                                       _isSelectedR7 ||
//                                       _isSelectedR8 ||
//                                       _isSelectedL9 == true ||
//                                       _isSelectedL10 == true ||
//                                       _isSelectedR9 ||
//                                       _isSelectedR10 ||
//                                       _isSelectedL11 == true ||
//                                       _isSelectedL12 == true ||
//                                       _isSelectedR11 ||
//                                       _isSelectedR12 ||
//                                       _isSelectedL13 == true ||
//                                       _isSelectedL14 == true ||
//                                       _isSelectedR13 ||
//                                       _isSelectedR14 ||
//                                       _isSelectedC1) {
//                                     _seatBookStoreDatabase();
//                                     String hello = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => bookSeat(
//                                           busName: widget.busName.toString(),
//                                           shift: widget.shift.toString(),
//                                           depMin: widget.depMin.toString(),
//                                           depHr: widget.depHr.toString(),
//                                           arrMin: widget.arrMin.toString(),
//                                           arrHr: widget.arrMin.toString(),
//                                           price: widget.price.toString(),
//                                           date: widget.date.toString(),
//                                         ),
//                                       ),
//                                     );

//                                     if (hello == 'hello') {
//                                       resetBooked();
//                                     }
//                                   }
//                                 },
//                                 child: Text(
//                                   'Book',
//                                   style: TextStyle(
//                                       fontSize: 15, color: Colors.black),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, avoid_unnecessary_containers

//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// i

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/Booking/seatbooking_form.dart';
import 'package:saralyatra/pages/setups/seats_layout.dart';

import 'package:saralyatra/setups.dart';

class SeatS extends StatefulWidget {
  final String uniqueIDs;
  final String busName;
  final String shift;
  final String depMin;
  final String depHr;
  final String arrMin;
  final String arrHr;
  final String price;
  final String date;
  final String busUniqueID;
  final String userID;
  final String location;

  SeatS({
    Key? key,
    required this.uniqueIDs,
    required this.busName,
    required this.shift,
    required this.depMin,
    required this.depHr,
    required this.arrMin,
    required this.arrHr,
    required this.price,
    required this.date,
    required this.busUniqueID,
    required this.userID,
    required this.location,
  }) : super(key: key);

  @override
  State<SeatS> createState() => _SeatSState();
}

class _SeatSState extends State<SeatS> {
  var selectedSeats = [];

  //1st Row
  bool _isSelectedL1 = false;
  bool _isBookedL1 = false;
  bool _isSelectedL2 = false;
  bool _isbookedL2 = false;
  bool _isSelectedR1 = false;
  bool _isBookedR1 = false;
  bool _isSelectedR2 = false;
  bool _isBookedR2 = false;
  //2nd Row
  bool _isSelectedL3 = false;
  bool _isBookedL3 = false;
  bool _isSelectedL4 = false;
  bool _isbookedL4 = false;
  bool _isSelectedR3 = false;
  bool _isBookedR3 = false;
  //3rd row
  bool _isSelectedR4 = false;
  bool _isBookedR4 = false;
  bool _isSelectedL5 = false;
  bool _isBookedL5 = false;
  bool _isSelectedL6 = false;
  bool _isbookedL6 = false;
  bool _isSelectedR5 = false;
  bool _isBookedR5 = false;
  bool _isSelectedR6 = false;
  bool _isBookedR6 = false;
  //4th Row
  bool _isSelectedL7 = false;
  bool _isBookedL7 = false;
  bool _isSelectedL8 = false;
  bool _isbookedL8 = false;
  bool _isSelectedR7 = false;
  bool _isBookedR7 = false;
  bool _isSelectedR8 = false;
  bool _isBookedR8 = false;
  //5th Row
  bool _isSelectedL9 = false;
  bool _isBookedL9 = false;
  bool _isSelectedL10 = false;
  bool _isbookedL10 = false;
  bool _isSelectedR9 = false;
  bool _isBookedR9 = false;
  bool _isSelectedR10 = false;
  bool _isBookedR10 = false;
  //6th Row
  bool _isSelectedL11 = false;
  bool _isBookedL11 = false;
  bool _isSelectedL12 = false;
  bool _isbookedL12 = false;
  bool _isSelectedR11 = false;
  bool _isBookedR11 = false;
  bool _isSelectedR12 = false;
  bool _isBookedR12 = false;
  // last row
  bool _isSelectedL13 = false;
  bool _isBookedL13 = false;
  bool _isSelectedL14 = false;
  bool _isbookedL14 = false;
  bool _isSelectedR13 = false;
  bool _isBookedR13 = false;
  bool _isSelectedR14 = false;
  bool _isBookedR14 = false;
  bool _isSelectedC1 = false;
  bool _isBookedC1 = false;
//..
//..

  @override
  void initState() {
    super.initState();
    _blockBooked();
    selectedSeats;
  }

  Future<void> _seatBookStoreDatabase() async {
    final data = {
      'bookC1': _isBookedC1,
      'bookL1': _isBookedL1,
      'bookL2': _isbookedL2,
      'bookL3': _isBookedL3,
      'bookL4': _isbookedL4,
      'bookL5': _isBookedL5,
      'bookL6': _isbookedL6,
      'bookL7': _isBookedL7,
      'bookL8': _isbookedL8,
      'bookL9': _isBookedL9,
      'bookL10': _isbookedL10,
      'bookL11': _isBookedL11,
      'bookL12': _isbookedL12,
      'bookL13': _isBookedL13,
      'bookL14': _isbookedL14,
      'bookR1': _isBookedR1,
      'bookR2': _isBookedR2,
      'bookR3': _isBookedR3,
      'bookR4': _isBookedR4,
      'bookR5': _isBookedR5,
      'bookR6': _isBookedR6,
      'bookR7': _isBookedR7,
      'bookR8': _isBookedR8,
      'bookR9': _isBookedR9,
      'bookR10': _isBookedR10,
      'bookR11': _isBookedR11,
      'bookR12': _isBookedR12,
      'bookR13': _isBookedR13,
      'bookR14': _isBookedR14,
    };

    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference the document in the Firestore database
    DocumentReference documentReference = firestore
        .collection('saralyatra')
        .doc('busTicketDetails')
        .collection('buses')
        .doc(widget.uniqueIDs);

    // Store the data in the Firestore document
    try {
      await documentReference.set(data);
      print('Data stored successfully');
    } catch (e) {
      print('Error storing data: $e');
    }
  }

  Future<void> _blockBooked() async {
    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference the document in the Firestore database
    DocumentReference documentReference = firestore
        .collection('saralyatra')
        .doc('busTicketDetails')
        .collection('buses')
        .doc(widget.uniqueIDs);

    // Fetch the data from the Firestore document
    try {
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            _isBookedC1 = data['bookC1'] ?? false;
            _isBookedL1 = data['bookL1'] ?? false;
            _isbookedL2 = data['bookL2'] ?? false;
            _isBookedL3 = data['bookL3'] ?? false;
            _isbookedL4 = data['bookL4'] ?? false;
            _isBookedL5 = data['bookL5'] ?? false;
            _isbookedL6 = data['bookL6'] ?? false;
            _isBookedL7 = data['bookL7'] ?? false;
            _isbookedL8 = data['bookL8'] ?? false;
            _isBookedL9 = data['bookL9'] ?? false;
            _isbookedL10 = data['bookL10'] ?? false;
            _isBookedL11 = data['bookL11'] ?? false;
            _isbookedL12 = data['bookL12'] ?? false;
            _isBookedL13 = data['bookL13'] ?? false;
            _isbookedL14 = data['bookL14'] ?? false;
            _isBookedR1 = data['bookR1'] ?? false;
            _isBookedR2 = data['bookR2'] ?? false;
            _isBookedR3 = data['bookR3'] ?? false;
            _isBookedR4 = data['bookR4'] ?? false;
            _isBookedR5 = data['bookR5'] ?? false;
            _isBookedR6 = data['bookR6'] ?? false;
            _isBookedR7 = data['bookR7'] ?? false;
            _isBookedR8 = data['bookR8'] ?? false;
            _isBookedR9 = data['bookR9'] ?? false;
            _isBookedR10 = data['bookR10'] ?? false;
            _isBookedR11 = data['bookR11'] ?? false;
            _isBookedR12 = data['bookR12'] ?? false;
            _isBookedR13 = data['bookR13'] ?? false;
            _isBookedR14 = data['bookR14'] ?? false;
          });

          print('Data fetched successfully');
          // print("L1: $_isBookedL1");
          // print("L2: $_isbookedL2");
          // print("L3 :$_isBookedL3");
          // print("L4 :$_isbookedL4");
          // print("L5 :$_isBookedL5");
          // print("L6 :$_isbookedL6");
          // print("L7 :$_isBookedL7");
          // print("L8 :$_isbookedL8");
          // print("L9 :$_isBookedL9");
          // print("L10 :$_isbookedL10");
          // print("L11 :$_isBookedL11");
          // print("L12 :$_isbookedL12");
          // print("L13 :$_isBookedL13");
          // print("L14 :$_isbookedL14");
          // print("C1 :$_isBookedC1");
          // print("R1 :$_isBookedR1");
          // print("R2 :$_isBookedR2");
          // print("R3 :$_isBookedR3");
          // print("R4 :$_isBookedR4");
          // print("R5 :$_isBookedR5");
          // print("R6 :$_isBookedR6");
          // print("R7 :$_isBookedR7");
          // print("R8 :$_isBookedR8");
          // print("R9 :$_isBookedR9");
          // print("R10 :$_isbookedL10");
          // print("R11 :$_isBookedL11");
          // print("R12 :$_isbookedL12");
          // print("R13 :$_isBookedL13");
          // print("R14 :$_isbookedL14");
        } else {
          print('No data found in document');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // void _toggleSeat(String seatID) {
  //   setState(() {
  //     if (selectedSeats.contains(seatID)) {
  //       selectedSeats.remove(seatID);
  //     } else {
  //       selectedSeats.add(seatID);
  //     }
  //   });
  // }

  Future<void> _bookSeats() async {
    if (selectedSeats.isNotEmpty) {
      _seatBookStoreDatabase();
      print(selectedSeats);
      String response = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => bookSeat(
            busName: widget.busName,
            shift: widget.shift,
            depMin: widget.depMin,
            depHr: widget.depHr,
            arrMin: widget.arrMin,
            arrHr: widget.arrHr,
            price: widget.price,
            date: widget.date,
            selectedSeats: selectedSeats,
            uniqueBusID: widget.busUniqueID,
            userID: widget.userID,
            location: widget.location,
          ),
        ),
      );

      if (response == 'reset') {
        setState(() {
          selectedSeats.clear(); // Reset selected seats
        });
      }
    }
  }

//..
// functions
  //1st Row left
  setSeatSelectedL1() {
    setState(() {
      if (_isBookedL1 == true) {
        //isbooked from database to update
        _isSelectedL1 = false;
      } else {
        _isSelectedL1 = !_isSelectedL1;
        if (_isSelectedL1) {
          selectedSeats.add('L1');
        } else {
          selectedSeats.remove('L1');
        }
      }
    });
  }
//    setSeatSelectedL22() {
//   setState(() {
//     if (_isBookedL1 == true) {
//       // If the seat is booked, do nothing
//       _isSelectedL1 = false;
//     } else {
//       _isSelectedL1 = !_isSelectedL1;
//       if (_isSelectedL1) {
//         selectedSeats.add('L1');
//       } else {
//         selectedSeats.remove('L1');
//       }
//     }
//   });
// }

  setSeatBookedL1() {
    setState(() {
      if (_isSelectedL1 == true) {
        _isBookedL1 = true;
      }
    });
  }

  setSeatSelectedL2() {
    setState(() {
      if (_isbookedL2 == true) {
        _isSelectedL2 = false;
      } else {
        _isSelectedL2 = !_isSelectedL2;
        if (_isSelectedL2) {
          selectedSeats.add('L2');
        } else {
          selectedSeats.remove('L2');
        }
      }
    });
  }

  setSeatBookedL2() {
    setState(() {
      if (_isSelectedL2 == true) {
        _isbookedL2 = true;
      }
    });
  }

  // 1st Row right
  setSeatSelectedR1() {
    setState(() {
      if (_isBookedR1 == true) {
        _isSelectedR1 = false;
      } else {
        _isSelectedR1 = !_isSelectedR1;
        if (_isSelectedR1) {
          selectedSeats.add('R1');
        } else {
          selectedSeats.remove('R1');
        }
      }
    });
  }

  setSeatBookedR1() {
    setState(() {
      if (_isSelectedR1 == true) {
        _isBookedR1 = true;
      }
    });
  }

  setSeatSelectedR2() {
    setState(() {
      if (_isBookedR2 == true) {
        _isSelectedR2 = false;
      } else {
        _isSelectedR2 = !_isSelectedR2;
        if (_isSelectedR2) {
          selectedSeats.add('R2');
        } else {
          selectedSeats.remove('R2');
        }
      }
    });
  }

  setSeatBookedR2() {
    setState(() {
      if (_isSelectedR2 == true) {
        _isBookedR2 = true;
      }
    });
  }

  //2nd Row

  //2nd Row left
  setSeatSelectedL3() {
    setState(() {
      if (_isBookedL3 == true) {
        _isSelectedL3 = false;
      } else {
        _isSelectedL3 = !_isSelectedL3;
        if (_isSelectedL3) {
          selectedSeats.add('L3');
        } else {
          selectedSeats.remove('L3');
        }
      }
    });
  }

  setSeatBookedL3() {
    setState(() {
      if (_isSelectedL3 == true) {
        _isBookedL3 = true;
      }
    });
  }

  setSeatSelectedL4() {
    setState(() {
      if (_isbookedL4 == true) {
        _isSelectedL4 = false;
      } else {
        _isSelectedL4 = !_isSelectedL4;
        if (_isSelectedL4) {
          selectedSeats.add('L4');
        } else {
          selectedSeats.remove('L4');
        }
      }
    });
  }

  setSeatBookedL4() {
    setState(() {
      if (_isSelectedL4 == true) {
        _isbookedL4 = true;
      }
    });
  }

  //2nd Row right
  setSeatSelectedR3() {
    setState(() {
      if (_isBookedR3 == true) {
        _isSelectedR3 = false;
      } else {
        _isSelectedR3 = !_isSelectedR3;
        if (_isSelectedR3) {
          selectedSeats.add('R3');
        } else {
          selectedSeats.remove('R3');
        }
      }
    });
  }

  setSeatBookedR3() {
    setState(() {
      if (_isSelectedR3 == true) {
        _isBookedR3 = true;
      }
    });
  }

  setSeatSelectedR4() {
    setState(() {
      if (_isBookedR4 == true) {
        _isSelectedR4 = false;
      } else {
        _isSelectedR4 = !_isSelectedR4;
        if (_isSelectedR4) {
          selectedSeats.add('R4');
        } else {
          selectedSeats.remove('R4');
        }
      }
    });
  }

  setSeatBookedR4() {
    setState(() {
      if (_isSelectedR4 == true) {
        _isBookedR4 = true;
      }
    });
  }

  // 3rd row

  //3rd Row left

  setSeatSelectedL5() {
    setState(() {
      if (_isBookedL5 == true) {
        _isSelectedL5 = false;
      } else {
        _isSelectedL5 = !_isSelectedL5;
        if (_isSelectedL5) {
          selectedSeats.add('L5');
        } else {
          selectedSeats.remove('L5');
        }
      }
    });
  }

  setSeatBookedL5() {
    setState(() {
      if (_isSelectedL5 == true) {
        _isBookedL5 = true;
      }
    });
  }

  setSeatSelectedL6() {
    setState(() {
      if (_isbookedL6 == true) {
        _isSelectedL6 = false;
      } else {
        _isSelectedL6 = !_isSelectedL6;
        if (_isSelectedL6) {
          selectedSeats.add('L6');
        } else {
          selectedSeats.remove('L6');
        }
      }
    });
  }

  setSeatBookedL6() {
    setState(() {
      if (_isSelectedL6 == true) {
        _isbookedL6 = true;
      }
    });
  }

  // 3rd Row right
  setSeatSelectedR5() {
    setState(() {
      if (_isBookedR5 == true) {
        _isSelectedR5 = false;
      } else {
        _isSelectedR5 = !_isSelectedR5;
        if (_isSelectedR5) {
          selectedSeats.add('R5');
        } else {
          selectedSeats.remove('R5');
        }
      }
    });
  }

  setSeatBookedR5() {
    setState(() {
      if (_isSelectedR5 == true) {
        _isBookedR5 = true;
      }
    });
  }

  setSeatSelectedR6() {
    setState(() {
      if (_isBookedR6 == true) {
        _isSelectedR6 = false;
      } else {
        _isSelectedR6 = !_isSelectedR6;
        if (_isSelectedR6) {
          selectedSeats.add('R6');
        } else {
          selectedSeats.remove('R6');
        }
      }
    });
  }

  setSeatBookedR6() {
    setState(() {
      if (_isSelectedR6 == true) {
        _isBookedR6 = true;
      }
    });
  }

  //4th Row

  //4th Row left
  setSeatSelectedL7() {
    setState(() {
      if (_isBookedL7 == true) {
        _isSelectedL7 = false;
      } else {
        _isSelectedL7 = !_isSelectedL7;
        if (_isSelectedL7) {
          selectedSeats.add('L7');
        } else {
          selectedSeats.remove('L7');
        }
      }
    });
  }

  setSeatBookedL7() {
    setState(() {
      if (_isSelectedL7 == true) {
        _isBookedL7 = true;
      }
    });
  }

  setSeatSelectedL8() {
    setState(() {
      if (_isbookedL8 == true) {
        _isSelectedL8 = false;
      } else {
        _isSelectedL8 = !_isSelectedL8;
        if (_isSelectedL8) {
          selectedSeats.add('L8');
        } else {
          selectedSeats.remove('L8');
        }
      }
    });
  }

  setSeatBookedL8() {
    setState(() {
      if (_isSelectedL8 == true) {
        _isbookedL8 = true;
      }
    });
  }

  // 4th Row right
  setSeatSelectedR7() {
    setState(() {
      if (_isBookedR7 == true) {
        _isSelectedR7 = false;
      } else {
        _isSelectedR7 = !_isSelectedR7;
        if (_isSelectedR7) {
          selectedSeats.add('R7');
        } else {
          selectedSeats.remove('R7');
        }
      }
    });
  }

  setSeatBookedR7() {
    setState(() {
      if (_isSelectedR7 == true) {
        _isBookedR7 = true;
      }
    });
  }

  setSeatSelectedR8() {
    setState(() {
      if (_isBookedR8 == true) {
        _isSelectedR8 = false;
      } else {
        _isSelectedR8 = !_isSelectedR8;
        if (_isSelectedR8) {
          selectedSeats.add('R8');
        } else {
          selectedSeats.remove('R8');
        }
      }
    });
  }

  setSeatBookedR8() {
    setState(() {
      if (_isSelectedR8 == true) {
        _isBookedR8 = true;
      }
    });
  }

  //5th Row

  //5th Row left
  setSeatSelectedL9() {
    setState(() {
      if (_isBookedL9 == true) {
        _isSelectedL9 = false;
      } else {
        _isSelectedL9 = !_isSelectedL9;
        if (_isSelectedL9) {
          selectedSeats.add('L9');
        } else {
          selectedSeats.remove('L9');
        }
      }
    });
  }

  setSeatBookedL9() {
    setState(() {
      if (_isSelectedL9 == true) {
        _isBookedL9 = true;
      }
    });
  }

  setSeatSelectedL10() {
    setState(() {
      if (_isbookedL10 == true) {
        _isSelectedL10 = false;
      } else {
        _isSelectedL10 = !_isSelectedL10;
        if (_isSelectedL10) {
          selectedSeats.add('L10');
        } else {
          selectedSeats.remove('L10');
        }
      }
    });
  }

  setSeatBookedL10() {
    setState(() {
      if (_isSelectedL10 == true) {
        _isbookedL10 = true;
      }
    });
  }

  //5th Row right
  setSeatSelectedR9() {
    setState(() {
      if (_isBookedR9 == true) {
        _isSelectedR9 = false;
      } else {
        _isSelectedR9 = !_isSelectedR9;
        if (_isSelectedR9) {
          selectedSeats.add('R9');
        } else {
          selectedSeats.remove('R9');
        }
      }
    });
  }

  setSeatBookedR9() {
    setState(() {
      if (_isSelectedR9 == true) {
        _isBookedR9 = true;
      }
    });
  }

  setSeatSelectedR10() {
    setState(() {
      if (_isBookedR10 == true) {
        _isSelectedR10 = false;
      } else {
        _isSelectedR10 = !_isSelectedR10;
        if (_isSelectedR10) {
          selectedSeats.add('R10');
        } else {
          selectedSeats.remove('R10');
        }
      }
    });
  }

  setSeatBookedR10() {
    setState(() {
      if (_isSelectedR10 == true) {
        _isBookedR10 = true;
      }
    });
  }

  //6th Row

  //6th Row left

  setSeatSelectedL11() {
    setState(() {
      if (_isBookedL11 == true) {
        _isSelectedL11 = false;
      } else {
        _isSelectedL11 = !_isSelectedL11;
        if (_isSelectedL11) {
          selectedSeats.add('L11');
        } else {
          selectedSeats.remove('L11');
        }
      }
    });
  }

  setSeatBookedL11() {
    setState(() {
      if (_isSelectedL11 == true) {
        _isBookedL11 = true;
      }
    });
  }

  setSeatSelectedL12() {
    setState(() {
      if (_isbookedL12 == true) {
        _isSelectedL12 = false;
      } else {
        _isSelectedL12 = !_isSelectedL12;
        if (_isSelectedL12) {
          selectedSeats.add('L12');
        } else {
          selectedSeats.remove('L12');
        }
      }
    });
  }

  setSeatBookedL12() {
    setState(() {
      if (_isSelectedL12 == true) {
        _isbookedL12 = true;
      }
    });
  }

  // 6th Row right
  setSeatSelectedR11() {
    setState(() {
      if (_isBookedR11 == true) {
        _isSelectedR11 = false;
      } else {
        _isSelectedR11 = !_isSelectedR11;
        if (_isSelectedR11) {
          selectedSeats.add('R11');
        } else {
          selectedSeats.remove('R11');
        }
      }
    });
  }

  setSeatBookedR11() {
    setState(() {
      if (_isSelectedR11 == true) {
        _isBookedR11 = true;
      }
    });
  }

  setSeatSelectedR12() {
    setState(() {
      if (_isBookedR12 == true) {
        _isSelectedR12 = false;
      } else {
        _isSelectedR12 = !_isSelectedR12;
        if (_isSelectedR12) {
          selectedSeats.add('R12');
        } else {
          selectedSeats.remove('R12');
        }
      }
    });
  }

  setSeatBookedR12() {
    setState(() {
      if (_isSelectedR12 == true) {
        _isBookedR12 = true;
      }
    });
  }

  //last Row

  //last Row left
  setSeatSelectedL13() {
    setState(() {
      if (_isBookedL13 == true) {
        _isSelectedL13 = false;
      } else {
        _isSelectedL13 = !_isSelectedL13;
        if (_isSelectedL13) {
          selectedSeats.add('L13');
        } else {
          selectedSeats.remove('L13');
        }
      }
    });
  }

  setSeatBookedL13() {
    setState(() {
      if (_isSelectedL13 == true) {
        _isBookedL13 = true;
      }
    });
  }

  setSeatSelectedL14() {
    setState(() {
      if (_isbookedL14 == true) {
        _isSelectedL14 = false;
      } else {
        _isSelectedL14 = !_isSelectedL14;
        if (_isSelectedL14) {
          selectedSeats.add('L14');
        } else {
          selectedSeats.remove('L14');
        }
      }
    });
  }

  setSeatBookedL14() {
    setState(() {
      if (_isSelectedL14 == true) {
        _isbookedL14 = true;
      }
    });
  }

  // last Row right
  setSeatSelectedR13() {
    setState(() {
      if (_isBookedR13 == true) {
        _isSelectedR13 = false;
      } else {
        _isSelectedR13 = !_isSelectedR13;
        if (_isSelectedR13) {
          selectedSeats.add('R13');
        } else {
          selectedSeats.remove('R13');
        }
      }
    });
  }

  setSeatBookedR13() {
    setState(() {
      if (_isSelectedR13 == true) {
        _isBookedR13 = true;
      }
    });
  }

  setSeatSelectedR14() {
    setState(() {
      if (_isBookedR14 == true) {
        _isSelectedR14 = false;
      } else {
        _isSelectedR14 = !_isSelectedR14;
        if (_isSelectedR14) {
          selectedSeats.add('R14');
        } else {
          selectedSeats.remove('R14');
        }
      }
    });
  }

  setSeatBookedR14() {
    setState(() {
      if (_isSelectedR14 == true) {
        _isBookedR14 = true;
      }
    });
  }

  // last Row center
  setSeatSelectedC1() {
    setState(() {
      if (_isBookedC1 == true) {
        _isSelectedC1 = false;
      } else {
        _isSelectedC1 = !_isSelectedC1;
        if (_isSelectedC1) {
          selectedSeats.add('C1');
        } else {
          selectedSeats.remove('C1');
        }
      }
    });
  }

  setSeatBookedC1() {
    setState(() {
      if (_isSelectedC1 == true) {
        _isBookedC1 = true;
      }
    });
  }

  resetBooked() {
    setState(() {
      _blockBooked();
      _isSelectedL1 = false;
      // _isBookedL1 = false;
      _isSelectedL2 = false;
      // _isbookedL2 = false;
      _isSelectedR1 = false;
      // _isBookedR1 = false;
      _isSelectedR2 = false;
      // _isBookedR2 = false;
      //2nd Row
      _isSelectedL3 = false;
      // _isBookedL3 = false;
      _isSelectedL4 = false;
      // _isbookedL4 = false;
      _isSelectedR3 = false;
      // _isBookedR3 = false;
      //3rd row
      _isSelectedR4 = false;
      // _isBookedR4 = false;
      _isSelectedL5 = false;
      // _isBookedL5 = false;
      _isSelectedL6 = false;
      // _isbookedL6 = false;
      _isSelectedR5 = false;
      // _isBookedR5 = false;
      _isSelectedR6 = false;
      // _isBookedR6 = false;
      //4th Row
      _isSelectedL7 = false;
      // _isBookedL7 = false;
      _isSelectedL8 = false;
      // _isbookedL8 = false;
      _isSelectedR7 = false;
      // _isBookedR7 = false;
      _isSelectedR8 = false;
      // _isBookedR8 = false;
      //5th Row
      _isSelectedL9 = false;
      // _isBookedL9 = false;
      _isSelectedL10 = false;
      // _isbookedL10 = false;
      _isSelectedR9 = false;
      // _isBookedR9 = false;
      _isSelectedR10 = false;
      // _isBookedR10 = false;
      //6th Row
      _isSelectedL11 = false;
      // _isBookedL11 = false;
      _isSelectedL12 = false;
      // _isbookedL12 = false;
      _isSelectedR11 = false;
      // _isBookedR11 = false;
      _isSelectedR12 = false;
      // _isBookedR12 = false;
      // last row
      _isSelectedL13 = false;
      // _isBookedL13 = false;
      _isSelectedL14 = false;
      // _isbookedL14 = false;
      _isSelectedR13 = false;
      // _isBookedR13 = false;
      _isSelectedR14 = false;
      // _isBookedR14 = false;
      _isSelectedC1 = false;
      // _isBookedC1 = false;
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Choose Seat"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),

//         // Changses
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text("Available: ",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 Container(height: 18, width: 18, color: Colors.white),
//                 SizedBox(width: 10),
//                 Text("Booked: ", style: TextStyle(fontWeight: FontWeight.bold)),
//                 Container(height: 18, width: 18, color: Colors.grey.shade500),
//                 SizedBox(width: 10),
//                 Text("Selected: ",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 Container(height: 18, width: 18, color: Colors.red),
//               ],
//             ),
//             SizedBox(height: 20),
//             // Example row of seats
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedL1) _toggleSeat('L1');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L1'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedL1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L1')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L2');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L2'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L2')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R1');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R1'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R1')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R2');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R2'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R2')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L3');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L3'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L3')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L4');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L4'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L4')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R3');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R3'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R3')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R4');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R4'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R4')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L5');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L5'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L5')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L6');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L6'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L6')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R5');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R5'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R5')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R6');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R6'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R6')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L7');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L7'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L7')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L8');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L8'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L8')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R7');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R7'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R7')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R8');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R8'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R8')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L9');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L9'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L9')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L10');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L10'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L10')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R9');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R9'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R9')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R10');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R10'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R10')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L11');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L11'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L11')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L12');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L12'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L12')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R11');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R11'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R11')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R12');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R12'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R12')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L13');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L13'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L13')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('L14');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'L14'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('L14')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R13');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R13'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R13')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('R14');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'R14'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('R14')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_isBookedR1) _toggleSeat('C1');
//                   },
//                   child: Container(
//                     child: SeatsLayout(ID: 'C1'),
//                     height: 60,
//                     width: 60,
//                     color: _isBookedR1
//                         ? Colors.grey.shade500
//                         : selectedSeats.contains('C1')
//                             ? Colors.red
//                             : Colors.transparent,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _bookSeats,
//               child: Text("Book"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Choose Seat",
          style: textStyleappbar,
        ),
        backgroundColor: appbarcolor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 720,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                child: Card(
                  elevation: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Available: ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                "  Booked: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade500,
                                )),
                            Container(
                              child: Text(
                                "   Selected: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red,
                                )),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //1st Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // 1st Row Left
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedL1) _toggleSeat('L1');
                                setSeatSelectedL1();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L1'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedL1
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L1')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isbookedL2) _toggleSeat('L2');
                                setSeatSelectedL2();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L2'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL2
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L2')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 90),
                            // 1st Row right
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR1) _toggleSeat('R1');
                                setSeatSelectedR1();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R1'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR1
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R1')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR2) _toggleSeat('R2');
                                setSeatSelectedR2();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R2'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR2
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R2')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedL3) _toggleSeat('L3');
                                setSeatSelectedL3();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L3'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedL3
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L3')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isbookedL4) _toggleSeat('L4');
                                setSeatSelectedL4();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L4'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL4
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L4')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 90),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR3) _toggleSeat('R3');
                                setSeatSelectedR3();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R3'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR3
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R3')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR4) _toggleSeat('R4');
                                setSeatSelectedR4();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R4'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR4
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R4')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // 3rd Row
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedL5) _toggleSeat('L5');
                                setSeatSelectedL5();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L5'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedL5
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L5')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isbookedL6) _toggleSeat('L6');
                                setSeatSelectedL6();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L6'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL6
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L6')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 90),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR5) _toggleSeat('R5');
                                setSeatSelectedR5();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R5'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR5
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R5')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR6) _toggleSeat('R6');
                                setSeatSelectedR6();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R6'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR6
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R6')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // 4th row
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedL7) _toggleSeat('L7');
                                setSeatSelectedL7();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L7'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedL7
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L7')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isbookedL8) _toggleSeat('L8');
                                setSeatSelectedL8();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L8'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL8
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L8')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 90),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR7) _toggleSeat('R7');
                                setSeatSelectedR7();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R7'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR7
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R7')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR8) _toggleSeat('R8');
                                setSeatSelectedR8();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R8'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR8
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R8')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //5th Row
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedL9) _toggleSeat('L9');
                                setSeatSelectedL9();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L9'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedL9
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L9')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isbookedL10) _toggleSeat('L10');
                                setSeatSelectedL10();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L10'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL10
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L10')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 90),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR9) _toggleSeat('R9');
                                setSeatSelectedR9();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R9'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR9
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R9')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR10) _toggleSeat('R10');
                                setSeatSelectedR10();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R10'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL10
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R10')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //6th Row
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedL11) _toggleSeat('L11');
                                setSeatSelectedL11();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L11'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedL11
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L11')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isbookedL12) _toggleSeat('L12');
                                setSeatSelectedL12();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L12'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL12
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L12')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 90),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR11) _toggleSeat('R11');
                                setSeatSelectedR11();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R11'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR11
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R11')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR12) _toggleSeat('R12');
                                setSeatSelectedR12();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R12'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL12
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R12')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // 7th row
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedL13) _toggleSeat('L13');
                                setSeatSelectedL13();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L13'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedL13
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L13')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isbookedL14) _toggleSeat('L14');
                                setSeatSelectedL14();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'L14'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isbookedL14
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('L14')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedC1) _toggleSeat('C1');
                                setSeatSelectedC1();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'C1'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedC1
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('C1')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR13) _toggleSeat('R13');
                                setSeatSelectedR13();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R13'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR13
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R13')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // if (!_isBookedR14) _toggleSeat('R14');
                                setSeatSelectedR14();
                              },
                              child: Container(
                                child: SeatsLayout(ID: 'R14'),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  color: _isBookedR14
                                      ? Colors.grey.shade500
                                      : selectedSeats.contains('R14')
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //bookButton
                        ElevatedButton(
                          onPressed: () {
                            setSeatBookedL1();
                            setSeatBookedL2();
                            setSeatBookedR1();
                            setSeatBookedR2();
                            //2nd Row
                            setSeatBookedL3();
                            setSeatBookedL4();
                            setSeatBookedR3();
                            setSeatBookedR4();
                            //3rd Row
                            setSeatBookedL5();
                            setSeatBookedL6();
                            setSeatBookedR5();
                            setSeatBookedR6();
                            //4th Row
                            setSeatBookedL7();
                            setSeatBookedL8();
                            setSeatBookedR7();
                            setSeatBookedR8();
                            //5th Row
                            setSeatBookedL9();
                            setSeatBookedL10();
                            setSeatBookedR9();
                            setSeatBookedR10();
                            //6th Row
                            setSeatBookedL11();
                            setSeatBookedL12();
                            setSeatBookedR11();
                            setSeatBookedR12();
                            //last Row
                            setSeatBookedL13();
                            setSeatBookedL14();
                            setSeatBookedR13();
                            setSeatBookedR14();
                            setSeatBookedC1();

                            if (_isSelectedL1 == true ||
                                _isSelectedL2 == true ||
                                _isSelectedR1 ||
                                _isSelectedR2 ||
                                _isSelectedL3 == true ||
                                _isSelectedL4 == true ||
                                _isSelectedR3 ||
                                _isSelectedR4 ||
                                _isSelectedL5 == true ||
                                _isSelectedL6 == true ||
                                _isSelectedR5 ||
                                _isSelectedR6 ||
                                _isSelectedL7 == true ||
                                _isSelectedL8 == true ||
                                _isSelectedR7 ||
                                _isSelectedR8 ||
                                _isSelectedL9 == true ||
                                _isSelectedL10 == true ||
                                _isSelectedR9 ||
                                _isSelectedR10 ||
                                _isSelectedL11 == true ||
                                _isSelectedL12 == true ||
                                _isSelectedR11 ||
                                _isSelectedR12 ||
                                _isSelectedL13 == true ||
                                _isSelectedL14 == true ||
                                _isSelectedR13 ||
                                _isSelectedR14 ||
                                _isSelectedC1) {
                              print("Booking Seat");
                              _bookSeats();
                            } else {
                              print("ERROR");
                            }
                          },
                          child: Text("Book"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
