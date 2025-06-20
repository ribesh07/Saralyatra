<<<<<<< HEAD
// ignore_for_file: prefer_const_literals
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:driver/login.dart';
import 'package:driver/signup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driver/provider.dart';

import 'mainpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => RouteProvider(),
      child: MaterialApp(
        home: MyApp(), // MyApp(),
      ),
    ),
  );

  Geolocator.checkPermission().then((status) {
    if (status == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
  });

  Geolocator.requestPermission();
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    print("Function triggered at: ${DateTime.now()}");
  });
=======
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'mainpage.dart';

void main() {
  runApp(const MyApp());
>>>>>>> d40005e (feat: driver side UI)
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                },
<<<<<<< HEAD
                child: Text('main page')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const Signup_page()),
                  );
                },
                child: Text('signup')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login_page()),
                  );
                },
                child: Text('login')),
=======
                child: Text('main page'))
>>>>>>> d40005e (feat: driver side UI)
          ],
        ),
      ),
    );
  }
}
