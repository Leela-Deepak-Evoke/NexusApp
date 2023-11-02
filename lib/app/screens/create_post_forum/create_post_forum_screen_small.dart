import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/widgets/post_forum_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/common/round_action_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';

class CreatePostForumScreenSmall extends ConsumerStatefulWidget {
   Question? questionItem; // Remove the const keyword
   bool? isEditQuestion;
  CreatePostForumScreenSmall({Key? key,  this.questionItem, this.isEditQuestion}) : super(key: key);
  @override
  ConsumerState<CreatePostForumScreenSmall> createState() => _CreatePostForumScreenSmallState();
}

class _CreatePostForumScreenSmallState extends ConsumerState<CreatePostForumScreenSmall> {
  @override
  Widget build(BuildContext context) {
    String rightActionTitle = 'Select Category';
      GlobalKey<PostForumMobileViewState> childKey = GlobalKey();

    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
         return    MobileLayout(
          title: "Post Question",
          user: data,
          hasBackAction: true,
          hasRightAction: true,
          topBarButtonAction: () {   
                    
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
         
            rightChildWiget: RoundedActionView(onPressed:() {
            childKey.currentState?.onCategorySelected();
          }
          , title: rightActionTitle),
          child: PostForumMobileView(key: childKey, user: data, questionItem: widget.questionItem, isEditQuestion: widget.isEditQuestion),

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
