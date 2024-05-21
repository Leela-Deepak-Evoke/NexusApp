// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

// class AuthenticationService {
//   late final FlutterWebviewPlugin flutterWebViewPlugin;
//   late final WebviewCookieManager cookieManager;

//   AuthenticationService() {
//     // Initialize the FlutterWebviewPlugin instance
//     flutterWebViewPlugin = FlutterWebviewPlugin();
//     cookieManager = WebviewCookieManager();
//   }

//   Future<void> login(Function(bool isSuccess) onLoginCompletion, BuildContext context) async {
//     safePrint('Before Login');
//     await _clearWebViewCookiesAndCache();

//     try {
//       if (Platform.isIOS) {
//         final result = await Amplify.Auth.signInWithWebUI(
//           provider: const AuthProvider.saml("EvokeAzureAD"),
//           options: const SignInWithWebUIOptions(
//             pluginOptions: CognitoSignInWithWebUIPluginOptions(
//               isPreferPrivateSession: true,
//             ),
//           ),
//         );
//         safePrint('Result: $result');
//         onLoginCompletion(true);
//       } else {
//         final result = await Amplify.Auth.signInWithWebUI(
//           provider: const AuthProvider.saml("EvokeAzureAD"),
//         );
//         safePrint('Result: $result');
//         onLoginCompletion(true);
//       }
//     } catch (e) {
//       safePrint('Login failed: $e');
//       onLoginCompletion(false);
//     }
//   }

// Future<void> _clearWebViewCookiesAndCache() async {
//   try {
//     // Check if flutterWebViewPlugin is null before accessing its methods
//     if (flutterWebViewPlugin != null) {
//       await cookieManager.clearCookies();
//       await flutterWebViewPlugin.clearCache();
//       await flutterWebViewPlugin.cleanCookies();
//       safePrint('Webview cookies and cache cleared successfully');
//     } else {
//       // Handle the case when flutterWebViewPlugin is null
//       safePrint('Error: FlutterWebviewPlugin is null');
//     }
//   } catch (e, stackTrace) {
//     safePrint('Error clearing webview cookies and cache: $e');
//     safePrint('Stack trace: $stackTrace');
//   }
// }

//   Future<void> signOutCurrentUser() async {
//     try {
//       final result = await Amplify.Auth.signOut();
//       if (result is CognitoCompleteSignOut) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove('authToken');
//         await prefs.clear();
//         await prefs.commit
//         await _clearWebViewCookiesAndCache();
//         safePrint('Sign out completed successfully');
//       } else if (result is CognitoFailedSignOut) {
//         safePrint('Error signing user out: ${result.exception.message}');
//       } else if (result is CognitoPartialSignOut) {
//         safePrint('Partial sign out: ${result.signedOutLocally}');
//         if (result.signedOutLocally) {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.remove('authToken');
//           await prefs.clear();
//           await _clearWebViewCookiesAndCache();
//         }
//       }
//     } catch (e) {
//       safePrint('Error during sign out: $e');
//     }
//   }
// }



// class AuthenticationService {
//   late final FlutterWebviewPlugin flutterWebViewPlugin;
//   late final WebviewCookieManager cookieManager;

//   AuthenticationService() {
//     // Initialize FlutterWebviewPlugin in the constructor
//     flutterWebViewPlugin = FlutterWebviewPlugin();
//     cookieManager = WebviewCookieManager();
//   }

//   Future<void> login(Function(bool isSuccess) onLoginCompletion, BuildContext context) async {
//     safePrint('Before Login');
//     await _clearWebViewCookiesAndCache();

//     try {
//       if (Platform.isIOS) {
//         final result = await Amplify.Auth.signInWithWebUI(
//           provider: const AuthProvider.saml("EvokeAzureAD"),
//           options: const SignInWithWebUIOptions(
//             pluginOptions: CognitoSignInWithWebUIPluginOptions(
//               isPreferPrivateSession: true,
//             ),
//           ),
//         );
//         safePrint('Result: $result');
//         onLoginCompletion(true);
//       } else {
//         final result = await Amplify.Auth.signInWithWebUI(
//           provider: const AuthProvider.saml("EvokeAzureAD"),
//         );
//         safePrint('Result: $result');
//         onLoginCompletion(true);
//       }
//     } catch (e) {
//       safePrint('Login failed: $e');
//       onLoginCompletion(false);
//     }
//   }

//   Future<void> _clearWebViewCookiesAndCache() async {
//     try {
//       await cookieManager.clearCookies();
//       await flutterWebViewPlugin.clearCache();
//       await flutterWebViewPlugin.cleanCookies();
//     } catch (e) {
//       safePrint('Error clearing webview cookies and cache: $e');
//     }
//   }
// }

// Future<void> signOutCurrentUser() async {
//   try {
//     final result = await Amplify.Auth.signOut();
//     if (result is CognitoCompleteSignOut) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove('authToken');
//       await _clearWebViewCookiesAndCache();
//       safePrint('Sign out completed successfully');
//     } else if (result is CognitoFailedSignOut) {
//       safePrint('Error signing user out: ${result.exception.message}');
//     } else if (result is CognitoPartialSignOut) {
//       safePrint('Error signing user out: ${result.signedOutLocally}');
//       if (result.signedOutLocally) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove('authToken');
//         await prefs.clear();
//         await _clearWebViewCookiesAndCache();
//       }
//     }
//   } catch (e) {
//     safePrint('Error during sign out: $e');
//   }
// }

// Future<void> _clearWebViewCookiesAndCache() async {
//   try {
//     final cookieManager = WebviewCookieManager();
//     await cookieManager.clearCookies();
//     final flutterWebViewPlugin = FlutterWebviewPlugin();
//     await flutterWebViewPlugin.clearCache();
//     await flutterWebViewPlugin.cleanCookies();
//   } catch (e) {
//     safePrint('Error clearing webview cookies and cache: $e');
//   }
// }



// class AuthenticationService {
//   FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
//   final cookieManager = WebviewCookieManager();

//   Future<void> login(Function(bool isSuccess) onLoginCompletion, BuildContext context) async {
//     safePrint('Before Login');
//     await _clearWebViewCookiesAndCache();

//     if (Platform.isIOS) {
//       final result = await Amplify.Auth.signInWithWebUI(
//         provider: const AuthProvider.saml("EvokeAzureAD"),
//         options: const SignInWithWebUIOptions(
//           pluginOptions: CognitoSignInWithWebUIPluginOptions(
//             isPreferPrivateSession: true,
//           ),
//         ),
//       );
//       safePrint('Result: $result');
//       onLoginCompletion(true);
//     } else {
//       final result = await Amplify.Auth.signInWithWebUI(
//           provider: const AuthProvider.saml("EvokeAzureAD"));
//       safePrint('Result: $result');
//       onLoginCompletion(true);
//     }
//   }

//   Future<void> _clearWebViewCookiesAndCache() async {
//     await cookieManager.clearCookies();
//     await flutterWebViewPlugin.clearCache();
//     await flutterWebViewPlugin.cleanCookies();
//   }
// }

// Future<void> signOutCurrentUser() async {
//   try {
//     final result = await Amplify.Auth.signOut();
//     if (result is CognitoCompleteSignOut) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove('authToken');
//       await _clearWebViewCookiesAndCache();
//       safePrint('Sign out completed successfully');
//     } else if (result is CognitoFailedSignOut) {
//       safePrint('Error signing user out: ${result.exception.message}');
//     } else if (result is CognitoPartialSignOut) {
//       safePrint('Error signing user out: ${result.signedOutLocally}');
//       if (result.signedOutLocally) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove('authToken');
//         await prefs.clear();
//         await _clearWebViewCookiesAndCache();
//       }
//     }
//   } catch (e) {
//     safePrint('Error during sign out: $e');
//   }
// }

// Future<void> _clearWebViewCookiesAndCache() async {
//   final cookieManager = WebviewCookieManager();
//   await cookieManager.clearCookies();
//   final flutterWebViewPlugin = FlutterWebviewPlugin();
//   await flutterWebViewPlugin.clearCache();
//   await flutterWebViewPlugin.cleanCookies();
// }



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
    }
     else {
      final result = await Amplify.Auth.signInWithWebUI(
          provider: const AuthProvider.saml("EvokeAzureAD"));
      safePrint('Result: $result');
      onloginComplition(true);
    }
  }
}

Future<void> signOutCurrentUser() async {
  final result = await Amplify.Auth.signOut();
  if (result is CognitoCompleteSignOut) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
        prefs.clear();
    await prefs.commit();
    safePrint('Sign out completed successfully');
  } else if (result is CognitoFailedSignOut) {
    safePrint('Error signing user out: ${result.exception.message}');
  } else if (result is CognitoPartialSignOut) {
    safePrint('Error signing user out: ${result.signedOutLocally}');
    if(result.signedOutLocally){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    prefs.clear();

    }
  }
}
