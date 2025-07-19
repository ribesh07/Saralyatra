// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';

class SwipeToggle extends StatefulWidget {
  get isOnline => null;

  @override
  _SwipeToggleState createState() => _SwipeToggleState();
}

class _SwipeToggleState extends State<SwipeToggle> {
  bool isOnline = false;
  double dragPosition = .0;

  @override
  Widget build(BuildContext context) {
    final double toggleWidth = 300;
    final double toggleHeight = 50;
    final double knobSize = 35;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          dragPosition += details.delta.dx;
          dragPosition = dragPosition.clamp(0, toggleWidth - knobSize);
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          isOnline = dragPosition > (toggleWidth - knobSize) / 2;
          dragPosition = isOnline ? toggleWidth - 1.5 * knobSize : 0;

          //update database
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: toggleWidth,
        height: toggleHeight,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isOnline ? Color.fromARGB(255, 3, 179, 255) : Colors.grey[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                isOnline ? "Online" : "Offline",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: dragPosition,
              child: Container(
                alignment: Alignment.center,
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
