import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  //  ProfileScreen({Key? key}) : super(key: key);

final BuildContext context;
  final GoRouter router; // Add this line
  ProfileScreen({Key? key, required this.context, required this.router}) : super(key: key); // Update the constructor


  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
      smallScreenLayout: ProfileScreenSmall(context: context, router: router),
      mediumScreenLayout: ProfileScreenMedium(),
      largeScreenLayout: ProfileScreenLarge(),
    );
  }
}
