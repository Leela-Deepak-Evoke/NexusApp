import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class TestScreenSmall extends ConsumerStatefulWidget {
  const TestScreenSmall({super.key});
  @override
  ConsumerState<TestScreenSmall> createState() => _TestScreenSmallState();
}

class _TestScreenSmallState extends ConsumerState<TestScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return MobileLayout(
          title: 'Test',
          user: data,
            hasBackAction: false,
          hasRightAction: true,
          topBarButtonAction: () {
            
          },
          child: const Center(
            child: Text('Test Screen'),
            
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
}
