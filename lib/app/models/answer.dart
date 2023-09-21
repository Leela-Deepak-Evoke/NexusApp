class Answer {
  final String answerId;
  final String name;

  final bool hasImage;
  final String? imagePath;
  final String? content;
  final DateTime postedAt;
  final String status;
  final String? author;
  final String? authorId;
  final String? authorTitle;
  final String? authorThumbnail;
  final int likes;
  final int comments;
    final bool currentUserLiked;


  Answer(
      {required this.answerId,
      required this.name,
      required this.hasImage,
      required this.imagePath,
      required this.content,
      required this.postedAt,
      required this.status,
      required this.author,
      required this.authorId,
      required this.authorTitle,
      required this.authorThumbnail,
      required this.likes,
      required this.comments, required this.currentUserLiked});

  Map<String, dynamic> toJson() => {
        'answerId': answerId,
        'name': name,
        "hasImage": hasImage,
        "imagePath": imagePath,
        'content': content,
        'postedAt': postedAt,
        'status': status,
        'author': author,
        'authorId': authorId,
        'authorTitle': authorTitle,
        'authorThumbnail': authorThumbnail,
        'likes': likes,
        'comments': comments,
        'currentUserLiked': currentUserLiked
      };

  factory Answer.fromJson(Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['user']['profilePicture'] != null) {
      if (json['user']['userId'] == currentUserId) {
        authorThumbnail = json['user']['profilePicture'];
      } else {
        authorThumbnail =
            json['user']['identityId'] + '/' + json['user']['profilePicture'];
      }
    }

    return Answer(
        answerId: json['answer']['answerId'],
        hasImage: json['answer']['hasImage'],
        imagePath: json['answer']['imagePath'],
        name: json['answer']['name'],
        content: json['answer']['content'],
        postedAt: DateTime.parse(json['answer']['postedAt']),
        status: json['answer']['status'],
        author: json['user']['name'],
        authorId: json['user']['userId'],
        authorTitle: json['user']['title'],
        authorThumbnail: authorThumbnail,
        likes: json['likes'] ?? 0,
        comments: json['comments'] ?? 0,
        currentUserLiked: json['currentUserLiked'] ?? false
        );
  }
}
