import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/driver/driverPage.dart';

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

  Map<String, List<Map<String, dynamic>>> withdrawHistoryGrouped = {};

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
      }
      setState(() {
        isLoading = false;
      });
      await fetchWithdrawHistory(uid);
    } catch (e) {
      print('Error fetching driver balance: $e');
      setState(() {
        totalBalance = 0.0;
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

      Map<String, List<Map<String, dynamic>>> groupedHistory = {};

      for (var doc in txSnap.docs) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp?;
        final dateKey = timestamp != null
            ? DateFormat('yyyy-MM-dd').format(timestamp.toDate())
            : "Unknown";

        final entry = {
          "time": timestamp != null
              ? DateFormat('h:mm a').format(timestamp.toDate())
              : "N/A",
          "amount": data['balance'].toString(),
          "contact": data['contact'] ?? '',
          "username": data['userName'] ?? '',
        };

        groupedHistory.putIfAbsent(dateKey, () => []).add(entry);
      }

      setState(() {
        withdrawHistoryGrouped = groupedHistory;
      });
    } catch (e) {
      print('Error fetching withdraw history: $e');
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
      await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .update({'balance': newBalance});

      final withdrawRef = FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('paymentDetails')
          .collection('driverWithdrawHistory')
          .doc(uid)
          .collection('payments')
          .doc();

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

      await fetchWithdrawHistory(uid);

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
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => DriverPage()),
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
          : SingleChildScrollView(
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
                  ),
                  SizedBox(height: 20),
                  _buildWithdrawHistory(),
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
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildWithdrawHistory() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Withdraw History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            if (withdrawHistoryGrouped.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No withdraw history available."),
              )
            else
              ...withdrawHistoryGrouped.entries.map((entry) {
                final date = entry.key;
                final withdrawals = entry.value;

                return ExpansionTile(
                  title: Text(
                    DateFormat('MMM dd, yyyy').format(DateTime.parse(date)),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: withdrawals.map((w) {
                    return ListTile(
                      title: Text("Rs. ${w['amount']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Time: ${w['time']}"),
                          Text("Username: ${w['username']}"),
                          Text("Contact: ${w['contact']}"),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
          ],
        ),
      ),
    );
  }
}
