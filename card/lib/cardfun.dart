// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() => runApp(UserCardApp());

class UserCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Card UI',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CardButtons(),
          ),
        ),
      ),
    );
  }
}

class CardButtons extends StatelessWidget {
  final String name = 'saurav kumar';
  final String cardNumber = '1234 5678 9012 3456';
  final String balance = '\Nrs 4,320.50';
  // final String bankLogoUrl =
  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Wells_Fargo_Bank.svg/2560px-Wells_Fargo_Bank.svg.png';

  final List<Map<String, dynamic>> actions = [
    {'label': 'Bus Route', 'icon': Icons.directions_bus},
    {'label': 'Statement', 'icon': Icons.receipt_long},
    {'label': 'Topup', 'icon': Icons.account_balance_wallet},
    {'label': 'Report', 'icon': Icons.report},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card Layout
        Card(
          color: const Color.fromARGB(255, 198, 77, 146),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top: Bank Title & Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SARALYATRA',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    // Image.network(
                    //   ,
                    //   height: 30,
                    //   width: 80,
                    //   fit: BoxFit.contain,
                    // ),
                  ],
                ),
                Spacer(),
                // Card Number
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
                // Name and Balance
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
        ),
        SizedBox(height: 20),

        // Square Buttons Grid
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
                  print('${action['label']} pressed');
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
    );
  }
}
