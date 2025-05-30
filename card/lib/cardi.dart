// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(cardiac());
}

class cardiac extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Card Layout',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                ),
                BankCard(
                  name: 'SAURAV KUMAR',
                  cardNumber: '1234 5678 9012 3456',
                  balance: '\NRS 5,250.75',
                  bankLogoUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Wells_Fargo_Bank.svg/2560px-Wells_Fargo_Bank.svg.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BankCard extends StatelessWidget {
  final String name;
  final String cardNumber;
  final String balance;
  final String bankLogoUrl;

  const BankCard({
    Key? key,
    required this.name,
    required this.cardNumber,
    required this.balance,
    required this.bankLogoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(133, 219, 71, 71),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        width: 350,
        height: 200,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Top Row with Bank Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SARALYATRA',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Image.network(
                  bankLogoUrl,
                  height: 30,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Spacer(),
            Text(
              cardNumber,
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
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  balance,
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
    );
  }
}
