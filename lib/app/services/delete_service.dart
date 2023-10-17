import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteService {
  Future<void> postDelete(Delete params) async {
    try {
      safePrint('Inside post delete');
      final payload = {
        "user": {"userId": params.userId},
        "label": params.label,
        "id_prop_value": params.idPropValue,
      };
      safePrint('Payload: $payload');
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        safePrint('authToken: $authToken');
        final restOperation = Amplify.API.post(
          'delete',
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
