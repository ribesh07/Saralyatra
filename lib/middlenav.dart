<<<<<<< HEAD
// ignore_for_file: prefer_const_constructors

import 'package:driver/payhistory.dart';
import 'package:driver/setups.dart';
=======
>>>>>>> d40005e (feat: driver side UI)
import 'package:flutter/material.dart';

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
      "Money": "100",
    },
    {
      "title": "Date2",
      "Money": "200",
    },
    {
      "title": "Date3",
      "Money": "300",
    },
  ];

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: tiles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payhistory(),
                    ),
                  );
                },
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255),
                  elevation: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${tiles[index]['title']}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 10, 10, 10),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
                        Column(
                          children: [
                            Text('Rs.'),
                            Text(
                              '${tiles[index]['Money']}',
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
                ),
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
}
