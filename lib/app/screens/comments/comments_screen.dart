import 'package:evoke_nexus_app/app/screens/comments/comments_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatelessWidget {
    final Widget? headerCard;
      final String posttype;
        final String postId;
   const CommentScreen({Key? key, this.headerCard ,required this.posttype,required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
      smallScreenLayout: CommentScreenSmall(headerCard: headerCard ?? Container(), postId: postId,posttype: posttype),
      mediumScreenLayout: const CommentScreenMedium(),
      largeScreenLayout: const CommentScreenLarge(),
    );
  }
}
