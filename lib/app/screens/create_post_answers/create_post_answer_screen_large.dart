import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_web_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class CreatePostForumScreenLarge extends ConsumerStatefulWidget {
  const CreatePostForumScreenLarge({super.key});
  @override
  ConsumerState<CreatePostForumScreenLarge> createState() => _CreatePostForumScreenLargeState();
}

class _CreatePostForumScreenLargeState extends ConsumerState<CreatePostForumScreenLarge> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return WebLayout(
          title: 'Feeds',
          user: data,
          child: FeedsWebView(user: data),
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
