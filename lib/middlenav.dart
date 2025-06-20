<<<<<<< HEAD
<<<<<<< HEAD
=======
//

>>>>>>> 2b2b1a4 (updated history)
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:driver/payhistory.dart';
import 'package:driver/setups.dart';
<<<<<<< HEAD
=======
>>>>>>> d40005e (feat: driver side UI)
import 'package:flutter/material.dart';
=======
>>>>>>> 2b2b1a4 (updated history)

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
<<<<<<< HEAD
  List<Map<String, String>> tiles = [
    {
      "title": "Date1",
      // "Money": "1000",
    },
    {
      "title": "Date2",
      // "Money": "200",
    },
    {
      "title": "Date3",
      // "Money": "300",
    },
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
      {
        "Passengers ID": "125",
        "Entry": "jadibuti",
        "Exit": "kalanki",
        "Amount": "210.00",
      },
      {
        "Passengers ID": "126",
        "Entry": "koteshwor",
        "Exit": "gwarko",
        "Amount": "300.00",
      },
      {
        "Passengers ID": "127",
        "Entry": "lokanthali",
        "Exit": "gwarko",
        "Amount": "400.00",
      },
      {
        "Passengers ID": "127",
        "Entry": "lokanthali",
        "Exit": "gwarko",
        "Amount": "400.00",
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
    "Date3": []
  };
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: tiles.length,
          itemBuilder: (context, index) {
            String date = tiles[index]['title']!;
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
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin: const EdgeInsets.symmetric(vertical: 10),
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
                        children: [
                          Text('Rs.'),
                          Text(
                            'Rs. ${calculateTotal(date)}',
                            style: TextStyle(
                              color: Color.fromARGB(255, 55, 194, 12),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
<<<<<<< HEAD
              );
            },
          ),
        ),
      );
=======
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('History')),
    );
  }
>>>>>>> d40005e (feat: driver side UI)
=======
              ),
            );
          },
        ),
      ),
    );
  }
>>>>>>> 2b2b1a4 (updated history)
}
