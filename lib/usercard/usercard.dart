// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:mapbox/usercard/help_line.dart';
import 'package:mapbox/usercard/statement.dart';
import 'package:mapbox/usercard/busroute.dart';

import 'package:flutter/material.dart';
import 'package:mapbox/usercard/topup.dart';

String generate16DigitNumber() {
  final random = Random();
  String number = '';

  // Ensure the first digit is not 0
  number += (random.nextInt(9) + 1).toString();

  // Add 15 more digits
  for (int i = 0; i < 15; i++) {
    number += random.nextInt(10).toString();
  }

  return number; // This is a String
}

String formatWithCardSpacing(String number) {
  // Insert a space every 4 digits
  return number
      .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
      .trim();
}

// void digit16() {
//   String rawNumber = generate16DigitNumber();
//   formatWithCardSpacing(rawNumber);
// }

class UserCardApp extends StatelessWidget {
  final String name = 'saurav kumar';
  final String cardNumber = formatWithCardSpacing(generate16DigitNumber());
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card Layout
              Card(
                color: const Color.fromARGB(255, 203, 31, 128),
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
                      // Top: Bank Title & Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SARALYATRA',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if (action['label'] == 'Bus Route') {
                                return BusControlPanel();
                              } else if (action['label'] == 'Statement') {
                                return BankStatementScreen();
                              } else if (action['label'] == 'Topup') {
                                return TopUpPage();
                              } else if (action['label'] == 'Report') {
                                return Helpline();
                              }
                              return Container(); // Fallback
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
