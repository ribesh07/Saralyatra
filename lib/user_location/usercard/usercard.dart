// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:saralyatra/user_location/usercard/Statement.dart';

import 'help_line.dart';
import 'busroute.dart';

import 'package:flutter/material.dart';
import 'topup.dart';

const backgroundColor = Color.fromARGB(255, 213, 227, 239);
const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);
// String? username, email, userid;
// String? contact;
// String generate16DigitNumber() {
// final random = Random();
// String number = '';

//   // Ensure the first digit is not 0
//   number += (random.nextInt(9) + 1).toString();

//   // Add 15 more digits
//   for (int i = 0; i < 15; i++) {
//     number += random.nextInt(10).toString();
//   }

//   return number; // This is a String
// }

String formatWithCardSpacing(String cardID) {
  // Insert a space every 4 digits
  return cardID
      .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
      .trim();
}

// void digit16() {
//   String rawNumber = generate16DigitNumber();
//   formatWithCardSpacing(rawNumber);
// }

class UserCardApp extends StatefulWidget {
  UserCardApp({super.key});

  @override
  State<UserCardApp> createState() => _UserCardAppState();
}

class _UserCardAppState extends State<UserCardApp> {
  String name = 'User';
  String? username;
  String? userid;
  String? email;
  String? contact;
  String? cardID;
  String? balance; // ADD THIS LINE

  bool isLoading = true; // ADD THIS LINE

  //final String balance = 'Nrs 4,320.50';

  final List<Map<String, dynamic>> actions = [
    {'label': 'Bus Route', 'icon': Icons.directions_bus},
    {'label': 'Statement', 'icon': Icons.receipt_long},
    {'label': 'Topup', 'icon': Icons.account_balance_wallet},
    {'label': 'Report', 'icon': Icons.report},
  ];

  void getdata() async {
    final usern = await SharedpreferenceHelper().getUserName();
    final useid = await SharedpreferenceHelper().getUserId();
    final emaill = await SharedpreferenceHelper().getUserEmail();
    final contactt = await SharedpreferenceHelper().getUserContact();
    final cardIDD = await SharedpreferenceHelper().getUserCardID();
    final balance = await SharedpreferenceHelper().getUserBalance();

    if (useid != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(useid)
          .get();

      if (snapshot.exists) {
        final String names = snapshot['username'] as String? ?? '';
        final String emaill = snapshot['email'] as String? ?? '';
        final String contactt = snapshot['contact'] as String? ?? '';
        final String cardIDD = snapshot['cardID'] as String? ?? '';
        final String balance = snapshot['balance'] as String? ?? '';

        setState(() {
          username = names;
          userid = useid;
          email = emaill;
          contact = contactt;
          name = names;
          cardID = cardIDD;
          this.balance = balance; // Set the balance
          isLoading = false; // Set loading false here
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ HANDLE LOADING OR NULL STATE
    if (isLoading || cardID == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ Now safe to use cardID!
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Color.fromARGB(255, 59, 154, 242),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SARALYATRA',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        formatWithCardSpacing(cardID!), // Now safe
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name.toUpperCase(),
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          Text(
                            'Nrs ${balance ?? '0.00'}', // Use null-aware operator
                            // balance ?? 'Nrs 0.00', // Use null-aware operator
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: actions.map((action) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if (action['label'] == 'Bus Route') {
                                return BusControlPanel();
                              } else if (action['label'] == 'Statement') {
                                return BankStatementScreen();
                              } else if (action['label'] == 'Topup') {
                                if (username != null &&
                                    userid != null &&
                                    email != null &&
                                    contact != null) {
                                  return TopUpPage(
                                    userName: username!,
                                    userID: userid!,
                                    email: email!,
                                    contact: contact!,
                                    date: DateTime.now().toString(),
                                  );
                                } else {
                                  return Scaffold(
                                    body: Center(
                                      child: AlertDialog(
                                        title: Text('User data not available'),
                                        content: Text(
                                            'Please complete your profile.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } else if (action['label'] == 'Report') {
                                return Helpline();
                              }
                              return Container();
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(action['icon'], size: 40),
                          SizedBox(height: 10),
                          Text(
                            action['label'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
