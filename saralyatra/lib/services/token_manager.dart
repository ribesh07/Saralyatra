import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:uuid/uuid.dart';

class TokenManager {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final SharedpreferenceHelper _sharedPref = SharedpreferenceHelper();

  /// Generates a new session token for the current user
  static Future<String> generateSessionToken() async {
    return const Uuid().v4();
  }

  /// Saves the session token to both local storage and Firestore
  static Future<void> saveSessionToken(String token, {bool isDriver = false}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _sharedPref.saveSessionToken(token);
      
      final collection = isDriver ? 'driverDetailsDatabase' : 'userDetailsDatabase';
      final subCollection = isDriver ? 'drivers' : 'users';
      
      await _firestore
          .collection('saralyatra')
          .doc(collection)
          .collection(subCollection)
          .doc(user.uid)
          .update({'sessionToken': token});
    }
  }

  /// Validates the session token against the server
  static Future<bool> validateSessionToken({bool isDriver = false}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final localToken = await _sharedPref.getSessionToken();
      if (localToken == null) return false;

      final collection = isDriver ? 'driverDetailsDatabase' : 'userDetailsDatabase';
      final subCollection = isDriver ? 'drivers' : 'users';

      final doc = await _firestore
          .collection('saralyatra')
          .doc(collection)
          .collection(subCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) return false;

      final serverToken = doc.data()?['sessionToken'];
      return localToken == serverToken;
    } catch (e) {
      debugPrint('Token validation error: $e');
      return false;
    }
  }

  /// Refreshes the session token
  static Future<void> refreshSessionToken({bool isDriver = false}) async {
    try {
      final newToken = await generateSessionToken();
      await saveSessionToken(newToken, isDriver: isDriver);
    } catch (e) {
      debugPrint('Token refresh error: $e');
    }
  }

  /// Clears the session token from both local storage and Firestore
  static Future<void> clearSessionToken({bool isDriver = false}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _sharedPref.clearSessionToken();
        
        final collection = isDriver ? 'driverDetailsDatabase' : 'userDetailsDatabase';
        final subCollection = isDriver ? 'drivers' : 'users';
        
        await _firestore
            .collection('saralyatra')
            .doc(collection)
            .collection(subCollection)
            .doc(user.uid)
            .update({'sessionToken': ''});
      }
    } catch (e) {
      debugPrint('Clear token error: $e');
    }
  }

  /// Performs a secure logout
  static Future<void> logout(BuildContext context, {bool isDriver = false}) async {
    try {
      await clearSessionToken(isDriver: isDriver);
      await _auth.signOut();
      
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login_page()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Checks if the current session is valid and forces logout if not
  static Future<void> checkSessionValidity(BuildContext context, {bool isDriver = false}) async {
    final isValid = await validateSessionToken(isDriver: isDriver);
    
    if (!isValid) {
      await logout(context, isDriver: isDriver);
    }
  }

  /// Schedules periodic token refresh (call this after successful login)
  static void scheduleTokenRefresh({bool isDriver = false}) {
    // Refresh token every 30 minutes
    Stream.periodic(const Duration(minutes: 30)).listen((_) async {
      await refreshSessionToken(isDriver: isDriver);
    });
  }
}
