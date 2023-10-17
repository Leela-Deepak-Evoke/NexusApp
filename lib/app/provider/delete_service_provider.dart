import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/services/delete_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteServiceProvider = Provider<DeleteService>((ref) => DeleteService());

final deleteProvider =
    FutureProvider.family<void, Delete>((ref, params) async {
  final deleteService = ref.watch(deleteServiceProvider);
  await deleteService.postDelete(params);
  ref.invalidate(feedsProvider);
});
