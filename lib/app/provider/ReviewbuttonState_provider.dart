import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonStateProvider = StateProvider<Map<int, bool>>((ref) => {});
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');