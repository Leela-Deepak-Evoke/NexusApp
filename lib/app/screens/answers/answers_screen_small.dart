import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/create_post_answers/create_post_answer_screen.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class AnswersScreenSmall extends ConsumerStatefulWidget {
   AnswersScreenSmall({super.key,required this.question});
  final Question question;
  @override
  ConsumerState<AnswersScreenSmall> createState() => _AnswersScreenSmallState();
}

class _AnswersScreenSmallState extends ConsumerState<AnswersScreenSmall> {
  Widget build(BuildContext context) 
  {
      void  onPostClicked()
      {  
        

      }
   final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return 
         MobileLayout(
          title: 'Answers',
          user: data,
          hasBackAction: true,
          hasRightAction: true,
          topBarButtonAction: () {
            setState(() {
       
             Navigator.push(
              context,
              MaterialPageRoute(fullscreenDialog: true,
                  builder: (context) => CreatePostAnswerScreen(question: widget.question)));

           }); 
           },
          backButtonAction: () {
            Navigator.pop(context);
          },
          child: AnswersMobileView(user: data, question: widget.question ,onPostClicked:onPostClicked),
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


// class AnswersScreen extends ConsumerStatefulWidget {
//   const AnswersScreen({super.key,required this.questionid,required this.question});
//   final String questionid;
//   final Question question;
  
//   @override
//   ConsumerState<AnswersScreen> createState() => _AnswersScreenState();
// }

// class _AnswersScreenState extends ConsumerState<AnswersScreen> {
//   @override
//   void  onPostClicked()
//   {

//   }
//   Widget build(BuildContext context) {

// }
