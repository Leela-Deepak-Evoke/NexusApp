import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/screens/create_post_answers/widgets/post_answer_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';

class CreatePostAnswerScreenSmall extends ConsumerStatefulWidget {
    final Question question;

  const CreatePostAnswerScreenSmall({super.key,required this.question});
  
  @override
  ConsumerState<CreatePostAnswerScreenSmall> createState() => _CreatePostAnswerScreenSmallState();
}

class _CreatePostAnswerScreenSmallState extends ConsumerState<CreatePostAnswerScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
         return    MobileLayout(
          title: "Post Answer",
          user: data,
          hasBackAction: true,
          hasRightAction: false,
          topBarButtonAction: () {           
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          child: PostAnswerMobileView(user: data ,question: widget.question),
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
