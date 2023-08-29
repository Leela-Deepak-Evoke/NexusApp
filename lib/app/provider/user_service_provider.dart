import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/services/user_service.dart';
import 'package:evoke_nexus_app/app/models/user.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final currentUserProvider = StateProvider<User?>((ref) => null);

final checkUserProvider = FutureProvider<User>((ref) async {
  final userService = ref.read(userServiceProvider);
  final user = await userService.checkUser();

  ref.read(currentUserProvider.notifier).state = user;

  return user;
});

final fetchUserProvider = FutureProvider<User>((ref) async {
  final userService = ref.read(userServiceProvider);
  final user = await userService.fetchUser();

  ref.read(currentUserProvider.notifier).state = user;

  return user;
});
