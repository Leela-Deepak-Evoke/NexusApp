import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumList extends ConsumerWidget {
  final User user;
  const ForumList({super.key, required this.user});

  //final feedService = FeedService();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }
}
