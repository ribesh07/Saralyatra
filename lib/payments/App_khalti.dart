import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:saralyatra/routes/app_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  final String _publicKey = 'test_public_key_88f255b7a1f64a08884e811440174478';

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      enabledDebugging: true,
      publicKey: _publicKey,
      builder: (BuildContext context, GlobalKey<NavigatorState> navigatorKey) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NE'),
          ],
          localizationsDelegates: const [KhaltiLocalizations.delegate],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: AppRoute.getAppRoutes(),
          initialRoute: AppRoute.homeRoute,
        );
      },
    );
  }
}
