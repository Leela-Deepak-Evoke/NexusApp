import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/post_comment_params.dart';
import 'package:evoke_nexus_app/app/models/user_comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentService {
  Future<List<UserComment>> getComments(
      String spaceName, String spaceId, String userId) async {
    try {
      final userPayload = {
        "post": {"label": spaceName, "id_prop_value": spaceId}
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'getcomments',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
          print(jsonResponse);
          if (jsonResponse["users"] is List) {
            print("likes json");
            return jsonResponse["users"]
                .map<UserComment>(
                    (feedJson) => UserComment.fromJson(feedJson, userId))
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

  Future<String?> getAuthorThumbnail(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.guest, //protected,
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

  Future<bool> postComment(PostCommentsParams params) async {
    try {
      safePrint('Inside post feed');

      final payload = {
        "user": {"userId": params.userId},
        "comment": {"commentId": params.commentId, "content": params.content},
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
          'comment',
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



  Future<bool> editComment(PostCommentsParams params) async {
    try {
      final payload = {
        "comment": {"commentId": params.commentId, "content": params.content},
      };

      safePrint('Payload: $payload');

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        safePrint('authToken: $authToken');
        final restOperation = Amplify.API.post(
          'editcomment',
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
