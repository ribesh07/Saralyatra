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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saralyatra/firebase_options.dart';
import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

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

        // ✅ If user is logged in, go to main screen
        if (snapshot.hasData) {
          return const BottomBar();
        }

        // 🔐 Else show login screen
        return const Login_page();
      },
    );
  }
}
