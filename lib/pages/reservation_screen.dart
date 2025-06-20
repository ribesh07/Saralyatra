// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

//import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/setups.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  var _value = -1;
  //final double toPay = 0.0;
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final departcontroller = TextEditingController();
  final destinationcontroller = TextEditingController();
  var departureDate = DateFormat("dd/MM/yyyy").format(DateTime.now());

  Future<void> _storeReservationDetails() async {
    if (formkey.currentState!.validate()) {
      String vehicleType;

      switch (_value) {
        case 1:
          vehicleType = 'Bus';
          break;
        case 2:
          vehicleType = 'Car';
          break;
        case 3:
          vehicleType = 'Jeep';
          break;
        default:
          vehicleType = 'Unknown';
      }

      final data = {
        'name': namecontroller.text,
        'contact': phonecontroller.text,
        'email': emailcontroller.text,
        'startLocation': departcontroller.text,
        'destination': destinationcontroller.text,
        'date': departureDate,
      };

      try {
        await FirebaseFirestore.instance
            .collection('saralyatra')
            .doc('reservation')
            .collection(vehicleType)
            .add(data);
        print('Reservation details stored successfully');
      } catch (e) {
        print('Error storing reservation details: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    emailcontroller.dispose();
    departcontroller.dispose();
    destinationcontroller.dispose();
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
                              RegExp(r'[a-zA-z]'),
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
                          validator: (value) => provider.phoneValidator(value),
                        ),
                        InputField(
                          icon: Icons.mail,
                          label: "Email",
                          controller: emailcontroller,
                          validator: (value) => provider.emailValidator(value),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //address detail
                  Card(
                    elevation: 8,
                    child: Column(
                      children: [
                        Text('Vehicle Type', style: textStyle),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == -1) {
                                return "please select vehicle type";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.blue.withOpacity(1),
                                      width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.red.withOpacity(0.5),
                                      width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.red.withOpacity(1),
                                      width: 2),
                                ),
                                prefixIcon: Icon(Icons.car_rental)),
                            value: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value as int;
                                print(_value);
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                  child: Text("--Choose Vehicle Type--"),
                                  value: -1),
                              DropdownMenuItem(child: Text("Bus"), value: 1),
                              DropdownMenuItem(child: Text("Car"), value: 2),
                              DropdownMenuItem(child: Text("Jeep"), value: 3),
                            ],
                          ),
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
                          "Trip Deatil",
                          style: textStyle,
                        ),
                        InputField(
                          icon: Icons.add_location_alt_outlined,
                          label: "From",
                          keypad: TextInputType.text,
                          controller: departcontroller,
                          inputFormat: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-z0-9-_]'),
                            ),
                            LengthLimitingTextInputFormatter(50),
                          ],
                          validator: (value) => provider.validator(
                              value, "please enter departure location"),
                        ),
                        InputField(
                          icon: Icons.add_location_alt_outlined,
                          label: "To",
                          keypad: TextInputType.text,
                          controller: destinationcontroller,
                          validator: (value) => provider.validator(
                              value, "please enter Destination location"),
                        ),
                      ],
                    ),
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
                                        departureDate = DateFormat("dd/MM/yyyy")
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
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text("Conformation"),
                                  content: Text("Confirm Reservation"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        //main Logic
                                        _storeReservationDetails();
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.green,
                                          elevation: 10,
                                          duration:
                                              Duration(milliseconds: 3000),
                                          content: const Text(
                                            "we will contact you soon",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Ok"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                            print(namecontroller);
                          } else {}
                        },
                        child: Text(
                          "Submit",
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
    );
  }
}
