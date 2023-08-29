import 'package:evoke_nexus_app/app/services/profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/models/user.dart';

final profileServiceProvider =
    Provider<ProfileService>((ref) => ProfileService());

final profileThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final profileService = ref.watch(profileServiceProvider);
  return await profileService.getProfileImageUrl(key);
});

final uploadProfileImageProvider =
    FutureProvider.autoDispose.family<void, String>((ref, userId) async {
  final profileService = ref.watch(profileServiceProvider);
  return await profileService.uploadProfileImage(userId);
});

final updateUserProvider =
    FutureProvider.autoDispose.family<User, User>((ref, user) async {
  final profileService = ref.watch(profileServiceProvider);
  return await profileService.updateUser(user);
});
