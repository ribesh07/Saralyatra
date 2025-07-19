// // ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

// //import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/seatbooking_form.dart';
// //import 'package:flutter/widgets.dart';

// import 'package:saralyatra/setups.dart';

// class seatSelection extends StatefulWidget {
//   const seatSelection({super.key});

//   @override
//   State<seatSelection> createState() => _seatSelectionState();
// }

// class _seatSelectionState extends State<seatSelection> {
//   bool _selected = false;
//   bool _selectedr = false;
//   bool _booked = false;
//   void _onItemtapped() {
//     setState(() {
//       _selected = !_selected;
//     });
//   }

//   void _otnItemtapped() {
//     setState(() {
//       _selectedr = !_selectedr;
//     });
//   }

//   setbooking() {
//     if (_selectedr == true) {
//       setState(() {
//         _booked = true;
//       });
//     }
//   }

//   resetbooking() {
//     if (_booked == true || _selectedr == true || _selected == true) {
//       setState(() {
//         // _booked = false;
//         // _selectedr = false;
//         // _selected = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         color: backgroundColor,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 200,
//             ),
//             SizedBox(
//               height: 600,
//               child: Expanded(
//                 child: Card(
//                   elevation: 10,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: _onItemtapped,
//                                   child: Container(
//                                     height: 50,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           _selected ? Colors.blue : Colors.red,
//                                       border: Border.all(color: Colors.black),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 GestureDetector(
//                                   onTap: _otnItemtapped,
//                                   child: Container(
//                                     height: 50,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: _booked
//                                           ? Colors.black
//                                           : _selectedr
//                                               ? Colors.blue
//                                               : Colors.red,
//                                       border: Border.all(color: Colors.black),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                       onPressed: () async {
//                         String hello = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => bookSeat(),
//                           ),
//                         );
//                         setbooking();
//                         if (hello == 'hello') {
//                           resetbooking();
//                         }
//                       },
//                       child: Text('book'))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
