import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen_small.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class CreatePostForumScreen extends StatelessWidget {
     Question? questionItem; // Remove the const keyword
   bool? isEditQuestion;
   CreatePostForumScreen({Key? key, this.questionItem, this.isEditQuestion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
      smallScreenLayout: CreatePostForumScreenSmall(questionItem: questionItem, isEditQuestion: isEditQuestion),
      mediumScreenLayout: const CreatePostForumScreenMedium(),
      largeScreenLayout: const CreatePostForumScreenLarge(),
    );
  }
}
