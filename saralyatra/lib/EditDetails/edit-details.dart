// ignore_for_file: camel_case_types, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// import 'package:saralyatra/Booking/booking_form.dart';
import 'package:saralyatra/EditDetails/change_profile_pic.dart';
import 'package:saralyatra/EditDetails/edit_email.dart';
import 'package:saralyatra/setups.dart';

class editDetails extends StatefulWidget {
  const editDetails({super.key});

  @override
  State<editDetails> createState() => _editDetailsState();
}

class _editDetailsState extends State<editDetails> {
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmail(),
                    ),
                  );
                },
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
                                  "Email & Name",
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
