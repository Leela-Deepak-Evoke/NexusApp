import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_mobile_view.dart';

// class FeedsScreenSmall extends StatefulWidget {
//   const FeedsScreenSmall({super.key});

//   @override
//   State<FeedsScreenSmall> createState() => _FeedsScreenSmallState();
// }

// class _FeedsScreenSmallState extends State<FeedsScreenSmall> {
//   @override
//   Widget build(BuildContext context) {
//      return MobileLayout(
//           title: 'Feeds',
//           // user: data,
//           child: FeedsMobileView(),
//         );
//   }
// }

class FeedsScreenSmall extends ConsumerStatefulWidget {
  const FeedsScreenSmall({super.key});
  @override
  ConsumerState<FeedsScreenSmall> createState() => _FeedsScreenSmallState();
}

class _FeedsScreenSmallState extends ConsumerState<FeedsScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return MobileLayout(
          title: 'Feeds',
          user: data,
          child: FeedsMobileView(user: data),
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
