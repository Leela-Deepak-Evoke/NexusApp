class PostForumParams {
  final String userId;
  final String forumId;
  final bool media;
  final String category;
  final bool hasImage;
  final bool hasVideo;
  final String? content;
  final String? mediaCaption;
  final String? imagePath;
  final String? videoPath;
  final String? hashTag;

  PostForumParams(
      {required this.userId,
      required this.forumId,
      required this.media,
      required this.category,
      required this.hasImage,
      required this.hasVideo,
      this.content,
      this.mediaCaption,
      this.imagePath,
      this.videoPath,
      this.hashTag});
}
