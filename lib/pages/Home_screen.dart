// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, file_names

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/pages/HomeDefScreen.dart';
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
      body: Container(
        color: backgroundColor,
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
                  //elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      // indicator: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(6),
                      //     color: Color.fromARGB(255, 225, 138, 240)),
                      controller: _tabController,
                      //isScrollable: true,
                      labelPadding: EdgeInsets.only(right: 10, left: 10),
                      labelColor: Color.fromARGB(255, 78, 72, 72),
                      unselectedLabelColor: Color.fromARGB(255, 135, 131, 131),
                      indicatorPadding: EdgeInsets.only(top: 5, bottom: 5),
                      indicatorColor: Color.fromARGB(255, 78, 72, 72),

                      //padding: EdgeInsets.symmetric(),
                      tabs: [
                        FittedBox(
                          child: Container(
                            width: 100,
                            child: Tab(
                              height: 60,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.directions_bus_filled_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    'Bus Tickets',
                                    style: TextStyle(fontSize: 18),
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
                                children: [
                                  Icon(
                                    Icons.airport_shuttle_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    'Reservation',
                                    style: TextStyle(fontSize: 18),
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
                                children: [
                                  Icon(
                                    Icons.surfing_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    'Packages',
                                    style: TextStyle(fontSize: 18),
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
