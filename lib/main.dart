// // // ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:saralyatra/firebase_options.dart';
// // import 'package:saralyatra/pages/login-page.dart';
// // import 'package:saralyatra/payments/App_khalti.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// //   runApp(ProviderScope(child: App()));
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'saralyatra',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         colorScheme:
// //             ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 7, 152, 230)),
// //         useMaterial3: true,
// //       ),
// //       home: const Login_page(),
// //     );
// //   }
// // }

// // ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

// //

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'
//     as riverpod; // for ProviderScope
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import 'package:saralyatra/driver/driverPage.dart';
// import 'package:saralyatra/driver/home.dart';
// // import 'package:saralyatra/UserCard/lib/init.dart';

// import 'package:saralyatra/firebase_options.dart';
// import 'package:saralyatra/mapbox/provider.dart';
// import 'package:saralyatra/pages/login-page.dart';
// import 'package:saralyatra/pages/botton_nav_bar.dart';
// import 'package:saralyatra/pages/serviceSelection.dart';
// import 'package:saralyatra/services/shared_pref.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await dotenv.load(fileName: ".env");

//   runApp(
//     riverpod.ProviderScope(
//       child: MultiProvider(
//         providers: [
//           ChangeNotifierProvider<RouteProvider>(create: (_) => RouteProvider()),
//         ],
//         child: const App(),
//       ),
//     ),
//   );
// }

// Future<void> onTheLoad() async {
//   Geolocator.checkPermission().then((status) {
//     if (status == LocationPermission.denied) {
//       Geolocator.requestPermission();
//     }
//   });

//   Geolocator.requestPermission();
//   Timer.periodic(const Duration(seconds: 10), (timer) async {
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return;
//     }
//     print("Function triggered at: ${DateTime.now()}");
//   });
// }

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   @override
//   void initState() {
//     super.initState();
//     onTheLoad();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'saralyatra',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromARGB(255, 7, 152, 230),
//         ),
//         useMaterial3: true,
//       ),
//       home: const AuthCheck(),
//     );
//   }
// }

// class AuthCheck extends StatelessWidget {
//   const AuthCheck({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // 🔄 Show loading while checking auth state
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }

//         // ❌ Handle error
//         if (snapshot.hasError) {
//           return const Scaffold(
//             body: Center(
//               child: Text('Something went wrong.'),
//             ),
//           );
//         }

//         if (snapshot.hasData) {
//           print("User is logged in");
//           print(snapshot.data?.toString());

//           print(snapshot.data!.uid);
//           print(snapshot);
//           // checkSession().then((widget) {
//           //   Navigator.pushReplacement(
//           //     context,
//           //     MaterialPageRoute(builder: (context) => widget),
//           //   );
//           // });
//           checkSession();
//           // return const BottomBar();
//         }

//         // 🔐 Else show login screen
//         return const Login_page();
//       },
//     );
//   }
// }

// Future<Widget> checkSession() async {
//   String? uid = await SharedpreferenceHelper().getUserId();
//   final sessionToken = await SharedpreferenceHelper().getSessionToken();
//   print("Session Token: $sessionToken");
//   print("User ID: $uid");
//   final role = await SharedpreferenceHelper().getRole();
//   if (role == "user") {
//     if (uid != null && sessionToken != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('saralyatra')
//           .doc('userDetailsDatabase')
//           .collection('users')
//           .doc(uid)
//           .get();

//       if (snapshot.exists && snapshot['sessionToken'] == sessionToken) {
//         return BottomBar(); // Valid session
//       }
//     }

//     return Login_page(); // No session or invalid
//   } else if (role == "driver") {
//     if (uid != null && sessionToken != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('saralyatra')
//           .doc('driverDetailsDatabase')
//           .collection('user')
//           .doc(uid)
//           .get();

//       if (snapshot.exists && snapshot['sessionToken'] == sessionToken) {
//         return DriverPage(); // Valid session
//       }
//     }
//   }
//   return Login_page(); // No session or invalid
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:saralyatra/driver/driverPage.dart';
import 'package:saralyatra/firebase_options.dart';
import 'package:saralyatra/mapbox/provider.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';
import 'package:saralyatra/services/shared_pref.dart';

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

// 🔁 Location permission + repeating timer
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
        // ⏳ Waiting for auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Error
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong.')),
          );
        }

        // ✅ User is logged in — now validate session
        if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: validdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return const Login_page();
              }

              return snapshot.data!;
            },
          );
        }

        // 🔓 Not logged in
        return const Login_page();
      },
    );
  }
}

Future<Widget> validdata() async {
  String? uid = await SharedpreferenceHelper().getUserId();
  String? sessionToken = await SharedpreferenceHelper().getSessionToken();
  String? role = await SharedpreferenceHelper().getRole();

  print("User ID: $uid");
  print("Session Token: $sessionToken");
  print("Role: $role");
  if (uid == null || sessionToken == null || role == null) {
    print("No valid session found, redirecting to login page.");
    return const Login_page();
  } else {
    if (role == "user") {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        print("Valid user session found, redirecting to BottomBar.");
        return BottomBar();
      }
    } else if (role == "driver") {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        print("Valid driver session found, redirecting to DriverPage.");
        return DriverPage();
      }
    }
  }
  // If none of the above conditions are met, return Login_page
  return const Login_page();
}

Future<Widget> checkSession() async {
  String? uid = await SharedpreferenceHelper().getUserId();
  print("User ID: $uid");
  final sessionToken = await SharedpreferenceHelper().getSessionToken();
  print("Session Token: $sessionToken");
  final role = await SharedpreferenceHelper().getRole();

  if (uid == null || sessionToken == null || role == null) {
    MaterialPageRoute(
      builder: (context) => const Login_page(),
    );
  }

  try {
    final collectionPath = role == "user"
        ? 'userDetailsDatabase'
        : role == "driver"
            ? 'driverDetailsDatabase'
            : null;

    if (collectionPath == null) return const Login_page();

    final docRef = FirebaseFirestore.instance
        .collection('saralyatra')
        .doc(collectionPath)
        .collection(role == "user" ? 'users' : 'drivers')
        .doc(uid);

    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data()?['sessionToken'] == sessionToken) {
      return role == "user" ? const BottomBar() : const DriverPage();
    }
  } catch (e) {
    print("Error in session check: $e");
  }

  return const Login_page();
}
