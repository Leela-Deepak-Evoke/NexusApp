import 'dart:io' show Platform;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationService {
  Future<void> login( Function(bool isSucess) onloginComplition) async {
  
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
        onloginComplition(true);
      } else {
        // final result = await Amplify.Auth.signInWithWebUI(
        //   provider: const AuthProvider.saml("EvokeAzureAD"),
        // );

        try {
  final result = await Amplify.Auth.signInWithWebUI(
    provider: const AuthProvider.saml("EvokeAzureAD"),
  );
  safePrint('Result: $result');
} catch (e) {
  safePrint('Error: $e');
}
        
        // safePrint('Result: $result');
      }
    } 
  }

  // Launch a URL
_launchURL() async {
  const url = 'nexusapp://example.com'; // Replace with your URL
  if (await canLaunchUrl(url as Uri)) {
    await launchUrl(url as Uri);
  } else {
    throw 'Could not launch $url';
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

