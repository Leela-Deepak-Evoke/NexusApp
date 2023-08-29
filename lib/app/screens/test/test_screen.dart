import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/test/test_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/test/test_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/test/test_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: TestScreenSmall(),
      mediumScreenLayout: TestScreenMedium(),
      largeScreenLayout: TestScreenLarge(),
    );
  }
}
