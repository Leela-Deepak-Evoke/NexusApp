import 'package:evoke_nexus_app/app/models/user_comment.dart';
import 'package:evoke_nexus_app/app/services/comment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentServiceProvider =
    Provider<CommentService>((ref) => CommentService());

final commentsProvider = FutureProvider.autoDispose
    .family<List<UserComment>, Map<String, dynamic>>((ref, params) async {
  final likeService = ref.read(commentServiceProvider);
  final spaceName = params['spaceName'] ?? '';
  final spaceId = params['spaceId'] ?? '';
  final userId = params['userId'] ?? '';

  final feeds = await likeService.getComments(spaceName, spaceId, userId);
  return feeds;
});

final authorThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final likeService = ref.watch(commentServiceProvider);
  return await likeService.getAuthorThumbnail(key);
});
