// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/setups.dart';

class PackageBooking extends StatefulWidget {
  final String packageTitle;
  const PackageBooking({
    super.key,
    required this.packageTitle,
  });

  @override
  State<PackageBooking> createState() => _PackageBookingState();
}

class _PackageBookingState extends State<PackageBooking> {
  // var _value = -1;
  final double toPay = 0.0;
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final mailcontroller = TextEditingController();
  final passengercontroller = TextEditingController();
  String tripdetails = '[details]';
  var departureDate = DateFormat("dd/MM/yyyy").format(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveBookingDetails() async {
    if (formkey.currentState!.validate()) {
      try {
        final bookingDetails = {
          'fullName': namecontroller.text,
          'phone': phonecontroller.text,
          'email': mailcontroller.text,
          'totalPassenger': passengercontroller.text,
          'departureDate': departureDate,
          // 'packageId': widget.id,
          // 'packageName': widget.packageName,
          // 'price': widget.price,
          // 'imageUrl': widget.imageUrl,
        };

        await FirebaseFirestore.instance
            .collection('saralyatra')
            .doc('packageBookingDetails')
            .collection('package')
            .add(bookingDetails);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save booking: $e')),
        );
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
                          InputField(
                            icon: Icons.numbers,
                            label: "Total Passenger",
                            controller: passengercontroller,
                            inputFormat: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) => provider.passValidator(value),
                          ),
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
                    Card(
                      elevation: 10,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Bill Amount',
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Amount : Rs.$toPay",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
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
