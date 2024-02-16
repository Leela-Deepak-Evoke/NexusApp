import 'dart:typed_data';

import 'package:evoke_nexus_app/app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/nexus_app.dart';
import 'package:evoke_nexus_app/app_router.dart';
import 'package:url_strategy/url_strategy.dart';
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
  try {
    await _configureAmplify();
    isAmplifySuccessfullyConfigured = true;
  } on AmplifyAlreadyConfiguredException {
    safePrint('Amplify configuration failed.');
  }
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
