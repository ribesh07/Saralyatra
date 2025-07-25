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
  };

  String driverId = '';
  String driverEmail = '';
  String driverContact = '';
  double totalBalance = 0.0;
  bool isLoading = true;
  List<Map<String, dynamic>> withdrawHistory = [];

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
          totalBalance = double.tryParse(snapshot['balance'].toString()) ?? 0.0;
        });
      }
      await fetchWithdrawHistory(uid);
    } catch (e) {
      print('Error fetching driver details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchWithdrawHistory(String uid) async {
    try {
      final txSnap = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('paymentDetails')
          .collection('driverWithdrawHistory')
          .doc(uid)
          .collection('payments')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        withdrawHistory = txSnap.docs.map((doc) {
          final data = doc.data();
          final timestamp = data['date'] as Timestamp?;
          final date = timestamp != null
              ? DateFormat.yMd().add_jm().format(timestamp.toDate())
              : "N/A";
          return {
            "date": date,
            "amount": data['balance'].toString(),
            "contact": data['contact'] ?? '',
            "username": data['userName'] ?? '',
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching withdraw history: $e');
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

                          /// Withdraw History Section in one Card
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Withdraw History",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(thickness: 1),
                                  if (withdrawHistory.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                          "No withdraw history available."),
                                    )
                                  else
                                    ...withdrawHistory.map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Rs. ${entry['amount']}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text("Date: ${entry['date']}"),
                                            Text(
                                                "Username: ${entry['username']}"),
                                            Text(
                                                "Contact: ${entry['contact']}"),
                                            Divider(),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                ],
                              ),
                            ),
                          ),
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
