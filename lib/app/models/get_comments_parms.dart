class GetCommentsParams {
  final String userId;
  final String postId;
  final String postType;


  GetCommentsParams(
      {required this.userId,
      required this.postId,
      required this.postType,
  });
}
