class Forum {
  final String forumId;
  final String name;
  final bool media;
  final bool hasImage;
  final bool hasVideo;
  final String? mediaCaption;
  final String? imagePath;
  final String? videoPath;
  final String? hashTag;
  final String? content;
  final DateTime postedAt;
  final String status;
  final String? author;
  final String? authorId;
  final String? authorTitle;
  final String? authorThumbnail;
  final int likes;
  final int comments;

  Forum(
      {required this.forumId,
      required this.name,
      required this.media,
      required this.hasImage,
      required this.hasVideo,
      required this.mediaCaption,
      required this.imagePath,
      required this.videoPath,
      required this.hashTag,
      required this.content,
      required this.postedAt,
      required this.status,
      required this.author,
      required this.authorId,
      required this.authorTitle,
      required this.authorThumbnail,
      required this.likes,
      required this.comments});

  Map<String, dynamic> toJson() => {
        'forumId': forumId,
        'name': name,
        'media': media,
        "hasImage": hasImage,
        "imagePath": imagePath,
        "hasVideo": hasVideo,
        "videoPath": videoPath,
        "mediaCaption": mediaCaption,
        "hashTag": hashTag,
        'content': content,
        'postedAt': postedAt,
        'status': status,
        'author': author,
        'authorId': authorId,
        'authorTitle': authorTitle,
        'authorThumbnail': authorThumbnail,
        'likes': likes,
        'comments': comments
      };

  factory Forum.fromJson(Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['user']['profilePicture'] != null) {
      if (json['user']['userId'] == currentUserId) {
        authorThumbnail = json['user']['profilePicture'];
      } else {
        authorThumbnail = json['user']['profilePicture'];
        //json['user']['identityId'] + '/' + json['user']['profilePicture'];
      }
    }

    return Forum(
        forumId: json['forumId']['forumId'],
        media: json['forum']['media'],
        hasImage: json['forum']['hasImage'],
        imagePath: json['forum']['imagePath'],
        hasVideo: json['forum']['hasVideo'],
        videoPath: json['forum']['videoPath'],
        mediaCaption: json['forum']['mediaCaption'],
        hashTag: json['forum']['hashTag'],
        name: json['forum']['name'],
        content: json['forum']['content'],
        postedAt: DateTime.parse(json['forum']['postedAt']),
        status: json['forum']['status'],
        author: json['user']['name'],
        authorId: json['user']['userId'],
        authorTitle: json['user']['title'],
        authorThumbnail: authorThumbnail,
        likes: json['likes'] ?? 0,
        comments: json['comments'] ?? 0);
  }
}
