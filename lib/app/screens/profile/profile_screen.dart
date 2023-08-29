import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: ProfileScreenSmall(),
      mediumScreenLayout: ProfileScreenMedium(),
      largeScreenLayout: ProfileScreenLarge(),
    );
  }
}
