import 'package:evoke_nexus_app/app/models/post_forum_params.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/services/forum_service.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/forum.dart';

final forumServiceProvider = Provider<ForumService>((ref) => ForumService());

final forumsProvider =
    FutureProvider.autoDispose.family<List<Forum>, User>((ref, user) async {
  final forumService = ref.read(forumServiceProvider);
  final forums = await forumService.fetchForums(user);

  return forums;
});

final mediaUrlProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final forumService = ref.watch(forumServiceProvider);
  return await forumService.getMediaURL(key);
});

final authorThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final forumService = ref.watch(forumServiceProvider);
  return await forumService.getAuthorThumbnail(key);
});

final postForumProvider = FutureProvider.autoDispose
    .family<void, PostForumParams>((ref, params) async {
  final forumService = ref.watch(forumServiceProvider);
  await forumService.postForum(params);
});
