import 'package:evoke_nexus_app/app/models/categories.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesServiceProvider = Provider<CategoriesService>((ref) => CategoriesService());

final categoriesProvider =
    FutureProvider.autoDispose.family<void, Categories>((ref, user) async {
  final categoriesService = ref.read(categoriesServiceProvider);
  final categories = await categoriesService.getCategories();
  return categories;
});

