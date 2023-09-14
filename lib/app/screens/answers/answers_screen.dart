import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/answers_list.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_list_mobile.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/forum_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/forum_web_view.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_utils.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/widgets/common/mobile_nav_topbar.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/widgets/layout/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnswersScreen extends ConsumerStatefulWidget {
  const AnswersScreen({super.key,required this.questionid,required this.question});
  final String questionid;
  final Question question;

  @override
  ConsumerState<AnswersScreen> createState() => _AnswersScreenState();
}

class _AnswersScreenState extends ConsumerState<AnswersScreen> {
  @override
  void  onPostClicked()
  {

  }
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return 
         MobileLayout(
          title: 'Answers',
          user: data,
          child: AnswersMobileView(user: data, questionid: widget.questionid, question: widget.question ,onPostClicked:onPostClicked),
          hasBackAction: true,
          hasRightAction: true,
          topBarButtonAction: () {
            
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
        );
         
      },
      loading: () => const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return Text('An error occurred: $error');
      },
    );
  }
}
