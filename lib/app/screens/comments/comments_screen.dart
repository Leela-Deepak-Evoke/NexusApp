import 'package:evoke_nexus_app/app/screens/comments/comments_screen_medium.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: CommentScreenSmall(),
      mediumScreenLayout: CommentScreenMedium(),
      largeScreenLayout: CommentScreenLarge(),
    );
  }
}
