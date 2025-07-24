// ignore_for_file: camel_case_types, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/booking_form.dart';
import 'package:saralyatra/EditDetails/change_profile_pic.dart';
import 'package:saralyatra/EditDetails/edit_email.dart';
import 'package:saralyatra/driver/edit_driver_email.dart';
import 'package:saralyatra/setups.dart';

class editDetails extends StatefulWidget {
  const editDetails({super.key});

  @override
  State<editDetails> createState() => _editDetailsState();
}

class _editDetailsState extends State<editDetails> {
  Future<String?> _getUserRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) return null;

    try {
      // Check if user exists in users collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        return 'user';
      }

      // Check if user exists in drivers collection
      DocumentSnapshot driverDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .get();

      if (driverDoc.exists) {
        return 'driver';
      }

      return null;
    } catch (e) {
      print('Error checking user role: $e');
      return null;
    }
  }

  void _navigateToEmailEdit() async {
    final role = await _getUserRole();

    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to determine user role')),
      );
      return;
    }

    if (role == 'user') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditEmail()),
      );
    } else if (role == 'driver') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditDriverEmail()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Details',
        ),
        centerTitle: true,
        backgroundColor: appbarcolor,
      ),
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => changeProfilePic()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                    child: FittedBox(
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Card(
                          // elevation: 10,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.person,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 290,
                                child: Text(
                                  "Profile pic",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _navigateToEmailEdit,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
                    child: FittedBox(
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Card(
                          // elevation: 10,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.sticky_note_2,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 290,
                                child: Text(
                                  // "Email & Name",
                                  "Edit Name",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // GestureDetector(
              //   child: FittedBox(
              //     child: Card(
              //       elevation: 10,
              //       child: Row(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Text(
              //               "Change Username",
              //               style: TextStyle(fontSize: 25),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 130),
              //             child: Icon(Icons.arrow_forward_ios),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
