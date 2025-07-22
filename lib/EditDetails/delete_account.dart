// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/setups.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final passwordController = TextEditingController();
  bool isObsecure = true;
  final provider = settingProvider();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> _reauthenticate() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in')),
      );
      return false;
    }

    try {
      // Fetch the email from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
        return false;
      }

      String email = userDoc['email'];

      // Create credential
      var credential = EmailAuthProvider.credential(
          email: email, password: passwordController.text);

      // Reauthenticate user
      await currentUser?.reauthenticateWithCredential(credential);

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      print('Error: $e');
      return false;
    }
  }

  Future<void> _deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    try {
      // Delete the Firestore document
      await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(uid)
          .delete();

      // Delete the Firebase Auth user
      await currentUser?.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully')),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login_page()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
        centerTitle: true,
        backgroundColor: appbarcolor,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                InputField(
                  label: 'Enter Password',
                  icon: Icons.lock,
                  controller: passwordController,
                  isvisible: isObsecure,
                  eyeButton: IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    icon: Icon(
                        isObsecure ? Icons.visibility_off : Icons.visibility),
                  ),
                  validator: (value) => provider.passValidator(value),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      bool authenticated = await _reauthenticate();
                      if (authenticated) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text("Are You Sure?"),
                                content: FittedBox(
                                  child: SizedBox(
                                    height: 100,
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Text(
                                            'This will permanently delete your account'),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                _deleteAccount();
                                              },
                                              child: Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text('No'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        );
                      }
                    } else {}
                    // showDialog(
                    //   context: context,
                    //   builder: (_) {
                    //     return AlertDialog(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         title: Text("Are You Sure?"),
                    //         content: FittedBox(
                    //           child: Container(
                    //             height: 100,
                    //             width: 200,
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                     'This will permanently delete your account'),
                    //                 SizedBox(height: 10),
                    //                 Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     TextButton(
                    //                       onPressed: () {},
                    //                       child: Text('Yes'),
                    //                     ),
                    //                     TextButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context);
                    //                       },
                    //                       child: Text('No'),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ));
                    //   },
                    // );
                  },
                  child: Text('Delete Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
