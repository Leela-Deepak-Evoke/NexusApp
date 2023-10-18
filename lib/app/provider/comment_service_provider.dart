import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/post_comment_params.dart';
import 'package:evoke_nexus_app/app/models/user_comment.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/services/comment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentServiceProvider =
    Provider<CommentService>((ref) => CommentService());

final commentsProvider = FutureProvider.autoDispose
    .family<List<UserComment>, GetCommentsParams>((ref, params) async {
  final likeService = ref.read(commentServiceProvider);
  final spaceName = params.postType ?? '';
  final spaceId = params.postId ?? '';
  final userId = params.userId ?? '';

  final comment = await likeService.getComments(spaceName, spaceId, userId);
  print(comment);
  return comment;
});


final authorThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final likeService = ref.watch(commentServiceProvider);
  return await likeService.getAuthorThumbnail(key);
});

final authorThumbnailProviderComments =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final likeService = ref.watch(commentServiceProvider);
  return await likeService.getAuthorThumbnail(key);
});

final postCommentProvider =
    FutureProvider.family<void, PostCommentsParams>((ref, params) async {
  final feedService = ref.watch(commentServiceProvider);
  await feedService.postComment(params);
  ref.invalidate(commentsProvider);
   ref.invalidate(feedsProvider);
    ref.invalidate(orgUpdatesProvider);
    ref.invalidate(answerListProvider);
});
