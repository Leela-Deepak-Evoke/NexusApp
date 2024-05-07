
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/services/userhome_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/models/userhome.dart';

final homeServiceProvider = Provider<UserHomeService>((ref) => UserHomeService());
final userHomeProvider = FutureProvider.autoDispose.family<UserHome, User>((ref, user) async {
  final userHomeService = ref.read(homeServiceProvider);
  final userHome = await userHomeService.fetchUserHome(user);

  return userHome;
});

final refresUserHomeProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, user) async {
  ref.invalidate(userHomeProvider);
return true;
});


