// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/driver/payhistory.dart';
import 'package:saralyatra/driver/withdraw.dart';
import 'package:saralyatra/setups.dart';

class History extends StatefulWidget {
  final int initialIndex;
  const History({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Map<String, String>> tiles = [
    {"title": "Date1"},
    {"title": "Date2"},
    {"title": "Date3"},
    {"title": "Date4"},
    {"title": "Date5"},
  ];

  final Map<String, List<Map<String, String>>> tiles2 = {
    "Date1": [
      {
        "Passengers ID": "123",
        "Entry": "koteshwor",
        "Exit": "kalanki",
        "Amount": "1000.00",
      },
      {
        "Passengers ID": "124",
        "Entry": "thimi",
        "Exit": "satdobato",
        "Amount": "100.00",
      },
    ],
    "Date2": [
      {
        "Passengers ID": "456",
        "Entry": "baneshwor",
        "Exit": "balaju",
        "Amount": "1500.00",
      },
    ],
    "Date3": [],
    "Date4": [
      {
        "Passengers ID": "789",
        "Entry": "putalisadak",
        "Exit": "newroad",
        "Amount": "200.00",
      },
      {
        "Passengers ID": "789",
        "Entry": "putalisadak",
        "Exit": "newroad",
        "Amount": "200.00",
      },
    ],
    "Date5": [
      {
        "Passengers ID": "789",
        "Entry": "newroad",
        "Exit": "putalisadak",
        "Amount": "200.00",
      },
    ],
  };

  String driverId = '';
  String driverEmail = '';
  String driverContact = '';
  double totalBalance = 0.0;
  String driverName = '';
  bool isLoading = true;
  //List<Map<String, dynamic>> withdrawHistory = [];

  @override
  void initState() {
    super.initState();
    fetchDriverDetails();
  }

  Future<void> fetchDriverDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    try {
      final docRef = FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid);

      final snapshot = await docRef.get();
      if (snapshot.exists) {
        setState(() {
          driverId = snapshot['dcardId'] ?? uid;
          driverEmail = snapshot['email'] ?? user.email ?? '';
          driverContact = snapshot['contact'] ?? '';
          driverName = snapshot['username'] ?? '';
          totalBalance = double.tryParse(snapshot['balance'].toString()) ?? 0.0;
        });
      }
      //await fetchWithdrawHistory(uid);
    } catch (e) {
      print('Error fetching driver details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onWithdraw() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WithdrawPage(
          driverId: driverId,
          driverContact: driverContact,
          driverEmail: driverEmail,
          userName: driverName,
        ),
      ),
    );
  }

  String calculateTotal(String date) {
    final entries = tiles2[date] ?? [];
    double total = 0;
    for (var entry in entries) {
      total += double.tryParse(entry["Amount"] ?? "0") ?? 0;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    /// Total Balance Card
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Balance',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs. ${totalBalance.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    /// Trip History List
                    Expanded(
                      child: ListView(
                        children: [
                          ...tiles.map((tile) {
                            String date = tile['title']!;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Payhistory(
                                      date: date,
                                      details: tiles2[date] ?? [],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 5,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Rs.'),
                                          Text(
                                            'Rs. ${calculateTotal(date)}',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    /// Withdraw Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onWithdraw,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Withdraw',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
