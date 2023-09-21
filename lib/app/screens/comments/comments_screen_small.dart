import 'package:evoke_nexus_app/app/screens/comments/widgets/comments_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/widgets/postfeed_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import '../../utils/app_routes.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_mobile_view.dart';

class CommentScreenSmall extends ConsumerStatefulWidget {
  const CommentScreenSmall({super.key});
  
  @override
  ConsumerState<CommentScreenSmall> createState() => _CommentScreenSmallState();
}

class _CommentScreenSmallState extends ConsumerState<CommentScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
         return    MobileLayout(
          title: "Comments",
          user: data,
          hasBackAction: true,
          hasRightAction: false,
          topBarButtonAction: () {           
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          child: CommentsMobileView(user: data),
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
