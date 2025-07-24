import 'package:flutter/material.dart';

class SwipeToggle extends StatefulWidget {
  @override
  _SwipeToggleState createState() => _SwipeToggleState();
}

class _SwipeToggleState extends State<SwipeToggle> {
  bool isOnline = false;
  double dragPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final double toggleWidth = 250;
    final double toggleHeight = 50;
    final double knobSize = 35;

    final double knobPadding = 7; // spacing from the edge
    final double maxDrag = toggleWidth - knobSize - 2 * knobPadding;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          dragPosition += details.delta.dx;
          dragPosition = dragPosition.clamp(0.0, maxDrag);
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          isOnline = dragPosition > maxDrag / 2;
          dragPosition = isOnline ? maxDrag : 0.0;
        });
      },
      child: Container(
        width: toggleWidth,
        height: toggleHeight,
        decoration: BoxDecoration(
          color: isOnline ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Center Label
            Center(
              child: Text(
                isOnline ? "Online" : "Offline",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Animated knob
            AnimatedPositioned(
              duration: Duration(milliseconds: 120),
              curve: Curves.easeOut,
              left: dragPosition + knobPadding,
              top: (toggleHeight - knobSize) / 2,
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
