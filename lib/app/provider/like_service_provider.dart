import 'package:evoke_nexus_app/app/models/user_like.dart';
import 'package:evoke_nexus_app/app/services/like_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final likeServiceProvider = Provider<LikeService>((ref) => LikeService());

final likesProvider = FutureProvider.autoDispose
    .family<List<UserLike>, Map<String, dynamic>>((ref, params) async {
  final likeService = ref.read(likeServiceProvider);
  final spaceName = params['spaceName'] ?? '';
  final spaceId = params['spaceId'] ?? '';
  final userId = params['userId'] ?? '';

  final feeds = await likeService.getLikes(spaceName, spaceId, userId);
  return feeds;
});

final authorThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final likeService = ref.watch(likeServiceProvider);
  return await likeService.getAuthorThumbnail(key);
});
