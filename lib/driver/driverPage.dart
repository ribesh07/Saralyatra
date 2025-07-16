// ignore_for_file: prefer_const_constructors

// import 'package:driver/editprof.dart';
// import 'package:driver/home.dart';
// import 'package:driver/middlenav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/driver/home.dart';
import 'package:saralyatra/driver/middlenav.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/pages/setting_profile.dart';
import 'package:saralyatra/services/shared_pref.dart';

// import 'dart:ui' as ui show Canvas, Paint, Path, lerpDouble;

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? myUsername, myName, myEmail, myPicture, role;
  User? _currentUser;
  String? uID;

  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const History(),
    const ProfileSetting(),
  ];
  void _onItemTapped(int Index) {
    setState(() {
      _selectedIndex = Index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchDriverData();
  }

  // Future<void> _fetchDriverData() async {
  //   _currentUser = _auth.currentUser;
  //   if (_currentUser != null) {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('saralyatra')
  //         .doc('driverDetailsDatabase')
  //         .collection('drivers')
  //         .doc(_currentUser!.uid)
  //         .get();
  //     setState(() {
  //       uID = userDoc['uid'].toString();
  //     });
  //   }
  // }

  Future<void> _fetchDriverData() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      final docRef = FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(_currentUser!.uid);

      final doc = await docRef.get();
      if (doc.exists) {
        // 🔧 Fix 1: Check existence
        if (!mounted) return; // 🔧 Fix 2: Prevent state update after dispose
        setState(() {
          uID = _currentUser!.uid; // 🔧 Fix 3: Use Firebase Auth UID
        });
      } else {
        debugPrint(
            "Driver document does not exist for UID: ${_currentUser!.uid}");
      }
    }
    final localToken = await SharedpreferenceHelper().getSessionToken();
    final doc = await FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('driverDetailsDatabase')
        .collection('drivers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final serverToken = doc['sessionToken'];

    if (localToken != serverToken) {
      // Force logout — session is invalidated
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login_page()));
    }
  }

  void backtoFirstnavbar(int Index) {
    setState(
      () {
        if (_selectedIndex == 0) {
          Navigator.pop(context);
        } else {
          _selectedIndex = 0;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('SaralYatra'),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        //forceMaterialTransparency: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                backtoFirstnavbar(_selectedIndex);
              },
            );
          },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Color.fromARGB(255, 71, 76, 81),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_ticket_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_ticket_filled),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
