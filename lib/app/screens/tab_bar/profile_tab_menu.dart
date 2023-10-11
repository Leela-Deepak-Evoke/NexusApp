import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTabMenu extends StatelessWidget {
    Function() logoutAction;
  final BuildContext? rootScreenMobileContext;

   ProfileTabMenu({
    Key? key,
    required this.logoutAction,
    required this.rootScreenMobileContext,
    required this.router,
  }) : super(key: key);
  final GoRouter router;

  void openProfileScreen() {
  GoRouter.of(rootScreenMobileContext!).go('${AppRoute.profile.name}', extra: rootScreenMobileContext);
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => 'Evoke Nexus',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ));
  }

  
}