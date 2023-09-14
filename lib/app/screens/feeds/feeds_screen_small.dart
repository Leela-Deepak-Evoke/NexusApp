import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_routes.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_mobile_view.dart';

class FeedsScreenSmall extends ConsumerStatefulWidget {
  const FeedsScreenSmall({super.key});
  
  @override
  ConsumerState<FeedsScreenSmall> createState() => _FeedsScreenSmallState();
}

class _FeedsScreenSmallState extends ConsumerState<FeedsScreenSmall> {
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
      return MobileLayout(title: "SOCIAL FEED", user: data, canPost: true, onPostClicked: () {
             Navigator.push(
                          context,
                          MaterialPageRoute(fullscreenDialog: true,

                              builder: (context) => const CreatePostFeedScreen()));
                              

        },child: FeedsMobileView(user: data));
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