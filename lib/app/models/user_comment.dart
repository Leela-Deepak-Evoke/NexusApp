class UserComment {
  final String userName;
  final String userId;
  final String identityId;
  final String profilePicture;

  UserComment({
    required this.userName,
    required this.userId,
    required this.identityId,
    required this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'userId': userId,
        'identityId': identityId,
        "profilePicture": profilePicture
      };

  factory UserComment.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['profilePicture'] != null) {
      if (json['userId'] == currentUserId) {
        authorThumbnail = json['profilePicture'];
      } else {
        authorThumbnail = json['identityId'] + '/' + json['profilePicture'];
      }
    }
    print("convert likes to json");
    print(json.toString());
    print(authorThumbnail);
    return UserComment(
        userName: json['userName'],
        userId: json['userId'],
        identityId: json['identityId'],
        profilePicture: authorThumbnail!);
  }
}
