import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/widgets/layout/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class CreatePostAnswerScreenLarge extends ConsumerStatefulWidget {
   final Question question;
  const CreatePostAnswerScreenLarge({super.key , required this.question});
  @override
  ConsumerState<CreatePostAnswerScreenLarge> createState() => _CreatePostAnswerScreenLargeState();
}

class _CreatePostAnswerScreenLargeState extends ConsumerState<CreatePostAnswerScreenLarge> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return WebLayout(
          title: 'Feeds',
          user: data,
          child: Container(),
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
