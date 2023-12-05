import 'package:evoke_nexus_app/app/widgets/layout/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class WelcomeScreenLarge extends ConsumerStatefulWidget {
  const WelcomeScreenLarge({super.key});
  @override
  ConsumerState<WelcomeScreenLarge> createState() => _WelcomeScreenLargeState();
}

class _WelcomeScreenLargeState extends ConsumerState<WelcomeScreenLarge> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return WebLayout(
          title: 'Test',
          user: data,
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
