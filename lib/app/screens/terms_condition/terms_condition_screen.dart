import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/terms_condition/terms_condition_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/terms_condition/terms_condition_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/terms_condition/terms_condition_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: TermsConditionScreenSmall(),
      mediumScreenLayout: TermsConditionScreenMedium(),
      largeScreenLayout: TermsConditionScreenLarge(),
    );
  }
}
