// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/setups.dart';

class PackageBooking extends StatefulWidget {
  final String packageTitle;
  final String? packageId;
  const PackageBooking({
    super.key,
    required this.packageTitle,
    this.packageId,
  });

  @override
  State<PackageBooking> createState() => _PackageBookingState();
}

class _PackageBookingState extends State<PackageBooking> {
  // var _value = -1;
  double toPay = 0.0;
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final mailcontroller = TextEditingController();
  // final passengercontroller = TextEditingController();
  String tripdetails = '[details]';
  var departureDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String packagePrice = "0";
  bool isLoadingPrice = true;

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails();
  }

  Future<void> _fetchPackageDetails() async {
    try {
      if (widget.packageId != null) {
        // Fetch package details from Firebase
        DocumentSnapshot packageDoc = await FirebaseFirestore.instance
            .collection('history')
            .doc('upcomingHistoryDetails')
            .collection('package')
            .doc(widget.packageId!)
            .get();

        if (packageDoc.exists) {
          var data = packageDoc.data() as Map<String, dynamic>;
          setState(() {
            packagePrice = data['price']?.toString() ?? "0";
            toPay = double.tryParse(packagePrice) ?? 0.0;
            isLoadingPrice = false;
          });
        } else {
          setState(() {
            isLoadingPrice = false;
          });
        }
      } else {
        setState(() {
          isLoadingPrice = false;
        });
      }
    } catch (e) {
      print('Error fetching package details: $e');
      setState(() {
        isLoadingPrice = false;
      });
    }
  }

  Future<void> _saveBookingDetails() async {
    if (formkey.currentState!.validate()) {
      // Get current user first
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please login to book a package'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading dialog with better management
      bool isDialogShowing = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          isDialogShowing = true;
          return PopScope(
            canPop: false,
            child: AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "Booking package...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        isDialogShowing = false;
      });

      try {
        // Generate a unique ID for the booking
        String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

        final bookingDetails = {
          'contact': phonecontroller.text.trim(),
          'email': mailcontroller.text.trim(),
          'name': namecontroller.text.trim(),
          'packageName': widget.packageTitle,
          'reservationDate': departureDate,
          // 'totalPassenger': passengercontroller.text.trim(),
          'price': packagePrice,
          'bookingDate': DateTime.now().toIso8601String(),
          'bookingTime': DateFormat('HH:mm').format(DateTime.now()),
          'userUid': currentUser.uid,
          'status': 'pending',
        };

        // Save to Firebase location: uploads/packageDetails/packages/{uniqueId}
        await FirebaseFirestore.instance
            .collection('history')
            .doc('upcomingHistoryDetails')
            .collection('package')
            .doc(uniqueId)
            .set(bookingDetails);

        // Close loading dialog safely
        if (isDialogShowing && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogShowing = false;
        }

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Package booked successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate back to previous screen
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Close loading dialog safely
        if (isDialogShowing && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogShowing = false;
        }

        print('Error booking package: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to book package. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    mailcontroller.dispose();
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Package Booking',
          ),
          centerTitle: true,

          // actions: [
          //    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new_sharp)),
          //   Text("data"),
          // ],
          backgroundColor: appbarcolor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          color: backgroundColor,
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Text(
                              'Trip Details',
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.packageTitle,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      child: Column(
                        children: [
                          Text('Contact Details', style: textStyle),
                          //Name
                          InputField(
                            icon: Icons.person,
                            label: "Full Name",
                            keypad: TextInputType.text,
                            controller: namecontroller,
                            inputFormat: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-z ]'),
                              ),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            validator: (value) => provider.validator(
                                value, "full Name is required"),
                          ),

                          //phone Number
                          InputField(
                            icon: Icons.phone,
                            label: "+977",
                            keypad: TextInputType.number,
                            controller: phonecontroller,
                            inputFormat: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) =>
                                provider.phoneValidator(value),
                          ),
                          InputField(
                            icon: Icons.mail,
                            label: "Email",
                            controller: mailcontroller,
                            validator: (value) =>
                                provider.emailValidator(value),
                          ),
                          // InputField(
                          //   icon: Icons.numbers,
                          //   label: "Total Passenger",
                          //   controller: passengercontroller,
                          //   inputFormat: [
                          //     FilteringTextInputFormatter.digitsOnly,
                          //   ],
                          //   validator: (value) => provider.passValidator(value),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Text(
                            'Travel Date',
                            style: textStyle,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () async {
                                final selectedate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 30),
                                  ),
                                );
                                if (selectedate != null) {
                                  setState(() {
                                    departureDate = DateFormat("dd/MM/yyyy")
                                        .format(selectedate);
                                    print(selectedate);
                                    // departureDate = selectedate;
                                  });
                                }
                              },
                              // for making select date string tappble
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final selectedate = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          Duration(days: 30),
                                        ),
                                      );
                                      if (selectedate != null) {
                                        setState(() {
                                          departureDate =
                                              DateFormat("dd/MM/yyyy")
                                                  .format(selectedate);
                                          print(selectedate);
                                          // departureDate = selectedate;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.calendar_month_outlined,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    departureDate,
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //address detail
                    SizedBox(
                      height: 10,
                    ),

                    //billing
                    // Card(
                    //   elevation: 10,
                    //   child: Container(
                    //     height: 100,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: Column(
                    //       children: [
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         Text(
                    //           'Bill Amount',
                    //           style: textStyle,
                    //           textAlign: TextAlign.center,
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         Text(
                    //           "Amount : Rs.$toPay",
                    //           style: TextStyle(fontSize: 18),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue),
                        child: TextButton(
                          onPressed: _saveBookingDetails,
                          child: Text(
                            "Book Now",
                            textAlign: TextAlign.center,
                            style: textStyle,
                          ),
                        ),
                      ),
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
