import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/post_likedislike_params.dart';
import 'package:evoke_nexus_app/app/models/user_like.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/timeline_service_provider.dart';
import 'package:evoke_nexus_app/app/services/like_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final likeServiceProvider = Provider<LikeService>((ref) => LikeService());

final likesProvider = FutureProvider.autoDispose.
 family<List<UserLike>,GetCommentsParams>((ref, params)  async
{
   final likeService = ref.read(likeServiceProvider);
  final like = await likeService.getLikes(params);
  return like;
  
},);

final authorThumbnailProviderViewLike =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final likeService = ref.watch(likeServiceProvider);
  return await likeService.getAuthorThumbnail(key);
});

final genricPostlikeDislikeProvider = FutureProvider.autoDispose
    .family<bool, PostLikeDislikeParams>((ref, params) async {
  final likeService = ref.watch(likeServiceProvider);
  final likeStatus = await likeService.postlikedislike(params);
  ref.invalidate(feedsProvider);
  ref.invalidate(orgUpdatesProvider);
  ref.invalidate(answerListProvider);
  ref.invalidate(timelineProvider);
  return likeStatus;
});
