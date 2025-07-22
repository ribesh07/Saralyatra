import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DebugUtils {
  static Future<void> checkDriverDocumentExists(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Driver document EXISTS. Role: ${data?['role'] ?? 'N/A'}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver document DOES NOT EXIST'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> checkUserDocumentExists(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User document EXISTS. Role: ${data?['role'] ?? 'N/A'}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User document DOES NOT EXIST'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
