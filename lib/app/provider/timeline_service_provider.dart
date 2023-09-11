import 'package:evoke_nexus_app/app/services/timeline_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/feed.dart';
import '../models/user.dart';

final timelineServiceProvider = Provider<TimelineService>((ref) => TimelineService());


final timelineProvider =
    FutureProvider.family<List<Feed>, User>((ref, user) async {
  final timlineService = ref.read(timelineServiceProvider);
  final timlines = await timlineService.fetchTimeline(user);
  return timlines;
});