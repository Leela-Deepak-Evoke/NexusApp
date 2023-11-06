import 'package:evoke_nexus_app/app/models/fetch_answer_params.dart';
import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_list_mobile.dart';
import 'package:evoke_nexus_app/app/screens/answers/question_card_view.dart';
import 'package:flutter/material.dart';

class AnswersMobileView extends StatefulWidget {
  final User user;
  final Question question;
  Function() onPostClicked;
    AnswersMobileView({super.key, required this.user,required this.question,required this.onPostClicked});

  @override
  State<AnswersMobileView> createState() => _AnswersMobileViewCardState();
}

class _AnswersMobileViewCardState extends State<AnswersMobileView> {
  @override
  Widget build(BuildContext context) {
 final Size size = MediaQuery.of(context).size;

    return 
       Column(children: [

        SizedBox(
         width: size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            child:  QuestionCardView(user: widget.user, item: widget.question)
          ),
        ),
        Expanded(
          child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0), 
            child:   AnswerListMobile(params: FetchAnswerParams(userId: widget.user.userId, questionId: widget.question.questionId), user: widget.user, questionId: widget.question.questionId, question: widget.question)  )
,
          ),
        
    ]);
     }
}

