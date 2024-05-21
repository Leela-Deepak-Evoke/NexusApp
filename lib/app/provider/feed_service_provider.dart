import 'package:evoke_nexus_app/app/models/filter_feed.dart';
import 'package:evoke_nexus_app/app/models/post_feed_params.dart';
import 'package:evoke_nexus_app/app/models/post_likedislike_params.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/services/feed_service.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';

final feedServiceProvider = Provider<FeedService>((ref) => FeedService());

final selectedItemProvider = StateProvider<Feed?>((ref) => null);

final feedsProvider =
    FutureProvider.autoDispose.family<List<Feed>, User>((ref, user) async {
  final feedService = ref.read(feedServiceProvider);
  final feeds = await feedService.fetchFeeds(user);

  return feeds;
});

//Filter Feeds
final filterFeedsProvider = FutureProvider.autoDispose.family<List<Feed>, FilterFeedsParams>((ref, params) async {
  final feedService = ref.read(feedServiceProvider);
  final userID = params.userId;
  final categories = params.categories;
  final sortType = params.sortType ?? "";

  final filterFeeds = await feedService.filterFeeds(userID, categories: categories, sortType: sortType);
  ref.invalidate(feedsProvider);
  return filterFeeds;
});

final mediaUrlProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final feedService = ref.watch(feedServiceProvider);
  return await feedService.getMediaURL(key);
});

final authorThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final feedService = ref.watch(feedServiceProvider);
  return await feedService.getAuthorThumbnail(key);
});

final postFeedProvider =
    FutureProvider.family<void, PostFeedParams>((ref, params) async {
  final feedService = ref.watch(feedServiceProvider);
  await feedService.postFeed(params);
  ref.invalidate(feedsProvider);
    ref.invalidate(filterFeedsProvider);

});

final editFeedProvider =
    FutureProvider.family<void, PostFeedParams>((ref, params) async {
  final feedService = ref.watch(feedServiceProvider);
  await feedService.editFeed(params);
  ref.invalidate(feedsProvider);
      ref.invalidate(filterFeedsProvider);

});

final postlikeDislikeProvider = FutureProvider.autoDispose
    .family<bool, PostLikeDislikeParams>((ref, params) async {
  final likeService = ref.watch(feedServiceProvider);
  final likeStatus = await likeService.postlikedislike(params);
  ref.invalidate(feedsProvider);
      ref.invalidate(filterFeedsProvider);

  return likeStatus;
});

final refresFeedsProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, user) async {
  ref.invalidate(feedsProvider);
      ref.invalidate(filterFeedsProvider);

  return true;
});


//Need to use
// final pagginationFeedsProvider =
//     FutureProvider.autoDispose.family<bool, String>((ref, user) async {
//   ref.invalidate(feedsProvider);
//       ref.invalidate(filterFeedsProvider);

//   return true;
// });

