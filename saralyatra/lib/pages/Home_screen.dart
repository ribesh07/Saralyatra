// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, file_names

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/pages/HomeDefScreen.dart';
import 'package:saralyatra/pages/history.dart';
// import 'package:saralyatra/main.dart';
import 'package:saralyatra/pages/package_screen.dart';
import 'package:saralyatra/pages/reservation_screen.dart';
import 'package:saralyatra/setups.dart';

class HomeScreen extends StatefulWidget {
  final String userUId;

  const HomeScreen({
    Key? key,
    required this.userUId,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: textStyleappbar),
        backgroundColor: appbarcolor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTabbedPage(),
                  ));
            },
            icon: Icon(Icons.history),
            iconSize: 30,
            color: appbarfontcolor,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, listColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18, bottom: 15),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 8,
                  shadowColor: Colors.black54,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, listColor],
                        stops: [0.6, 1],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelPadding: EdgeInsets.only(right: 10, left: 10),
                      labelColor: appbarfontcolor,
                      unselectedLabelColor: Color.fromARGB(255, 135, 131, 131),
                      indicatorPadding: EdgeInsets.only(top: 5, bottom: 5),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: buttonColor,
                      ),
                      tabs: [
                        FittedBox(
                          child: Container(
                            width: 100,
                            child: Tab(
                              height: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_bus_filled_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    'Bus Tickets',
                                    style: TextStyle(
                                      color: textcolor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Container(
                            width: 100,
                            child: Tab(
                              height: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.airport_shuttle_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    'Reservation',
                                    style: TextStyle(
                                      color: textcolor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Container(
                            width: 100,
                            child: Tab(
                              height: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.surfing_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    'Packages',
                                    style: TextStyle(
                                      color: textcolor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                HomeDefScreen(
                  userUId: widget.userUId,
                ),
                TicketScreen(),
                JourneyScreen(),
              ],
            )),
          ], //childrens
        ),
      ),
    );
  }
}
