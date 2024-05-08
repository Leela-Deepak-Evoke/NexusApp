class UserLike {
  final String userName;
  final String userId;
  final String identityId;
   String? profilePicture;
  final String title;

  UserLike({
    required this.userName,
    required this.userId,
    required this.identityId,
     this.profilePicture,
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
        authorThumbnail = json['profilePicture']; //json['identityId'] + '/' + json['profilePicture'];
      }
    }else{
            authorThumbnail = '';

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
    final data = <String, dynamic>{};
    data['userName'] = userName;
    data['userId'] = userId;
    data['identityId'] = identityId;
    data['profilePicture'] = profilePicture;
    data['title'] = title;

    return data;
  }
}
