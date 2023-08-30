class PostAnswerParams {
  final String userId;
  final String questionId;
  final String answerId;
  final String name;
  final bool hasImage;
  final String? imagePath;
  final String? content;

  PostAnswerParams(
      {required this.userId,
      required this.questionId,
      required this.answerId,
      required this.name,
      required this.hasImage,
      this.imagePath,
      required this.content});
}
