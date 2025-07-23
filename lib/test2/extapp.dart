// ignore_for_file: prefer_const_constructors

import 'package:app_linkster/app_linkster.dart';
// import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtApp extends StatefulWidget {
  const ExtApp({super.key});

  @override
  State<ExtApp> createState() => _ExtAppState();
}

class _ExtAppState extends State<ExtApp> {
  final launcher = AppLinksterLauncher();
  Uri email = Uri(
      scheme: 'instagram',
      path: 'www.instagram.com/karna_sushant?igsh=MWhhMmd6bTdtNmhyeA==');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hola'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                // await LaunchApp.openApp(
                //     androidPackageName: 'instagram&c=apps&hl=en');
                // openStore:
                // true;
                await launcher.launchThisGuy(
                    'https://www.instagram.com/karna_sushant?igsh=MWhhMmd6bTdtNmhyeA==',
                    fallbackLaunchMode: LaunchMode.externalApplication);
              },
              child: Text('insta'))
        ],
      ),
    );
  }
}
