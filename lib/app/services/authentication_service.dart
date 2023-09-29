// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AuthenticationService {
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  Future<void> login(
      Function(bool isSucess) onloginComplition, BuildContext context) async {
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
      final result = await Amplify.Auth.signInWithWebUI(
          provider: const AuthProvider.saml("EvokeAzureAD"));

      debugPrint('Result: $result');
      onloginComplition(true);

      // final result = await Amplify.Auth.signInWithWebUI(provider: const AuthProvider.saml("EvokeAzureAD"));

      // // Add WebView settings here
      // flutterWebViewPlugin.onStateChanged.listen((viewState) {
      //   if (viewState.type == WebViewState.finishLoad) {
      //     // Apply WebView settings here, e.g., clearing cache
      //     flutterWebViewPlugin.clearCache(); // Clear WebView cache
      //   }
      // });

      // safePrint('Result: $result');
      // onloginComplition(true);
    }
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
