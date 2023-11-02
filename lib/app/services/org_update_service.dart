import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:evoke_nexus_app/app/models/post_org_update_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class OrgUpdateService {
  Future<List<OrgUpdate>> fetchOrgUpdates(User user) async {
    try {
      final userPayload = {
        "user": {"userId": user.userId}
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'fetchorgupdates',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
          if (jsonResponse is List) {
            return jsonResponse
                .map((orgUpdateJson) =>
                    OrgUpdate.fromJson(orgUpdateJson, user.userId))
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

  Future<String?> getMediaURL(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
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

  Future<String?> uploadMedia(String rootId, String mediaType) async {
    try {
      safePrint('In upload');
      // Select a file from the device
      final fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: false,
        // Ensure to get file stream for better performance
        withReadStream: true,
        allowedExtensions:
            mediaType == 'Image' ? ['jpg', 'png', 'gif'] : ['mp4', 'wav'],
      );

      if (fileResult == null) {
        safePrint('No file selected');
        return null;
      }
      final platformFile = fileResult.files.single;
      const options = StorageUploadFileOptions(
        accessLevel: StorageAccessLevel.guest,
      );

      final String mediaPath = 'org_update/$rootId/${platformFile.name}';

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          platformFile.readStream!,
          size: platformFile.size,
        ),
        key: mediaPath,
        options: options,
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;
      safePrint('Successfully uploaded file: ${result.uploadedItem.key}');
      return mediaPath;
    } catch (e) {
      safePrint('UploadFile Err: $e');
      return null;
    }
  }

  Future<void> postOrgUpdate(PostOrgUpdateParams params) async {
    try {
      safePrint('Inside post org updates');
      final payload = {
        "user": {"userId": params.userId},
        "orgUpdate": {
          "orgUpdateId": params.orgUpdateId,
          "content": params.content,
          "category": params.category,
          "media": params.media,
          "hasImage": params.hasImage,
          "imagePath": params.imagePath,
          "hasVideo": params.hasVideo,
          "videoPath": params.videoPath,
          "mediaCaption": params.mediaCaption,
          "hashTag": params.hashTag
        }
      };
      safePrint('Payload: $payload');
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        safePrint('authToken: $authToken');
        final restOperation = Amplify.API.post(
          'postorgupdate',
          body: HttpPayload.json(payload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          return;
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

  Future<void> editOrgUpdate(PostOrgUpdateParams params) async {
    try {
      safePrint('Inside post org updates');
      final payload = {
        "user": {"userId": params.userId},
        "orgUpdate": {
          "orgUpdateId": params.orgUpdateId,
          "content": params.content,
          "category": params.category,
          "media": params.media,
          "hasImage": params.hasImage,
          "imagePath": params.imagePath,
          "hasVideo": params.hasVideo,
          "videoPath": params.videoPath,
          "mediaCaption": params.mediaCaption,
          "hashTag": params.hashTag
        }
      };
      safePrint('Payload: $payload');
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        safePrint('authToken: $authToken');
        final restOperation = Amplify.API.post(
          'editorgupdate',
          body: HttpPayload.json(payload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          return;
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
