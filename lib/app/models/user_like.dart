class UserLike {
  final String userName;
  final String userId;
  final String identityId;
  final String profilePicture;
  final String title;

  UserLike({
    required this.userName,
    required this.userId,
    required this.identityId,
    required this.profilePicture,
    required this.title,
  });

  // Map<String, dynamic> toJson() => {
  //       'userName': userName,
  //       'userId': userId,
  //       'identityId': identityId,
  //       "profilePicture": profilePicture
  //     };

  factory UserLike.fromJson(Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['profilePicture'] != null) {
      if (json['userId'] == currentUserId) {
        authorThumbnail = json['profilePicture'];
      } else {
        authorThumbnail = json[
            'profilePicture']; //json['identityId'] + '/' + json['profilePicture'];
      }
    }
    return UserLike(
      userName: json['userName'],
      userId: json['userId'],
      identityId: json['identityId'],
      profilePicture: authorThumbnail!,
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userName'] = userName;
    _data['userId'] = userId;
    _data['identityId'] = identityId;
    _data['profilePicture'] = profilePicture;
    _data['title'] = title;

    return _data;
  }
}
