import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/org_updates_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/org_updates_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/org_updates_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class OrgUpdatesScreen extends StatelessWidget {
  const OrgUpdatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: OrgUpdatesScreenSmall(),
      mediumScreenLayout: OrgUpdatesScreenMedium(),
      largeScreenLayout: OrgUpdatesScreenLarge(),
    );
  }
}
