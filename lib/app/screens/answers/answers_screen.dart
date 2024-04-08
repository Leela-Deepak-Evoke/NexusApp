import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_screen_small.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class AnswersScreen extends StatelessWidget {
   const AnswersScreen({Key? key,required this.question}) : super(key: key);
  final Question question;
  
  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
      smallScreenLayout: AnswersScreenSmall(question: question),
      mediumScreenLayout: const AnswersScreenMedium(),
      largeScreenLayout: const AnswersScreenLarge(),
    );
  }
}
