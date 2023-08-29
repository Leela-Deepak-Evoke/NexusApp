import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/not_found/not_found_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/not_found/not_found_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/not_found/not_found_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: NotFoundScreenSmall(),
      mediumScreenLayout: NotFoundScreenMedium(),
      largeScreenLayout: NotFoundScreenLarge(),
    );
  }
}
