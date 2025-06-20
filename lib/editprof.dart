// ignore_for_file: camel_case_types, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables
<<<<<<< HEAD
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, camel_case_types, sized_box_for_whitespace

//import 'dart:ffi';

//import 'package:app_linkster/app_linkster.dart';
import 'package:driver/Edit%20Details/changepassword.dart';
import 'package:driver/Edit%20Details/dltaccount.dart';
import 'package:driver/Edit%20Details/edit_details.dart';
import 'package:driver/Edit%20Details/helpline.dart';
import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:sadakyatra/pages/account._page.dart';

class profileSetting extends StatefulWidget {
  const profileSetting({super.key});

  @override
  State<profileSetting> createState() => _profileSettingState();
}

class _profileSettingState extends State<profileSetting> {
  //final launcher = AppLinksterLauncher();
  final Uri _instaurl = Uri.parse(
      'https://www.instagram.com/yatra_sadak?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==');

  final Uri _facebookurl = Uri.parse(
      'https://www.facebook.com/profile.php?id=61560997229729&mibextid=JRoKGi');

  Future<void> _lunchinstaurl() async {
    if (!await launchUrl(_instaurl)) {
      throw Exception('could not lunch $_instaurl');
    }
  }

  Future<void> _lunchfburl() async {
    if (!await launchUrl(_facebookurl)) {
      throw Exception('could not lunch $_facebookurl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: const Text("Version:1.0.1", style: textStyle),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, bottom: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 90,
                            child: FittedBox(
                              child: ToggleSwitch(
                                minWidth: 50.0,
                                minHeight: 40.0,
                                initialLabelIndex: 0,
                                cornerRadius: 20.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                icons: [
                                  Icons.brightness_2_outlined,
                                  Icons.lightbulb,
                                ],
                                iconSize: 30.0,
                                activeBgColors: [
                                  [
                                    const Color.fromARGB(255, 0, 0, 0),
                                    Colors.black26
                                  ],
                                  [
                                    Color.fromARGB(255, 235, 175, 115),
                                    Color.fromARGB(230, 250, 191, 102)
                                  ]
                                ],
                                animate:
                                    true, // with just animate set to true, default curve = Curves.easeIn
                                curve: Curves
                                    .bounceInOut, // animate must be set to true when using custom curve
                                onToggle: (index) {
                                  print('switched to: $index');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              FittedBox(
                child: const CircleAvatar(
                  backgroundColor: appbarcolor,
                  radius: 46,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '{Name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const editDetails()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                    child: FittedBox(
                      child: Card(
                        //elevation: 10,
                        child: Container(
                          //width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              FittedBox(
                                child: Container(
                                  width: 290,
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(fontSize: 25),
                                  ),
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
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
                    child: FittedBox(
                      child: Card(
                        //elevation: 10,
                        child: Container(
                          //width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.lock,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 290,
                                child: Text(
                                  'Change Password',
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
                      builder: (context) => DeleteAccount(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
                    child: FittedBox(
                      child: Card(
                        // elevation: 10,
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.person_off,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 290,
                                child: Text(
                                  'Delete Account',
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
                      builder: (context) => Helpline(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
                    child: FittedBox(
                      child: Card(
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.support_agent,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 290,
                                child: Text(
                                  'Helpline',
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
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text("Are You Sure?"),
                          content: FittedBox(
                            child: Container(
                              height: 60,
                              width: 200,
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
                    child: Card(
                      //elevation: 10,
                      child: FittedBox(
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.logout,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 290,
                                child: Text(
                                  'Log Out',
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
              SizedBox(
                height: 10,
              ),
              Text('Connect with us'),
              SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _lunchinstaurl,
                        child: FittedBox(
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Image(
                                image: AssetImage(
                                    'assets/logos/instagram_icon.png')),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: _lunchfburl,
                        child: FittedBox(
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Image(
                                image: AssetImage(
                                    'assets/logos/Facebook_icon.png')),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // ToggleSwitch(
              //   minWidth: 50.0,
              //   minHeight: 40.0,
              //   initialLabelIndex: 0,
              //   cornerRadius: 20.0,
              //   activeFgColor: Colors.white,
              //   inactiveBgColor: Colors.grey,
              //   inactiveFgColor: Colors.white,
              //   totalSwitches: 2,
              //   icons: [
              //     Icons.brightness_2_outlined,
              //     Icons.lightbulb,
              //   ],
              //   iconSize: 30.0,
              //   activeBgColors: [
              //     [const Color.fromARGB(255, 0, 0, 0), Colors.black26],
              //     [
              //       Color.fromARGB(255, 235, 175, 115),
              //       Color.fromARGB(230, 250, 191, 102)
              //     ]
              //   ],
              //   animate:
              //       true, // with just animate set to true, default curve = Curves.easeIn
              //   curve: Curves
              //       .bounceInOut, // animate must be set to true when using custom curve
              //   onToggle: (index) {
              //     print('switched to: $index');
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
=======

import 'package:flutter/material.dart';

class editDetails extends StatefulWidget {
  const editDetails({super.key});

  @override
  State<editDetails> createState() => _editDetailsState();
}

class _editDetailsState extends State<editDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
>>>>>>> d40005e (feat: driver side UI)
  }
}
