import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/services/authentication_service.dart';

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService();
});
