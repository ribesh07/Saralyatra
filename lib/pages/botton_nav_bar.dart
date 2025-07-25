import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
// import 'package:saralyatra/pages/HomeDefScreen.dart';
import 'package:saralyatra/pages/Home_screen.dart';
import 'package:saralyatra/pages/history.dart';
import 'package:saralyatra/pages/serviceSelection.dart';
import 'package:saralyatra/pages/setting_profile.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:saralyatra/setups.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? myUsername, myName, myEmail, myPicture, role;
  User? _currentUser;
  String? uID;

  getthesahredpref() async {
    myUsername = await SharedpreferenceHelper().getUserName();
    myName = await SharedpreferenceHelper().getUserDisplayName();
    myEmail = await SharedpreferenceHelper().getUserEmail();
    myPicture = await SharedpreferenceHelper().getUserImage();
    role = await SharedpreferenceHelper().getRole();
    if (!mounted) return; // 🔧 Fix 1
    setState(() {});
  }

  onTheLoad() async {
    await getthesahredpref();
    if (!mounted) return; // 🔧 Fix 2
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
    _fetchUserData(); // 🔧 Will check if doc exists first
    // _fetchUserData();
  }

  List<Widget> get _widgetOptions {
    return [
      // HomeScreen(userUId: uID),
      if (uID != null)
        Serviceselection(userUId: uID!)
      // HomeScreen(userUId: uID!)
      else
        const CircularProgressIndicator(),
      // const MyTabbedPage(),
      const ProfileSetting(),
      // the argument tyoe 'String?' can;t be assigned to parameter type 'string'
    ];
  }

  void _onItemTapped(int Index) {
    setState(() {
      _selectedIndex = Index;
    });
  }

  Future<void> _fetchUserData() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      final docRef = FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(_currentUser!.uid);

      final doc = await docRef.get();
      if (doc.exists) {
        // ✅ Fix 3: Check existence
        if (!mounted) return; // ✅ Fix 4: Prevent update after unmount
        setState(() {
          uID = _currentUser!.uid; // ✅ Fix 5: Use auth UID directly
        });
      } else {
        debugPrint(
            "User document does not exist for UID: ${_currentUser!.uid}");
      }
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
        backgroundColor: appbarcolor,

        title: const Text('SaralYatra'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        //forceMaterialTransparency: true,
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return IconButton(
        //       icon: const Icon(Icons.arrow_back_ios_new),
        //       onPressed: () {
        //         backtoFirstnavbar(_selectedIndex);
        //       },
        //     );
        //   },
        // ),
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
          // BottomNavigationBarItem(
          //   icon: Icon(FluentSystemIcons.ic_fluent_ticket_regular),
          //   activeIcon: Icon(FluentSystemIcons.ic_fluent_ticket_filled),
          //   label: 'Tickets',
          // ),
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
