// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

class SeatsLayout extends StatefulWidget {
  final String ID;

  const SeatsLayout({super.key, required this.ID});
  @override
  State<SeatsLayout> createState() => _SeatsLayoutState();
}

class _SeatsLayoutState extends State<SeatsLayout> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Center(
            child: Text(
          widget.ID,
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black),
        )),
      ),
      Center(
        child: Icon(
          Icons.chair_outlined,
          size: 50,
          color: Color.fromARGB(255, 44, 42, 42),
        ),
      ),
    ]);
  }
}
