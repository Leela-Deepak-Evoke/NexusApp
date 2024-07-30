import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/services/user_service.dart';
import 'package:evoke_nexus_app/app/models/user.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final currentUserProvider = StateProvider<User?>((ref) => null);
final isCheckedProvider = StateProvider<bool>((ref) => false); // Initialize with false



final checkUserProvider= FutureProvider<User>((ref) async {
  final userService = ref.read(userServiceProvider);
  final user = await userService.checkUser();

  ref.read(currentUserProvider.notifier).state = user;

  return user;
});

final checkUserProvider1 = FutureProvider<User>((ref) async {
  final bool isChecked = ref.watch(isCheckedProvider); 
  final userService = ref.read(userServiceProvider);
  final user = await userService.checkUserFlagCheck(isChecked: isChecked);
  ref.read(currentUserProvider.notifier).state = user;
  return user;
});


final fetchUserProvider = FutureProvider<User>((ref) async {
  final userService = ref.read(userServiceProvider);
  final user = await userService.fetchUser();
  ref.read(currentUserProvider.notifier).state = user;
  return user;
});


final refresUserProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, user) async {
  ref.invalidate(checkUserProvider);
return true;
});