import 'package:flutter/material.dart';
import 'package:saralyatra/UserCard/lib/usercard.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';

class Serviceselection extends StatefulWidget {
  const Serviceselection({super.key});

  @override
  State<Serviceselection> createState() => _ServiceselectionState();
}

class _ServiceselectionState extends State<Serviceselection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service Selection"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: GestureDetector(
                  child: Card(
                    child: Text("LOCAL BUS"),
                  ),
                  onTap: () {
                    debugPrint("Local Bus Selected");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserCardApp()));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: GestureDetector(
                  child: Card(
                    child: Text("RESERVATION"),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BottomBar()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
