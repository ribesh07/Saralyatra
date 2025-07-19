import 'package:flutter/material.dart';
// import 'package:saralyatra/UserCard/UserCard.dart';
import 'package:saralyatra/user_location/usercard/usercard.dart';
import 'package:saralyatra/pages/Home_screen.dart';
// import 'package:saralyatra/UserCard/lib/usercard.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';

class Serviceselection extends StatefulWidget {
  final String userUId;

  const Serviceselection({
    Key? key,
    required this.userUId,
  }) : super(key: key);

  @override
  State<Serviceselection> createState() => _ServiceselectionState();
}

class _ServiceselectionState extends State<Serviceselection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      child: Card(
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.4,
                          // padding: EdgeInsets.all(10),
                          child: Center(
                              child: Text(
                            "LOCAL BUS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          )),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 231, 202, 123),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 31, 215, 219),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        debugPrint("Local Bus Selected");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserCardApp()));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      child: Card(
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.4,
                          // padding: EdgeInsets.all(8),
                          child: Center(
                              child: Text(
                            "NIGHT BUS & RESERVATION",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          )),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 123, 143, 231),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 31, 215, 219),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      userUId: widget.userUId,
                                    )));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
