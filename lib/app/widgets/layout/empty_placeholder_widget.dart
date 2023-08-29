import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';

class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoute.home.name),
              child: const Text('Go Home'),
            )
          ],
        ),
      ),
    );
  }
}
