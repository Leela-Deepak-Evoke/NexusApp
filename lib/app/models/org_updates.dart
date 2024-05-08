class OrgUpdate {
  final String orgUpdateId;
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
  final bool currentUserLiked;

  OrgUpdate(
      {required this.orgUpdateId,
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
        'orgUpdateId': orgUpdateId,
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

  factory OrgUpdate.fromJson(Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['user']['profilePicture'] != null) {
      if (json['user']['userId'] == currentUserId) {
        authorThumbnail = json['user']['profilePicture'];
      } else {
        authorThumbnail = json['user']['profilePicture'];
        //json['user']['identityId'] + '/' + json['user']['profilePicture'];
      }
    }else{
                 authorThumbnail = '';
    }

    //  if (json['user']['profilePicture'] != null) {
    //   if (json['user']['userId'] == currentUserId) {
    //     authorThumbnail = json['user']['profilePicture'];
    //   } else {
    //     authorThumbnail = json['orgUpdate']['imagePath'];
    //   }
    // }

    return OrgUpdate(
        orgUpdateId: json['orgUpdate']['orgUpdateId'],
        media: json['orgUpdate']['media'],
        hasImage: json['orgUpdate']['hasImage'],
        imagePath: json['orgUpdate']['imagePath'],
        hasVideo: json['orgUpdate']['hasVideo'],
        videoPath: json['orgUpdate']['videoPath'],
        mediaCaption: json['orgUpdate']['mediaCaption'],
        hashTag: json['orgUpdate']['hashTag'],
        name: json['orgUpdate']['name'],
        content: json['orgUpdate']['content'],
        postedAt: DateTime.parse(json['orgUpdate']['postedAt']),
        status: json['orgUpdate']['status'],
        author: json['user']['name'],
        authorId: json['user']['userId'],
        authorTitle: json['user']['title'],
        authorThumbnail: authorThumbnail,
        likes: json['likes'] ?? 0,
        comments: json['comments'] ?? 0,
        currentUserLiked: json['currentUserLiked'] ?? false);
  }
}
