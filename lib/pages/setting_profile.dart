import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/EditDetails/change_password.dart';
import 'package:saralyatra/EditDetails/delete_account.dart';
import 'package:saralyatra/EditDetails/edit-details.dart';
import 'package:saralyatra/EditDetails/help_line.dart';
import 'package:saralyatra/driver/home.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:app_linkster/app_linkster.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final launcher = AppLinksterLauncher();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _driverData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchDriverData();
  }

  Future<void> _fetchUserData() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
    final localToken = await SharedpreferenceHelper().getSessionToken();
    final doc = await FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('userDetailsDatabase')
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final serverToken = doc['sessionToken'];

    if (localToken != serverToken) {
      // Force logout — session is invalidated
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login_page()));
    }
  }

  Future<void> _fetchDriverData() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(_currentUser!.uid)
          .get();
      setState(() {
        _driverData = userDoc.data() as Map<String, dynamic>?;
      });
    }
    final localToken = await SharedpreferenceHelper().getSessionToken();
    final doc = await FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('driverDetailsDatabase')
        .collection('drivers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print("Local Token: $localToken");
    print("Server Token: ${doc['sessionToken']}");
    final serverToken = doc['sessionToken'];

    if (localToken != serverToken) {
      // Force logout — session is invalidated
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login_page()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Home(key: Home.globalKey),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // replace 'backgroundColor' with an actual color
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              SizedBox(height: 50),

              _userData?['role'] == "user"
                  ? FittedBox(
                      child: _userData?['imageUrl'] != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                _userData!['imageUrl'],
                              ),
                              radius: 46,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors
                                  .blue, // replace 'appbarcolor' with an actual color
                              radius: 46,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                    )
                  : FittedBox(
                      child: _driverData?['imageUrl'] != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                _driverData!['imageUrl'],
                              ),
                              radius: 46,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors
                                  .blue, // replace 'appbarcolor' with an actual color
                              radius: 46,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                    ),
              const SizedBox(height: 10),
              _userData?['role'] == "user"
                  ? Text(
                      _userData?['username'] ?? 'Loading...',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      _driverData?['username'] ?? 'Loading...',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              const SizedBox(height: 15),
              _buildOptionCard(
                context,
                icon: Icons.person,
                text: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const editDetails()),
                  );
                  setState(() {});
                },
              ),

              _buildOptionCard(
                context,
                icon: Icons.lock,
                text: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                icon: Icons.person_off,
                text: 'Delete Account',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeleteAccount()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                icon: Icons.support_agent,
                text: 'Helpline',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Helpline()),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    final uid =
                                        FirebaseAuth.instance.currentUser?.uid;
                                    if (uid != null) {
                                      if (_userData?['role'] == "user") {
                                        await FirebaseFirestore.instance
                                            .collection('saralyatra')
                                            .doc('userDetailsDatabase')
                                            .collection('users')
                                            .doc(uid)
                                            .update({'sessionToken': ''});
                                      } else if (_driverData?['role'] ==
                                          "driver") {
                                        await FirebaseFirestore.instance
                                            .collection('saralyatra')
                                            .doc('driverDetailsDatabase')
                                            .collection('drivers')
                                            .doc(uid)
                                            .update({'sessionToken': ''});
                                      }
                                      //  Home.globalKey.currentState
                                      //       ?.stopSending();

                                      await SharedpreferenceHelper()
                                          .clearSessionToken();
                                      await FirebaseAuth.instance.signOut();

                                      if (!context.mounted) return;
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login_page()),
                                          (route) => false);
                                    }

                                    // Need to edit based on role
                                    // _userData?['role']=="user"??

                                    // FirebaseFirestore.instance
                                    //     .collection('saralyatra')
                                    //     .doc('userDetailsDatabase')
                                    //     .collection('users')
                                    //     .doc('id')
                                    //     .update({'sessionToken': ''});
                                    // FirebaseAuth.instance.signOut();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             Login_page()));
                                    // :FirebaseFirestore.instance
                                    //     .collection('saralyatra')
                                    //     .doc('userDetailsDatabase')
                                    //     .collection('users')
                                    //     .doc('id')
                                    //     .update({'sessionToken': ''});
                                    // FirebaseAuth.instance.signOut();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             Login_page()));
                                  },
                                  // onPressed: () async {
                                  //   final uid =
                                  //       FirebaseAuth.instance.currentUser?.uid;
                                  //   if (uid != null) {
                                  //     await FirebaseFirestore.instance
                                  //         .collection('saralyatra')
                                  //         .doc('userDetailsDatabase')
                                  //         .collection('users')
                                  //         .doc(uid)
                                  //         .update({
                                  //       'sessionToken': null
                                  //     }); // ❌ Invalidate token
                                  //   }

                                  //   await SharedpreferenceHelper()
                                  //       .clearSessionToken(); // Optional: Clear local prefs
                                  //   await FirebaseAuth.instance.signOut();

                                  //   if (!context.mounted) return;
                                  //   Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (_) => Login_page()));
                                  // },
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
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
                    child: Card(
                      child: FittedBox(
                        child: Container(
                          height: 60,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.logout, size: 30),
                              SizedBox(width: 10),
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
              // SizedBox(height: 10),
              // Text('Connect with us'),
              // SizedBox(height: 10),
              // FittedBox(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         GestureDetector(
              //           onTap: () async {
              //             await launcher.launchThisGuy(
              //               'https://www.instagram.com/yatra_sadak?igsh=MTBweHNyYWM2YXlkNQ==',
              //               fallbackLaunchMode: LaunchMode.externalApplication,
              //             );
              //           },
              //           child: FittedBox(
              //             child: Container(
              //               height: 30,
              //               width: 30,
              //               child:
              //                   Image.asset('assets/logos/instagram_icon.png'),
              //             ),
              //           ),
              //         ),
              //         SizedBox(width: 10),
              //         GestureDetector(
              //           onTap: () async {
              //             await launcher.launchThisGuy(
              //               'https://www.facebook.com/profile.php?id=61560997229729&mibextid=ZbWKwL',
              //               fallbackLaunchMode: LaunchMode.externalApplication,
              //             );
              //           },
              //           child: FittedBox(
              //             child: Container(
              //               height: 30,
              //               width: 30,
              //               child:
              //                   Image.asset('assets/logos/Facebook_icon.png'),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required IconData icon,
      required String text,
      required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
          child: FittedBox(
            child: Card(
              child: Container(
                height: 60,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(icon, size: 30),
                    SizedBox(width: 10),
                    Container(
                      width: 290,
                      child: Text(
                        text,
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
    );
  }
}
