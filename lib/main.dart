// ignore_for_file: prefer_const_literals, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:driver/login.dart';
import 'package:driver/signup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driver/provider.dart';
<<<<<<< HEAD

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
=======

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
>>>>>>> 2b2b1a4 (updated history)
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
  List<bool> isSelected = [true, false];
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    child: ToggleButtons(
                      isSelected: isSelected,
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "I am User",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "I am Driver",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          // Set only the clicked index to true, others false
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Selected: ${isSelected[0] ? "I am User" : "I am driver"}",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
