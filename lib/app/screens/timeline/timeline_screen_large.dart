import 'package:evoke_nexus_app/app/screens/timeline/widgets/timeline_web_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class TimelineScreenLarge extends ConsumerStatefulWidget {
  const TimelineScreenLarge({super.key});
  @override
  ConsumerState<TimelineScreenLarge> createState() => _TimelineScreenLargeState();
}

class _TimelineScreenLargeState extends ConsumerState<TimelineScreenLarge> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return WebLayout(
          title: 'Timeline',
          user: data,
          child: TimelineWebView(user : data ),
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
