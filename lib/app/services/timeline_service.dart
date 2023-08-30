import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TimelineService {

  Future<List<Feed>> fetchTimeline(User user) async {
    try {
      final userPayload = {
        "user": {"userId": user.userId}
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'gettimeline',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
          if (jsonResponse is List) {
            return jsonResponse
                .map((feedJson) => Feed.fromJson(feedJson, user.userId))
                .toList();
          } else {
            throw Exception('Unexpected data format');
          }
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
