import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
      smallScreenLayout: HomeScreenSmall(),
      mediumScreenLayout: HomeScreenMedium(),
      largeScreenLayout: HomeScreenLarge(),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   final Function() refreshScreen; // Define a callback function for screen refresh

//   const HomeScreen({Key? key, required this.refreshScreen}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveLayout(
//       // Pass the refreshScreen callback function to HomeScreenSmall
//       smallScreenLayout: HomeScreenSmall(onRefresh: refreshScreen),
//       mediumScreenLayout: HomeScreenMedium(),
//       largeScreenLayout: HomeScreenLarge(),
//     );
//   }
// }