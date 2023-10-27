import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesService {
  // Future<Categories> getCategories() async {
      Future<Map<String, dynamic>> getCategories() async {

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      if (authToken != null) {
        final restOperation = Amplify.API.get(
          'getcategories',
          headers: {'Authorization': authToken},
        );
        final response = await restOperation.response;
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.decodeBody());
           print(jsonResponse);

          return jsonResponse;
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


  // final categories = Categories.fromJson(jsonResponse);
          // print(categories);