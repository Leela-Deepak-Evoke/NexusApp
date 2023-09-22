import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
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
   await profileService.uploadProfileImage(userId);
      ref.invalidate(fetchUserProvider);
   ref.invalidate(profileThumbnailProvider);
});

final updateUserProvider =
    FutureProvider.autoDispose.family<User, User>((ref, user) async {
  final profileService = ref.watch(profileServiceProvider);
  final updateImage =  await profileService.updateUser(user);
      ref.invalidate(fetchUserProvider);
    ref.invalidate(profileThumbnailProvider);
    return updateImage;
});
