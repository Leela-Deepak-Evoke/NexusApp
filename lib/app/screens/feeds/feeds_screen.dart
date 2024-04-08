import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/feeds/feeds_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/feeds/feeds_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/feeds/feeds_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class FeedsScreen extends StatelessWidget {
  bool? isFromHomePage;

  FeedsScreen({Key? key, this.isFromHomePage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      smallScreenLayout: FeedsScreenSmall(isFromHomePage: isFromHomePage),
      mediumScreenLayout: const FeedsScreenMedium(),
      largeScreenLayout: const FeedsScreenLarge(),
    );
  }
}
