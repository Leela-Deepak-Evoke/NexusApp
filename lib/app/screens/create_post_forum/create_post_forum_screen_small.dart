import 'package:evoke_nexus_app/app/screens/create_post_forum/widgets/post_forum_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';

class CreatePostForumScreenSmall extends ConsumerStatefulWidget {
  const CreatePostForumScreenSmall({super.key});
  
  @override
  ConsumerState<CreatePostForumScreenSmall> createState() => _CreatePostForumScreenSmallState();
}

class _CreatePostForumScreenSmallState extends ConsumerState<CreatePostForumScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
         return    MobileLayout(
          title: "Post Question",
          user: data,
          hasBackAction: true,
          hasRightAction: false,
          topBarButtonAction: () {           
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          child: PostForumMobileView(user: data),
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
