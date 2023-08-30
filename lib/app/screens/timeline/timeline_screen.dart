import 'package:evoke_nexus_app/app/screens/timeline/timeline_screen_Large.dart';
import 'package:evoke_nexus_app/app/screens/timeline/timeline_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/timeline/timeline_screen_small.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: TimelineScreenSmall(),
      mediumScreenLayout: TimelineScreenMedium(),
      largeScreenLayout: TimelineScreenLarge(),
    );
  }
}
