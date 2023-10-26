import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/user_like.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
    Future<List<UserLike>> getLikes(GetCommentsParams params) async {

  // Future<List<UserLike>> getLikes(String spaceName, String spaceId, String userId) async {
    try {
      final userPayload = {
        "post": {"label": params.postType, "id_prop_value": params.postId},
      };

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'getlikes',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
           print(response.decodeBody());
           print(jsonResponse);
       
           if (jsonResponse["users"] is List) {
            print("likes json");
           final resultJson = jsonResponse["users"]
                .map<UserLike>(
                    (feedJson) => UserLike.fromJson(feedJson, params.userId))
                .toList();
                print(resultJson);
            return resultJson;
          }
          else {
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

  Future<String?> getAuthorThumbnail(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.guest, //.protected,
        ),
      ).result;
      //print("S3 result");
      //print(result.url);
      return result.url.toString();
    } catch (e) {
      safePrint('Error fetching S3 URL: $e');
      return null;
    }
  }

  Future<bool> postlikedislike(params) async {
    try {
      safePrint('Inside post feed');

      final payload = {
        "user": {"userId": params.userId},
        "action": params.action,
        "post": {
          "label": params.postlabel,
          "id_prop_value": params.postIdPropValue
        },
      };

      safePrint('Payload: $payload');

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        safePrint('authToken: $authToken');
        final restOperation = Amplify.API.post(
          'likedislike',
          body: HttpPayload.json(payload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
          print(jsonResponse);
          return true;
        } else {
          return false; //throw Exception('Failed to load data');
        }
      } else {
        return false; //throw Exception('Failed to load token');
      }
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      return false; //rethrow;
    } on ApiException catch (e) {
      safePrint('POST call failed: $e');
      return false; //rethrow;
    }
  }
}
