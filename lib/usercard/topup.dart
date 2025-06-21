import 'package:flutter/material.dart';

const backgroundColor = Color.fromARGB(255, 213, 227, 239);
const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _amountController = TextEditingController();

  void _handleTopUp(String method) {
    String amount = _amountController.text;
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Top-Up Request'),
        content: Text('Payment Method: $method\nAmount: Rs. $amount'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Top-Up Page'),
          backgroundColor: appbarcolor,
          foregroundColor: appbarfontcolor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount (NPR)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Text('Choose Payment Method:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PaymentButton(
                  label: 'eSewa',
                  imagePath: 'assets/images/esewa.png',
                  onTap: () => _handleTopUp('eSewa'),
                ),
                PaymentButton(
                  label: 'Khalti',
                  imagePath: 'assets/images/khalti.png',
                  onTap: () => _handleTopUp('Khalti'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const PaymentButton({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 130,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 50),
            SizedBox(height: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
