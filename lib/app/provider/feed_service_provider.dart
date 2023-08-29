import 'package:evoke_nexus_app/app/models/post_feed_params.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/services/feed_service.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';

final feedServiceProvider = Provider<FeedService>((ref) => FeedService());

final feedsProvider =
    FutureProvider.autoDispose.family<List<Feed>, User>((ref, user) async {
  final feedService = ref.read(feedServiceProvider);
  final feeds = await feedService.fetchFeeds(user);

  return feeds;
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

final postFeedProvider = FutureProvider.autoDispose
    .family<void, PostFeedParams>((ref, params) async {
  final feedService = ref.watch(feedServiceProvider);
  await feedService.postFeed(params);
});
