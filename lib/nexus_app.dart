import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NexusApp extends StatelessWidget {
  const NexusApp({
    required this.isAmplifySuccessfullyConfigured,
    Key? key,
    required this.router,
  }) : super(key: key);

  final bool isAmplifySuccessfullyConfigured;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addObserver(AppStateObserver());
    return MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) => 'Evoke Nexus',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ));
  }
}

class AppStateObserver extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print('------------state--------$state');
    if (state == AppLifecycleState.detached) {
      print('App resumed from the background');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('authToken');
      preferences.clear();

      // Add your logic here to handle the app resuming from the background
    }
  }
}
