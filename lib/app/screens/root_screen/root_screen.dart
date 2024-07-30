import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final checkUserAsyncValue = ref.watch(checkUserProvider);

    if (checkUserAsyncValue is AsyncData) {
      GoRouter.of(context).go('/home');
      return const SizedBox.shrink();
    }

    if (checkUserAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (checkUserAsyncValue is AsyncError) {
      return Text('An error occurred: ${checkUserAsyncValue.error}');
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }
}
