import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  //  ProfileScreen({Key? key}) : super(key: key);

final BuildContext? rootScreenMobileContext;

  const ProfileScreen({Key? key, this.rootScreenMobileContext}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
      smallScreenLayout: ProfileScreenSmall(context: rootScreenMobileContext!),
      mediumScreenLayout: ProfileScreenMedium(),
      largeScreenLayout: ProfileScreenLarge(),
    );
  }
}
