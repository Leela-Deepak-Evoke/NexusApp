import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/review/review_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/review/review_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/review/review_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class ReviewScreen extends StatelessWidget {
  bool? isFromHomePage;

  ReviewScreen({Key? key, this.isFromHomePage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      smallScreenLayout: ReviewScreenSmall(isFromHomePage: isFromHomePage),
      mediumScreenLayout: const ReviewScreenMedium(),
      largeScreenLayout: const ReviewScreenLarge(),
    );
  }
}
