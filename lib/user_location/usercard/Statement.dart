import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

const backgroundColor = Color.fromARGB(255, 213, 227, 239);
const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);

class Transaction {
  final String contact;
  final String date;
  final String price;
  final String txnRefId;
  final String userID;
  final String userName;
  final DateTime timestamp;
  final double balanceAfter;
  final String description;

  Transaction({
    required this.contact,
    required this.date,
    required this.price,
    required this.txnRefId,
    required this.userID,
    required this.userName,
    required this.timestamp,
    required this.balanceAfter,
    required this.description,
  });
}

class BankStatementScreen extends StatefulWidget {
  const BankStatementScreen({super.key});

  @override
  State<BankStatementScreen> createState() => _BankStatementScreenState();
}

class _BankStatementScreenState extends State<BankStatementScreen> {
  List<Transaction> transactions = [];
  double currentBalance = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        currentBalance = double.tryParse(snapshot['balance'].toString()) ?? 0.0;
      } else {
        currentBalance = 0.0;
        print("User document not found. Defaulting balance to 0.0");
      }

      final txSnap = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('paymentDetails')
          .collection('userLocalPaymentHistory')
          .doc(uid)
          .collection('payments')
          .orderBy('timestamp', descending: true)
          .get();

      double runningBalance = currentBalance;
      List<Transaction> fetchedTxs = [];

      for (var doc in txSnap.docs) {
        final data = doc.data();
        final price = double.tryParse(data['price'].toString()) ?? 0.0;

        // Description based on price
        final isTopUp = price > 0;
        final description = isTopUp ? "Top-up E-Sewa" : "Bus Fare";

        final tx = Transaction(
          contact: data['contact'] as String? ?? '',
          date: data['date'] as String? ?? '',
          price: price.toStringAsFixed(2),
          txnRefId: data['txnRefId'] as String? ?? '',
          userID: data['userID'] as String? ?? '',
          userName: data['userName'] as String? ?? '',
          timestamp:
              (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          balanceAfter: runningBalance,
          description: description,
        );

        fetchedTxs.add(tx);
        runningBalance -= price;
      }

      setState(() {
        transactions = fetchedTxs;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading transactions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Card Statement'),
          backgroundColor: appbarcolor,
          foregroundColor: appbarfontcolor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : transactions.isEmpty
                ? const Center(child: Text("No transactions found."))
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        color: listColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${tx.description}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                    "NRS ${tx.price}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: tx.description == 'Top-up E-Sewa'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(tx.timestamp)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text("Transaction ID: ${tx.txnRefId}",
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 4),
                              // Text(
                              //   "Type: ${tx.description}",
                              //   style: const TextStyle(fontSize: 14),
                              // ),
                              const SizedBox(height: 4),
                              Text(
                                  "Balance : Nrs ${tx.balanceAfter.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
