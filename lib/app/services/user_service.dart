import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/security/Aes256Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<void> saveEncryptedAuthToken(String authToken) async {
    await SecureStorage.saveEncryptedData('authToken', authToken);
  }

  Future<String?> getDecryptedAuthToken() async {
    return await SecureStorage.getDecryptedData('authToken');
  }

  Future<User> checkUser() async {
    try {
      final result =
          await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final user = await Amplify.Auth.getCurrentUser();
      final identityId = result.identityIdResult.value;

      String name = '';
      String email = '';
      String title = 'Test User';
      // bool termsAccepted = false; // Initialize the variable
      // bool termsAccepted = isChecked; // Pass the isChecked variable

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
          // "terms_accepted": termsAccepted, // Include the termsAccepted variable

          // "terms_accepted": termsAccepted,
          // "lastLoginAt": lastLoginAt
          //     ?.toIso8601String(), // Convert DateTime to ISO 8601 string
        }
      };

      final tokens = result.userPoolTokensResult.value;

      final authToken = tokens.idToken.raw;
      safePrint('---- TOKEN: ----- $result');
      // safePrint("Session Token :${result.credentialsResult.value.sessionToken}");
      // final testString = result.userPoolTokensResult.value;

      // final text = testString.username; //authToken;
      // final keys = Aes256Helper.generateRandomKeyAndIV();
      // final cipherText = Aes256Helper.encrypt(text, keys);
      // final decryptText = Aes256Helper.decrypt(cipherText, keys);

      // print('Encrypted: $cipherText\n');
      // print('Decrypted: $decryptText\n');

      // final prefs = await SharedPreferences.getInstance();
      // final authToken = prefs.getString('authToken');

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('authToken', authToken);
      // await saveEncryptedAuthToken(authToken);

      if (authToken != null) {
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

  Future<User> checkUserFlagCheck({bool isChecked = false}) async {
    // Future<User> checkUser() async {
    try {
      final result =
          await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final user = await Amplify.Auth.getCurrentUser();
      final identityId = result.identityIdResult.value;

      String name = '';
      String email = '';
      String title = 'Test User';
      bool termsAccepted = isChecked; // Pass the isChecked variable

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

          // "terms_accepted": termsAccepted,
          // "lastLoginAt": lastLoginAt
          //     ?.toIso8601String(), // Convert DateTime to ISO 8601 string
        },
        "terms_accepted": termsAccepted, // Include the termsAccepted variable
      };

      // final tokens = result.userPoolTokensResult.value;

      // final authToken = tokens.idToken.raw;
      // safePrint('---- TOKEN: ----- $result');

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      // final testString = result.userPoolTokensResult.value;

      // final text = testString.username; //authToken;
      // final keys = Aes256Helper.generateRandomKeyAndIV();
      // final cipherText = Aes256Helper.encrypt(text, keys);
      // final decryptText = Aes256Helper.decrypt(cipherText, keys);

      // print('Encrypted: $cipherText\n');
      // print('Decrypted: $decryptText\n');

      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      // await sharedPreferences.setString('authToken', authToken);
      // await saveEncryptedAuthToken(authToken);

      if (authToken != null) {
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

  Future<User> fetchUser1() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      final userPayload = {
        "user": {"userId": user.userId}
      };

      // Retrieve decrypted auth token
      final decryptedAuthToken = await getDecryptedAuthToken();
      if (decryptedAuthToken != null) {
        final restOperation = Amplify.API.post(
          'fetchuser',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': decryptedAuthToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
          return User.fromJson(jsonResponse);
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to retrieve decrypted token');
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
      final result =
          await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;

      final user = await Amplify.Auth.getCurrentUser();

      // final tokens = result.userPoolTokensResult.value;

      // final authToken = tokens.idToken.raw;
      // safePrint('---- TOKEN: ----- $result');

      final userPayload = {
        "user": {"userId": user.userId}
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      // await sharedPreferences.setString('authToken', authToken);

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
