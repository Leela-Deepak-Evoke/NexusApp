import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:evoke_nexus_app/app/models/user.dart';

class ProfileService {
  Future<String?> getProfileImageUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.protected,
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

  Future<void> uploadProfileImage(String userId) async {
    try {
      safePrint('In upload');
      // Select a file from the device
      final fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: false,
        // Ensure to get file stream for better performance
        withReadStream: true,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      if (fileResult == null) {
        safePrint('No file selected');
        return;
      }
      final platformFile = fileResult.files.single;

      const options = StorageUploadFileOptions(
        accessLevel: StorageAccessLevel.protected,
      );

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          platformFile.readStream!,
          size: platformFile.size,
        ),
        key: platformFile.name,
        options: options,
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;
      safePrint('Successfully uploaded file: ${result.uploadedItem.key}');
      final userPayload = {
        "user": {"userId": userId, "new_profile_key": platformFile.name}
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'updateprofilepic',
          body: HttpPayload.json(userPayload),
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          safePrint('Successfully uploaded file to DB');
        } else {
          throw Exception('Failed to load data');
        }
      }
    } catch (e) {
      safePrint('UploadFile Err: $e');
    }
  }

  Future<User> updateUser(User user) async {
    try {
      final userPayload = {
        "user": {
          "userId": user.userId,
          "about": user.about,
          "socialLinks": user.socialLinks
        }
      };
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.post(
          'updateuser',
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
