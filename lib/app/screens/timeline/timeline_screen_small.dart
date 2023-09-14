import 'package:evoke_nexus_app/app/screens/timeline/widgets/timeline_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class TimelineScreenSmall extends ConsumerStatefulWidget {
  const TimelineScreenSmall({super.key});
  @override
  ConsumerState<TimelineScreenSmall> createState() => _TimelineScreenSmallState();
}

class _TimelineScreenSmallState extends ConsumerState<TimelineScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return MobileLayout(
          title: 'Timeline',
          user: data,
          hasBackAction: true,
          hasRightAction: false,
          topBarButtonAction: () {

          },
          child: TimelineMobileView(user: data),
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
