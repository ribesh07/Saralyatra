import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/driver/home.dart';
import 'package:saralyatra/driver/middlenav.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/pages/setting_profile.dart';
import 'package:saralyatra/services/shared_pref.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  String? uID;

  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const History(),
    const ProfileSetting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _initAndValidateDriver() async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }

    final doc = await FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('driverDetailsDatabase')
        .collection('drivers')
        .doc(user.uid)
        .get();

    if (!doc.exists) return false;

    final localToken = await SharedpreferenceHelper().getSessionToken();
    final serverToken = doc['sessionToken'];

    if (localToken != serverToken) {
      await FirebaseAuth.instance.signOut();
      return false;
    }

    uID = user.uid;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initAndValidateDriver(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Still loading
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == false) {
          // Redirect to login if invalid or error
          Future.microtask(() {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => Login_page()),
            );
          });
          return const SizedBox.shrink();
        }

        // Auth and session verified
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('SaralYatra'),
            centerTitle: true,
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
            unselectedItemColor: const Color.fromARGB(255, 71, 76, 81),
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
      },
    );
  }
}
