import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ForumsTabMenu extends StatelessWidget {
  const ForumsTabMenu({
    Key? key,
    required this.router,
  }) : super(key: key);
  final GoRouter router;
  @override
  Widget build(BuildContext context) {
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