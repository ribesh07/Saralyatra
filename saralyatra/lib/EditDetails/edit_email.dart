// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
// import 'package:saralyatra/services/database.dart';
import 'package:saralyatra/setups.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  bool passwordObsecured = true;

  // final newEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  Future<void> _authenticateAndUpdate() async {
    // final newEmail = newEmailController.text;
    // final password = passwordController.text;
    // final newUsername = usernameController.text;
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in')),
      );
      return;
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
        return;
      }

      // String email = userDoc['email'];

      // Create credential
      // var credential = EmailAuthProvider.credential(
      // email: email, password: passwordController.text);

      // Reauthenticate user

      // await currentUser?.reauthenticateWithCredential(credential);
      // Send verification email to the new email address
      // await currentUser?.verifyBeforeUpdateEmail(newEmailController.text);

      // Update email
      // await currentUser?.updateEmail(newEmailController.text);

      // Get user UID

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(uid)
          .update({
        'username': usernameController.text,
        // 'email': newEmailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username updated successfully')),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  final provider = settingProvider();
  final formkey = GlobalKey<FormState>();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // User? _currentUser;
  // Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // newEmailController.dispose();
    passwordController.dispose();
    usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarcolor,
        title: Text('Edit Details'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                InputField(
                  label: 'Fullname',
                  icon: Icons.person,
                  controller: usernameController,
                  validator: (value) =>
                      provider.validator(value, 'Fullname required'),
                ),
                // InputField(
                //   label: 'New-Email',
                //   icon: Icons.mail,
                //   controller: newEmailController,
                //   validator: (value) => provider.emailValidator(value),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Text('Enter password to update email'),
                ),
                InputField(
                  label: 'Password',
                  icon: Icons.lock,
                  controller: passwordController,
                  isvisible: passwordObsecured,
                  eyeButton: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordObsecured = !passwordObsecured;
                      });
                    },
                    icon: Icon(passwordObsecured
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  validator: (value) => provider.passValidator(value),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          // print(ps);
                          if (formkey.currentState!.validate()) {
                            _authenticateAndUpdate();
                            // _updateEmail();
                          }
                        },
                        child: Text(
                          'Save Changes',
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
