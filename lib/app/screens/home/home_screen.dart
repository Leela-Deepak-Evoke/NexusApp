import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: HomeScreenSmall(),
      mediumScreenLayout: HomeScreenMedium(),
      largeScreenLayout: HomeScreenLarge(),
    );
  }
}
