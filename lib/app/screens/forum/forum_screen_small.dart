import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/forum_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/forum_web_view.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_utils.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/widgets/layout/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForumScreenSmall extends ConsumerStatefulWidget {
  const ForumScreenSmall({super.key});
  @override
  ConsumerState<ForumScreenSmall> createState() => _ForumScreenSmallState();
}

class _ForumScreenSmallState extends ConsumerState<ForumScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return   MobileLayout(
          title: 'Forum',
          user: data,
          child:  ForumMobileView(user: data,onPostClicked: () {
            context.goNamed(AppRoute.postforum.name,extra: data);
        },
        ), 
         hasBackAction: false,
          hasRightAction: true,
                    showSearchIcon: false,

          topBarButtonAction: () {
            
             Navigator.push(
              context,
              MaterialPageRoute(fullscreenDialog: true,
                  builder: (context) => CreatePostForumScreen()));
  

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
