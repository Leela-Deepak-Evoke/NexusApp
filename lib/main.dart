// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:evoke_nexus_app/nexus_app.dart';
// import 'package:evoke_nexus_app/app_router.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_strategy/url_strategy.dart';
// import 'package:webview_cookie_manager/webview_cookie_manager.dart';
// import 'amplifyconfiguration.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_api/amplify_api.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
//  import 'dart:io';



// Future<void> main() async {
//   setPathUrlStrategy();
//   WidgetsFlutterBinding.ensureInitialized();
//   bool isAmplifySuccessfullyConfigured = false;

//   // Clear auth state at the start
//   // safePrint('Clearing auth state on start');

//   try {
//     // Configure Amplify
//     await _configureAmplify();
//     isAmplifySuccessfullyConfigured = true;
//   } on AmplifyAlreadyConfiguredException {
//     safePrint('Amplify configuration failed.');
//     // Handle the case where Amplify is already configured
//     // You may choose to continue with the existing configuration or abort initialization
//     // isAmplifySuccessfullyConfigured = true;
//   }

//   // Load SSL certificates
//   // ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
//   // SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

//   // Initialize the app
//   runApp(
//     ProviderScope(
//       child: NexusApp(
//         isAmplifySuccessfullyConfigured: isAmplifySuccessfullyConfigured,
//         router: mobileappRouter,
//       ),
//     ),
//   );
// }

// Future<void> _configureAmplify() async {
//   try {
//     // Add Amplify plugins and configure
//     final authPlugin = AmplifyAuthCognito();
//     final api = AmplifyAPI();
//     final storage = AmplifyStorageS3();
//     await Amplify.addPlugins([authPlugin, api, storage]);
//     await Amplify.configure(amplifyconfig); 
//   } on Exception catch (e) {
//     // Handle configuration errors
//     safePrint('An error occurred while configuring Amplify: $e');
//     // Optionally, you can rethrow the exception to abort initialization
//     // throw e;
//   }
// }

// Future<void> _clearAuthStateOnStart() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove('authToken');
//   await prefs.clear();

//   // Ensure cookies and cache are cleared
//   try {
//     final cookieManager = WebviewCookieManager();
//     await cookieManager.clearCookies();
//     final flutterWebViewPlugin = FlutterWebviewPlugin();
//     await flutterWebViewPlugin.cleanCookies();
//     await flutterWebViewPlugin.clearCache();
//     safePrint('Webview cookies and cache cleared successfully');
//   } catch (e) {
//     // Handle errors related to clearing cookies and cache
//     safePrint('Error clearing webview cookies and cache: $e');
//     // Optionally, you can rethrow the exception to abort initialization
//     // throw e;
//   }
// }


///FIRST CODE WORKING 

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/nexus_app.dart';
import 'package:evoke_nexus_app/app_router.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
 import 'dart:io';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  bool isAmplifySuccessfullyConfigured = false;

  // Clear auth state at the start
  safePrint('Clearing auth state on start');
  //  _clearAuthStateOnStart();


  try {
    await _configureAmplify();
    isAmplifySuccessfullyConfigured = true;
  } on AmplifyAlreadyConfiguredException {
    safePrint('Amplify configuration failed.');
  }
  // WidgetsFlutterBinding.ensureInitialized();

  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(
    ProviderScope(
      child: NexusApp(
        isAmplifySuccessfullyConfigured: isAmplifySuccessfullyConfigured,
        router: mobileappRouter,
      ),
    ),
  );
}

Future<void> _configureAmplify() async {
  try {
    final authPlugin = AmplifyAuthCognito();
    final api = AmplifyAPI();
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([authPlugin, api, storage]);
    await Amplify.configure(amplifyconfig); 
  } on Exception catch (e) {
    safePrint('An error occurred while configuring Amplify: $e');
  }
}

Future<void> _clearAuthStateOnStart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken');
  await prefs.clear();
  // Ensure cookies and cache are cleared
  try {
    final cookieManager = WebviewCookieManager();
    await cookieManager.clearCookies();
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    await flutterWebViewPlugin.cleanCookies();
    await flutterWebViewPlugin.clearCache();
    safePrint('Webview cookies and cache cleared successfully');
  } catch (e) {
    safePrint('Error clearing webview cookies and cache: $e');
  }
}


  



