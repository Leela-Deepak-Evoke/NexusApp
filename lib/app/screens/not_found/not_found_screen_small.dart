import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/widgets/layout/empty_placeholder_widget.dart';

class NotFoundScreenSmall extends ConsumerWidget {
  const NotFoundScreenSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const EmptyPlaceholderWidget(
        message: '404 - Page not found!',
      ),
    );
  }
}
