class PostQuestionParams {
  final String userId;
  final String questionId;
  final String name;
  final bool hasImage;
  final String? imagePath;
  final String? content;
  final String? category;
  final String? subCategory;

  PostQuestionParams(
      {required this.userId,
      required this.questionId,
      required this.name,
      required this.hasImage,
      this.imagePath,
      required this.content,
      required this.category,
      required this.subCategory});
}
