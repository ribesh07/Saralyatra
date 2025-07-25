import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saralyatra/driver/driverPage.dart';
import 'package:saralyatra/driver/middlenav.dart';

class WithdrawPage extends StatefulWidget {
  final String driverContact;
  final String driverEmail;
  final String driverId;

  const WithdrawPage({
    super.key,
    required this.driverContact,
    required this.driverEmail,
    required this.driverId,
  });

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController _withdrawController = TextEditingController();
  double? totalBalance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDriverTotalBalance();
  }

  Future<void> fetchDriverTotalBalance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        totalBalance = double.tryParse(snapshot['balance'].toString()) ?? 0.0;
      } else {
        totalBalance = 0.0;
        print("User document not found. Defaulting balance to 0.0");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching driver balance: $e');
      setState(() {
        totalBalance = 0.0;
        isLoading = false;
      });
    }
  }

  Future<void> _submitRequest() async {
    final String input = _withdrawController.text.trim();

    if (input.isEmpty) {
      _showAlert("Invalid Input", "Withdraw amount cannot be empty.");
      return;
    }

    final double? withdrawAmount = double.tryParse(input);
    if (withdrawAmount == null || withdrawAmount <= 0) {
      _showAlert("Invalid Amount", "Enter a valid amount greater than 0.");
      return;
    }

    if (withdrawAmount > (totalBalance ?? 0)) {
      _showAlert("Insufficient Amount",
          "Requested amount exceeds your total balance.");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final newBalance = (totalBalance ?? 0) - withdrawAmount;
    final now = DateTime.now();

    try {
      // Update balance
      await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .update({'balance': newBalance});

      // Save withdraw request in history
      final withdrawRef = FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('paymentDetails')
          .collection('driverWithdrawHistory')
          .doc(uid)
          .collection('payments')
          .doc(); // generates auto-id

      await withdrawRef.set({
        'balance': withdrawAmount,
        'contact': widget.driverContact,
        'date': now,
        'type': 'withdraw',
        'userId': uid,
        'userName': widget.driverId,
      });

      setState(() {
        totalBalance = newBalance;
        _withdrawController.clear();
      });

      _showAlert("Request Successful", "Your withdrawal has been recorded.");
    } catch (e) {
      print("Error processing withdrawal: $e");
      _showAlert("Error", "Something went wrong. Please try again later.");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // 1. Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverPage(), // 2. Show History tab
                ),
              );
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _withdrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Withdraw Request")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDriverCard(),
                  SizedBox(height: 20),
                  TextField(
                    controller: _withdrawController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "Withdraw Amount",
                      border: OutlineInputBorder(),
                      prefixText: "Rs. ",
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Request",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildDriverCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Rs. ${totalBalance?.toStringAsFixed(2) ?? '0.00'}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 16),
            _infoRow("Contact", widget.driverContact),
            _infoRow("Email", widget.driverEmail),
            _infoRow("Driver ID", widget.driverId),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
