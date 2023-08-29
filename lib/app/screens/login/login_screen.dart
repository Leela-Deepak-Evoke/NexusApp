import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/login/login_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/login/login_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/login/login_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: LoginScreenSmall(),
      mediumScreenLayout: LoginScreenMedium(),
      largeScreenLayout: LoginScreenLarge(),
    );
  }
}
