class Feed {
  final String feedId;
  final String name;
  final bool media;
  final bool hasImage;
  final bool hasVideo;
  final String? mediaCaption;
  final String? imagePath;
  final String? videoPath;
  String? hashTag;
  String? content;
  final DateTime postedAt;
  final String status;
  final String? author;
  final String? authorId;
  final String? authorTitle;
  final String? authorThumbnail;
  final int likes;
  final int comments;
  late final bool currentUserLiked;

  Feed(
      {required this.feedId,
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
      required this.comments,
      required this.currentUserLiked});

  Map<String, dynamic> toJson() => {
        'feedId': feedId,
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
        'comments': comments,
        'currentUserLiked': currentUserLiked
      };

  factory Feed.fromJson(Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['user']['profilePicture'] != null) {
      if (json['user']['userId'] == currentUserId) {
        authorThumbnail = json['user']['profilePicture'];
      } else {
        authorThumbnail = json['user']['profilePicture'];
        // json['user']['identityId'] + '/' + json['user']['profilePicture'];
      }
    }else{
        // authorThumbnail = 'assets/images/avthar.png';
                authorThumbnail = '';

    }

    return Feed(
      feedId: json['feed']['feedId'],
      media: json['feed']['media'],
      hasImage: json['feed']['hasImage'],
      imagePath: json['feed']['imagePath'],
      hasVideo: json['feed']['hasVideo'],
      videoPath: json['feed']['videoPath'],
      mediaCaption: json['feed']['mediaCaption'],
      hashTag: json['feed']['hashTag'],
      name: json['feed']['name'],
      content: json['feed']['content'],
      postedAt: DateTime.parse(json['feed']['postedAt']),
      status: json['feed']['status'],
      author: json['user']['name'],
      authorId: json['user']['userId'],
      authorTitle: json['user']['title'],
      authorThumbnail: authorThumbnail,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      currentUserLiked: json['currentUserLiked'] ?? false,
    );
  }
}
