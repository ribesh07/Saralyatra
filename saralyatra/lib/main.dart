// // ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:saralyatra/firebase_options.dart';
// import 'package:saralyatra/pages/login-page.dart';
// import 'package:saralyatra/payments/App_khalti.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(ProviderScope(child: App()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'saralyatra',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme:
//             ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 7, 152, 230)),
//         useMaterial3: true,
//       ),
//       home: const Login_page(),
//     );
//   }
// }

// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

//

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    as riverpod; // for ProviderScope
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:saralyatra/driver/driverPage.dart';
import 'package:saralyatra/driver/home.dart';
// import 'package:saralyatra/UserCard/lib/init.dart';

import 'package:saralyatra/firebase_options.dart';
import 'package:saralyatra/mapbox/provider.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';
import 'package:saralyatra/pages/serviceSelection.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  runApp(
    riverpod.ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<RouteProvider>(create: (_) => RouteProvider()),
        ],
        child: const App(),
      ),
    ),
  );
}

Future<void> onTheLoad() async {
  Geolocator.checkPermission().then((status) {
    if (status == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
  });

  Geolocator.requestPermission();
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    print("Function triggered at: ${DateTime.now()}");
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'saralyatra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 7, 152, 230),
        ),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔄 Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ❌ Handle error
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong.'),
            ),
          );
        }

        if (snapshot.hasData) {
          return const BottomBar();
        }

        // 🔐 Else show login screen
        return const Login_page();
      },
    );
  }
}

Future<Widget> checkSession() async {
  String? uid = await SharedpreferenceHelper().getUserId();
  final sessionToken = await SharedpreferenceHelper().getSessionToken();
  final role = await SharedpreferenceHelper().getRole();
  if (role == "user") {
    if (uid != null && sessionToken != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('user')
          .doc(uid)
          .get();

      if (snapshot.exists && snapshot['sessionToken'] == sessionToken) {
        return BottomBar(); // Valid session
      }
    }

    return Login_page(); // No session or invalid
  } else if (role == "driver") {
    if (uid != null && sessionToken != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('user')
          .doc(uid)
          .get();

      if (snapshot.exists && snapshot['sessionToken'] == sessionToken) {
        return DriverPage(); // Valid session
      }
    }
  }
  return Login_page(); // No session or invalid
}
