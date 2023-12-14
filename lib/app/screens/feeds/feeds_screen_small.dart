import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen.dart';

import 'package:evoke_nexus_app/app/models/feed.dart';

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
        return MobileLayout(
          title: 'Feeds',
          user: data,
          hasBackAction: false,
          hasRightAction: true,
          showSearchIcon: true,
          topBarButtonAction: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => CreatePostFeedScreen()));
          },
         topBarSearchButtonAction: () {
                    //  FeedsMobileView.onSearchClickedStatic();
                    _showToast(context);

          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          // child: FeedsMobileView(user: data),
          child: FeedsMobileView(
            user: data,
            onSearchClicked: () {
              // FeedsMobileView mobileView =
              //     context.findAncestorWidgetOfExactType<FeedsMobileView>()!;
              // mobileView.onSearchClicked();
            },
          ),
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
 void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
          height: 70,
          child: Text('In Progress'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
