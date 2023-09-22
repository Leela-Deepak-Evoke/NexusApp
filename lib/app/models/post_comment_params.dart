class PostCommentsParams {
  final String userId;
  final String commentId;
  final String content;
  final String postlabel;
  final String postIdPropValue;


  PostCommentsParams(
      {required this.userId,
      required this.content,
      required this.commentId,
       required this.postIdPropValue,
      required this.postlabel,
  });
}

