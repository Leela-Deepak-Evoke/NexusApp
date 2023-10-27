import 'package:evoke_nexus_app/app/models/categories.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final categoriesServiceProvider = Provider<CategoriesService>((ref) => CategoriesService());

// final categoriesProvider = FutureProvider<Categories>((ref) async {
//   final categoriesService = ref.read(categoriesServiceProvider);
//   final categories = await categoriesService.getCategories();
//   return categories; 
// });


final categoriesProviderQuestion = FutureProvider<List<String>>((ref) async {
  final categoriesService = ref.read(categoriesServiceProvider);
  final categoriesMap = await categoriesService.getCategories();
  final questionsList = List<String>.from(categoriesMap['questions']);
  return questionsList;
});


final categoriesProviderFeed = FutureProvider<List<String>>((ref) async {
  final categoriesService = ref.read(categoriesServiceProvider);
  final categoriesMap = await categoriesService.getCategories();
  final feedsList = List<String>.from(categoriesMap['feeds']);
  return feedsList;
});



final categoriesProviderorgUpdates = FutureProvider<List<String>>((ref) async {
  final categoriesService = ref.read(categoriesServiceProvider);
  final categoriesMap = await categoriesService.getCategories();
  final orgUpdatesList = List<String>.from(categoriesMap['org_updates']);
  return orgUpdatesList;
});
