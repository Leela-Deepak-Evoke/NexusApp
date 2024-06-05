import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<User> checkUser() async {
    try {
      final result =
          await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final user = await Amplify.Auth.getCurrentUser();
      final identityId = result.identityIdResult.value;

      String name = '';
      String email = '';
      String title = 'Test User';
      // DateTime? lastLoginAt; //recently added by mounika

      if (result.isSignedIn) {
        final userAttributes = await Amplify.Auth.fetchUserAttributes();
        for (final element in userAttributes) {
          if (element.userAttributeKey.key == "email") {
            email = element.value;
          }
          if (element.userAttributeKey.key == "name") {
            name = element.value;
          }
          if (element.userAttributeKey.key == "custom:jobtitle") {
            title = element.value;
          }
          // if (element.userAttributeKey.key == "lastLoginAt") {  // in userAttributeKey lastLoginAt is not coming
          //   lastLoginAt = DateTime.parse(element.value);
          // }
        }
      }

      final userPayload = {
        "user": {
          "userId": user.userId,
          "identityId": identityId,
          "name": name,
          "email": email,
          "title": title,
          // "lastLoginAt": lastLoginAt
          //     ?.toIso8601String(), // Convert DateTime to ISO 8601 string
        }
      };

      final tokens = result.userPoolTokensResult.value;

      final authToken = tokens.idToken.raw;
      safePrint('---- TOKEN: ----- $result');

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('authToken', authToken);

      final restOperation = Amplify.API.post(
        'auth',
        body: HttpPayload.json(userPayload),
        headers: {'Authorization': authToken},
      );
      final response = await restOperation.response;
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.decodeBody());
        safePrint('---- checkUser response: ----- $jsonResponse');
        return User.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load data');
      }
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      rethrow;
    } on ApiException catch (e) {
      safePrint('POST call failed: $e');
      rethrow;
    }
  }

  Future<User> fetchUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      final userPayload = {
        "user": {"userId": user.userId}
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'fetchuser',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
          return User.fromJson(jsonResponse);
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load token');
      }
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      rethrow;
    } on ApiException catch (e) {
      safePrint('POST call failed: $e');
      rethrow;
    }
  }
}
