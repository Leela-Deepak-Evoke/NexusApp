import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/userhome.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class UserHomeService {
  Future<UserHome> fetchUserHome(User user) async {
    try {
      final userPayload = {
        "user": {"userId": user.userId}
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'userhome',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
          print(jsonResponse);
          safePrint(jsonResponse);
          final userDetails = UserDetails.fromJson(jsonResponse['user_details']);
                    final postsCount = PostsCount.fromJson(jsonResponse['posts_count']); 
          final latestQuestions = (jsonResponse['latest_questions'] as List)
              .map((questionJson) => LatestQuestion.fromJson(questionJson))
              .toList();
          final latestUpdates = (jsonResponse['latest_updates'] as List)
              .map((updateJson) => LatestUpdate.fromJson(updateJson))
              .toList();
          return UserHome(userDetails: userDetails, postsCount: postsCount, latestQuestions: latestQuestions, latestUpdates: latestUpdates);
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
