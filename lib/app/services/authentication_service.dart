import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class AuthenticationService {
  Future<void> login() async {
    try {
      // Sign in with SAML identity provider
      safePrint('Before Login');
      if (Platform.isIOS) {
        final result = await Amplify.Auth.signInWithWebUI(
          provider: const AuthProvider.saml("EvokeAzureAD"),
          options: const SignInWithWebUIOptions(
            pluginOptions: CognitoSignInWithWebUIPluginOptions(
              isPreferPrivateSession: true,
            ),
          ),
        );
        safePrint('Result: $result');
      } else {
        final result = await Amplify.Auth.signInWithWebUI(
          provider: const AuthProvider.saml("EvokeAzureAD"),
        );
        safePrint('Result: $result');
      }
    } catch (e) {
      safePrint('Error at Evoke AD login: $e');
    }
  }

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  //Mobile
}
