import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:evoke_nexus_app/app/models/post_org_update_params.dart';
import 'package:evoke_nexus_app/app/services/org_update_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/models/user.dart';

final orgUpdateServiceProvider =
    Provider<OrgUpdateService>((ref) => OrgUpdateService());

final orgUpdatesProvider =
    FutureProvider.autoDispose.family<List<OrgUpdate>, User>((ref, user) async {
  final orgUpdateService = ref.read(orgUpdateServiceProvider);
  final orgUpdates = await orgUpdateService.fetchOrgUpdates(user);

  return orgUpdates;
});

final mediaUrlProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final orgUpdateService = ref.watch(orgUpdateServiceProvider);
  return await orgUpdateService.getMediaURL(key);
});

final authorThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final orgUpdateService = ref.watch(orgUpdateServiceProvider);
  return await orgUpdateService.getAuthorThumbnail(key);
});

final postOrgUpdateProvider = FutureProvider.autoDispose
    .family<void, PostOrgUpdateParams>((ref, params) async {
  final orgUpdateService = ref.watch(orgUpdateServiceProvider);
  await orgUpdateService.postOrgUpdate(params);
});
