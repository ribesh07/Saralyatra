// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/package_booking.dart';
// import 'package:saralyatra/setups.dart';

// class JourneyScreen extends StatefulWidget {
//   const JourneyScreen({super.key});

//   @override
//   State<JourneyScreen> createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   List<dynamic> dataItems = [
//     {"product": "[product image1]", "frequency": "[Description1]"},
//     {"product": "[product image2]", "frequency": "[Description2]"},
//     {"product": "[product image3]", "frequency": "[Description3]"},
//     {"product": "[product image4]", "frequency": "[Description4]"}
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ListView.builder(
//               scrollDirection: Axis.vertical,
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: dataItems.length,
//               //separatorBuilder: (_, __) => const Divider(),
//               itemBuilder: (context, index) {
//                 return Container(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8, right: 8),
//                         child: FittedBox(
//                           child: Card(
//                               elevation: 8,
//                               child: SizedBox(
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Column(
//                                     // mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(8),
//                                         child: Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 200,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             color: listColor,
//                                           ),
//                                           child: Text(
//                                               dataItems[index]["product"]
//                                                   .toString(),
//                                               style: textStyle,
//                                               textAlign: TextAlign.center),
//                                         ),
//                                       ),
//                                       Text(
//                                         "   ${dataItems[index]["frequency"].toString()}",
//                                         style: textStyle,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         // crossAxisAlignment: CrossAxisAlignment.end,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Card(
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           50)),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             50),
//                                                     color: Colors.blue),
//                                                 child: TextButton(
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             PackageBooking(),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Text(
//                                                     "Book",
//                                                     textAlign: TextAlign.center,
//                                                     style: textStyle,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     ],
//                                   ))),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Use this one

// ignore_for_file: prefer_const_constructors

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:saralyatra/Booking/package_booking.dart';
import 'package:saralyatra/setups.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  List<Map<String, String>> dataItems = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final List<firebase_storage.Reference> refs = (await firebase_storage
              .FirebaseStorage.instance
              .ref('tour_packages_images/')
              .listAll())
          .items;

      final List<Map<String, String>> items = await Future.wait(
        refs.map((ref) async {
          final url = await ref.getDownloadURL();
          // Assuming that the description is part of the file name or stored in metadata
          // If you have descriptions stored somewhere else, you need to fetch them accordingly
          final description =
              ref.name.split('.').first; // Example: "image1.jpg" -> "image1"
          return {"product": url, "frequency": description};
        }).toList(),
      );

      setState(() {
        dataItems = items;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            SizedBox(height: 20),
            dataItems.isNotEmpty
                ? ListView.builder(
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
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: listColor,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        dataItems[index]
                                                            ["product"]!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "   ${dataItems[index]["frequency"]}",
                                              style: textStyle,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: Colors.blue),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PackageBooking(),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Book",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: textStyle,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/package_booking.dart';
// import 'package:saralyatra/setups.dart';

// class JourneyScreen extends StatefulWidget {
//   const JourneyScreen({super.key});

//   @override
//   State<JourneyScreen> createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   List<Map<String, String>> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadImages();
//   }

//   Future<void> _loadImages() async {
//     try {
//       final QuerySnapshot packagesSnapshot = await FirebaseFirestore.instance
//           .collection('saralyatra')
//           .doc('packages')
//           .collection('packages')
//           .get();

//       final List<Map<String, String>> items = [];

//       for (var package in packagesSnapshot.docs) {
//         final QuerySnapshot packageDetailsSnapshot = await FirebaseFirestore
//             .instance
//             .collection('saralyatra')
//             .doc('packages')
//             .collection(package.id)
//             .get();

//         for (var doc in packageDetailsSnapshot.docs) {
//           items.add({
//             "id": doc.id,
//             "product": doc['imageUrl'],
//             "frequency": doc['name'],
//             "price": doc['price'],
//             "packageName": package.id,
//           });
//         }
//       }

//       setState(() {
//         dataItems = items;
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             SizedBox(height: 20),
//             dataItems.isNotEmpty
//                 ? ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: dataItems.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8, right: 8),
//                               child: FittedBox(
//                                 child: Card(
//                                     elevation: 8,
//                                     child: SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(8),
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 height: 200,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                   color: listColor,
//                                                   image: DecorationImage(
//                                                     image: NetworkImage(
//                                                         dataItems[index]
//                                                             ["product"]!),
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               "   ${dataItems[index]["frequency"]}",
//                                               style: textStyle,
//                                             ),
//                                             Text(
//                                               "   ${dataItems[index]["price"]}",
//                                               style: textStyle,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Card(
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         50)),
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(50),
//                                                           color: Colors.blue),
//                                                       child: TextButton(
//                                                         onPressed: () {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   PackageBooking(
//                                                                 id: dataItems[
//                                                                         index]
//                                                                     ["id"]!,
//                                                                 name: dataItems[
//                                                                         index][
//                                                                     "frequency"]!,
//                                                                 price: dataItems[
//                                                                         index]
//                                                                     ["price"]!,
//                                                                 imageUrl: dataItems[
//                                                                         index][
//                                                                     "product"]!,
//                                                                 packageName:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         "packageName"]!,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                         child: Text(
//                                                           "Book",
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: textStyle,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             )
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// not correct
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/package_booking.dart';
// import 'package:saralyatra/setups.dart';

// class JourneyScreen extends StatefulWidget {
//   const JourneyScreen({super.key});

//   @override
//   State<JourneyScreen> createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   List<Map<String, String>> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadImages();
//   }

//   Future<void> _loadImages() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('saralyatra')
//           .doc('packages')
//           .get();

//       if (snapshot.exists) {
//         final data = snapshot.data() as Map<String, dynamic>;
//         final List<Map<String, String>> items = [];

//         data.forEach((packageName, packageData) {
//           (packageData as Map<String, dynamic>).forEach((id, details) {
//             items.add({
//               "id": id,
//               "imageUrl": details["imageUrl"],
//               "name": details["name"],
//               "price": details["price"],
//             });
//           });
//         });

//         setState(() {
//           dataItems = items;
//         });
//       } else {
//         print('No data found in Firestore');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             SizedBox(height: 20),
//             dataItems.isNotEmpty
//                 ? ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: dataItems.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8, right: 8),
//                               child: FittedBox(
//                                 child: Card(
//                                   elevation: 8,
//                                   child: SizedBox(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(8),
//                                           child: Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             height: 200,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               color: listColor,
//                                               image: DecorationImage(
//                                                 image: NetworkImage(
//                                                     dataItems[index]
//                                                         ["imageUrl"]!),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           "   ${dataItems[index]["name"]}",
//                                           style: textStyle,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Card(
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                 ),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               50),
//                                                       color: Colors.blue),
//                                                   child: TextButton(
//                                                     onPressed: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               PackageBooking(
//                                                             id: dataItems[index]
//                                                                 ["id"]!,
//                                                             name:
//                                                                 dataItems[index]
//                                                                     ["name"]!,
//                                                             price:
//                                                                 dataItems[index]
//                                                                     ["price"]!,
//                                                             imageUrl: dataItems[
//                                                                     index]
//                                                                 ["imageUrl"]!,
//                                                             packageName:
//                                                                 "examplePackageName", // Replace with actual package name
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                     child: Text(
//                                                       "Book",
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: textStyle,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/package_booking.dart';
// import 'package:saralyatra/setups.dart';

// class JourneyScreen extends StatefulWidget {
//   const JourneyScreen({super.key});

//   @override
//   State<JourneyScreen> createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   List<Map<String, String>> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadImages();
//   }

//   Future<void> _loadImages() async {
//     try {
//       final packagesSnapshot = await FirebaseFirestore.instance
//           .collection('saralyatra')
//           .doc('packages')
//           .get();

//       if (packagesSnapshot.exists) {
//         final data = packagesSnapshot.data() as Map<String, dynamic>;
//         final List<Map<String, String>> items = [];

//         data.forEach((packageName, packageData) {
//           (packageData as Map<String, dynamic>).forEach((id, details) {
//             items.add({
//               "id": id,
//               "imageUrl": details["imageUrl"],
//               "name": details["name"],
//               "price": details["price"],
//             });
//           });
//         });

//         setState(() {
//           dataItems = items;
//         });
//       } else {
//         print('No data found in Firestore');
//       }
//     } catch (e) {
//       print('Error loading images: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             SizedBox(height: 20),
//             dataItems.isNotEmpty
//                 ? ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: dataItems.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8, right: 8),
//                               child: FittedBox(
//                                 child: Card(
//                                   elevation: 8,
//                                   child: SizedBox(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(8),
//                                           child: Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             height: 200,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               color: listColor,
//                                               image: DecorationImage(
//                                                 image: NetworkImage(
//                                                     dataItems[index]
//                                                         ["imageUrl"]!),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           "   ${dataItems[index]["name"]}",
//                                           style: textStyle,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Card(
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                 ),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               50),
//                                                       color: Colors.blue),
//                                                   child: TextButton(
//                                                     onPressed: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               PackageBooking(
//                                                             id: dataItems[index]
//                                                                 ["id"]!,
//                                                             name:
//                                                                 dataItems[index]
//                                                                     ["name"]!,
//                                                             price:
//                                                                 dataItems[index]
//                                                                     ["price"]!,
//                                                             imageUrl: dataItems[
//                                                                     index]
//                                                                 ["imageUrl"]!,
//                                                             packageName:
//                                                                 "examplePackageName", // Replace with actual package name
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                     child: Text(
//                                                       "Book",
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: textStyle,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/package_booking.dart';
// import 'package:saralyatra/setups.dart';

// class JourneyScreen extends StatefulWidget {
//   const JourneyScreen({super.key});

//   @override
//   State<JourneyScreen> createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   List<Map<String, String>> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPackages();
//   }

//   Future<void> _loadPackages() async {
//     try {
//       // Fetch packages from Firestore
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('saralyatra/packages')
//           .get();

//       final List<Map<String, String>> items = [];

//       for (var doc in snapshot.docs) {
//         final data = doc.data() as Map<String, dynamic>;
//         final name = data['name'] as String;
//         final imageUrl = data['imageUrl'] as String;
//         final price = data['price'] as String;

//         items.add({
//           'name': name,
//           'imageUrl': imageUrl,
//           'price': price,
//         });
//       }

//       setState(() {
//         dataItems = items;
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             SizedBox(height: 20),
//             dataItems.isNotEmpty
//                 ? ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: dataItems.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8, right: 8),
//                               child: FittedBox(
//                                 child: Card(
//                                     elevation: 8,
//                                     child: SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(8),
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 height: 200,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                   color: listColor,
//                                                   image: DecorationImage(
//                                                     image: NetworkImage(
//                                                         dataItems[index]
//                                                             ['imageUrl']!),
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               "   ${dataItems[index]['name']}",
//                                               style: textStyle,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Card(
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         50)),
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(50),
//                                                           color: Colors.blue),
//                                                       child: TextButton(
//                                                         onPressed: () {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   PackageBooking(
//                                                                 packageName:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'name']!,
//                                                                 packageImageUrl:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'imageUrl']!,
//                                                                 packagePrice:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'price']!,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                         child: Text(
//                                                           "Book",
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: textStyle,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             )
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class JourneyScreen extends StatefulWidget {
//   const JourneyScreen({super.key});

//   @override
//   State<JourneyScreen> createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   List<Map<String, String>> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPackages();
//   }

//   Future<void> _loadPackages() async {
//     try {
//       // Fetch packages from Firestore
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('saralyatra/packages')
//           .get();

//       final List<Map<String, String>> items = [];

//       for (var doc in snapshot.docs) {
//         final data = doc.data() as Map<String, dynamic>;
//         final name = data['name'] as String;
//         final imageUrl = data['imageUrl'] as String;
//         final price = data['price'] as String;

//         items.add({
//           'name': name,
//           'imageUrl': imageUrl,
//           'price': price,
//         });
//       }

//       setState(() {
//         dataItems = items;
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             SizedBox(height: 20),
//             dataItems.isNotEmpty
//                 ? ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: dataItems.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8, right: 8),
//                               child: FittedBox(
//                                 child: Card(
//                                     elevation: 8,
//                                     child: SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(8),
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 height: 200,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                   color: listColor,
//                                                   image: DecorationImage(
//                                                     image: NetworkImage(
//                                                         dataItems[index]
//                                                             ['imageUrl']!),
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               "   ${dataItems[index]['name']}",
//                                               style: textStyle,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Card(
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         50)),
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(50),
//                                                           color: Colors.blue),
//                                                       child: TextButton(
//                                                         onPressed: () {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   PackageBooking(
//                                                                 packageName:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'name']!,
//                                                                 packageImageUrl:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'imageUrl']!,
//                                                                 packagePrice:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'price']!,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                         child: Text(
//                                                           "Book",
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: textStyle,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             )
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// fiimport 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:saralyatra/Booking/package_booking.dart';
// import 'package:saralyatra/setups.dart';

// class JourneyScreen extends StatefulWidget {
//   const JourneyScreen({super.key});

//   @override
//   State<JourneyScreen> createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   List<Map<String, String>> dataItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPackages();
//   }

  // Future<void> _loadPackages() async {
  //   try {
  //     final CollectionReference packagesCollection =
  //         FirebaseFirestore.instance.collection('saralyatra/packages');

  //     final List<Map<String, String>> items = [];

  //     // Fetch the list of sub-collections under 'packages'
  //     final packageDocs = await packagesCollection.get();

  //     for (var packageDoc in packageDocs.docs) {
  //       final packageCollection =
  //           packagesCollection.doc(packageDoc.id).collection('packages');
  //       final packageSnapshot = await packageCollection.get();

  //       for (var doc in packageSnapshot.docs) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         final name = data['name'] as String;
  //         final imageUrl = data['imageUrl'] as String;
  //         final price = data['price'] as String;

  //         items.add({
  //           'name': name,
  //           'imageUrl': imageUrl,
  //           'price': price,
  //         });
  //       }
  //     }

  //     setState(() {
  //       dataItems = items;
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

//   Future<void> _loadPackages() async {
//     try {
//       final CollectionReference packagesCollection =
//           FirebaseFirestore.instance.collection('saralyatra/packages');

//       final List<Map<String, String>> items = [];

//       // Fetch the list of sub-collections (each package) under 'packages'
//       final packageDocs = await packagesCollection.get();

//       if (packageDocs.docs.isEmpty) {
//         print('No package collections found.');
//         return;
//       }

//       print('Fetched package documents: ${packageDocs.docs.length}');

//       for (var packageDoc in packageDocs.docs) {
//         print('Processing package: ${packageDoc.id}');

//         // Fetch the documents within the sub-collection named 'packages'
//         final packageSnapshot =
//             await packageDoc.reference.collection('packages').get();

//         if (packageSnapshot.docs.isEmpty) {
//           print('No packages found in ${packageDoc.id}.');
//           continue;
//         }

//         for (var doc in packageSnapshot.docs) {
//           final data = doc.data() as Map<String, dynamic>;
//           final name = data['name'] as String? ?? 'Unknown Name';
//           final imageUrl = data['imageUrl'] as String? ?? '';
//           final price = data['price'] as String? ?? '0';

//           items.add({
//             'name': name,
//             'imageUrl': imageUrl,
//             'price': price,
//           });

//           print('Added item: $name');
//         }
//       }

//       setState(() {
//         dataItems = items;
//         print('Data items updated: ${dataItems.length}');
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             SizedBox(height: 20),
//             dataItems.isNotEmpty
//                 ? ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: dataItems.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8, right: 8),
//                               child: FittedBox(
//                                 child: Card(
//                                     elevation: 8,
//                                     child: SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(8),
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 height: 200,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                   color: listColor,
//                                                   image: DecorationImage(
//                                                     image: NetworkImage(
//                                                         dataItems[index]
//                                                             ['imageUrl']!),
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               "   ${dataItems[index]['name']}",
//                                               style: textStyle,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Card(
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         50)),
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(50),
//                                                           color: Colors.blue),
//                                                       child: TextButton(
//                                                         onPressed: () {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   PackageBooking(
//                                                                 packageName:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'name']!,
//                                                                 packageImageUrl:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'imageUrl']!,
//                                                                 packagePrice:
//                                                                     dataItems[
//                                                                             index]
//                                                                         [
//                                                                         'price']!,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                         child: Text(
//                                                           "Book",
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: textStyle,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             )
//                                           ],
//                                         ))),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }
