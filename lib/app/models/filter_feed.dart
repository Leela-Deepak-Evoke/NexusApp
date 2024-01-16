class FilterFeedsParams {
  final String userId;
  final List<String>? categories;
  final String? sortType;

  FilterFeedsParams({
    required this.userId,
     this.categories,
     this.sortType,
  });
}