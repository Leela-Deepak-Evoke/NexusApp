import 'package:evoke_nexus_app/app/models/answer.dart';
import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/screens/create_post_answers/create_post_answer_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/create_post_answers/create_post_answer_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/create_post_answers/create_post_answer_screen_small.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class CreatePostAnswerScreen extends StatelessWidget {
   final Question question;
    final Answer? answerItem;
       bool? isEditAnswer;

   CreatePostAnswerScreen({Key? key, required this.question,  this.answerItem, this.isEditAnswer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
      smallScreenLayout: CreatePostAnswerScreenSmall(question: question, answerItem: answerItem, isEditAnswer: isEditAnswer),
      mediumScreenLayout: CreatePostAnswerScreenMedium(question: question),
      largeScreenLayout: CreatePostAnswerScreenLarge(question: question),
    );
  }
}
