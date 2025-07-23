import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';
import 'package:saralyatra/services/database.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:uuid/uuid.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _refreshToken() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        String newToken = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection('saralyatra')
            .doc('userDetailsDatabase')
            .collection('users')
            .doc(user.uid)
            .update({'sessionToken': newToken});
        await SharedpreferenceHelper().saveSessionToken(newToken);
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
    }
  }

  getCurrentUser() async {
    return auth.currentUser;
  }

  signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _refreshToken();
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? userDetails = result.user;

      if (userDetails != null) {
        // You can retrieve user data from Firestore if needed
        var userSnapshot = await DatabaseMethod().getUserById(userDetails.uid);

        if (userSnapshot.exists) {
          Map<String, dynamic> userInfo =
              userSnapshot.data() as Map<String, dynamic>;

          String username = userInfo["username"];
          String firstletter = username.substring(0, 1).toUpperCase();

          await SharedpreferenceHelper().saveUserDisplayName(userInfo["Name"]);
          await SharedpreferenceHelper().saveUserEmail(userInfo["Email"]);
          await SharedpreferenceHelper().saveUserId(userDetails.uid);
          await SharedpreferenceHelper().saveUserName(username);
          await SharedpreferenceHelper().saveUserImage(userInfo["Image"]);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Logged in Successfully!!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("User data not found!"),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message ?? "Authentication failed"),
        ),
      );
    }
  }
}
