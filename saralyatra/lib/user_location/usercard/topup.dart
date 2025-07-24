import 'package:flutter/material.dart';
import 'package:saralyatra/payments/esewalocal-pay.dart';
import 'package:saralyatra/payments/khalti-pay.dart';

const backgroundColor = Color.fromARGB(255, 213, 227, 239);
const textcolor = Color.fromARGB(255, 17, 16, 17);
const appbarcolor = Color.fromARGB(255, 39, 136, 228);
const appbarfontcolor = Color.fromARGB(255, 17, 16, 17);
const listColor = Color.fromARGB(255, 153, 203, 238);

class TopUpPage extends StatefulWidget {
  final String userName;
  final String contact;
  final String date;
  final String balance;
  final String email;
  final String userID;

  const TopUpPage({
    super.key,
    required this.userName,
    required this.contact,
    required this.date,
    required this.balance,
    required this.email,
    required this.userID,
  });

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _priceController = TextEditingController();

  bool _isValidPrice(String text) {
    final trimmed = text.trim();
    final price = int.tryParse(trimmed);
    return price != null && price > 0;
  }

  void _showInvalidPriceMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid price greater than 0'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top-Up Page'),
        centerTitle: true,
        backgroundColor: appbarcolor,
        foregroundColor: appbarfontcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter price (NPR)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Choose Payment Method:',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PaymentButton(
                  label: 'eSewa',
                  imagePath: 'assets/logos/esewa_logo.png',
                  onTap: () {
                    if (!_isValidPrice(_priceController.text)) {
                      _showInvalidPriceMessage();
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EsewaLocalScreen(
                          userName: widget.userName,
                          contact: widget.contact,
                          date: widget.date,
                          price: _priceController.text.trim(),
                          email: widget.email,
                          userID: widget.userID,
                        ),
                      ),
                    );
                  },
                ),
                PaymentButton(
                  label: 'Khalti',
                  imagePath: 'assets/logos/khalti.png',
                  onTap: () {
                    if (!_isValidPrice(_priceController.text)) {
                      _showInvalidPriceMessage();
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentKhalti(),
                      ),
                    );
                  },
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 50),
            const SizedBox(height: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
