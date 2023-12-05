import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/welcome/welcome_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/welcome/welcome_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/welcome/welcome_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: WelcomeScreenSmall(),
      mediumScreenLayout: WelcomeScreenMedium(),
      largeScreenLayout: WelcomeScreenLarge(),
    );
  }
}
