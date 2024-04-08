class User_Comment {
  final String userName;
  final String userId;
  final String identityId;
  final String profilePicture;

  User_Comment({
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

  factory User_Comment.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['profilePicture'] != null) {
      if (json['userId'] == currentUserId) {
        authorThumbnail = json['profilePicture'];
      } else {
        authorThumbnail = json['profilePicture'];
        //json['identityId'] + '/' + json['profilePicture'];
      }
    }
    print("convert likes to json");
    print(json.toString());
    print(authorThumbnail);
    return User_Comment(
        userName: json['userName'],
        userId: json['userId'],
        identityId: json['identityId'],
        profilePicture: authorThumbnail!);
  }
}

// class Comments {
//   Comments({
//     required this.users,
//   });
//   late final List<Users> users;

//   Comments.fromJson(Map<String, dynamic> json){
//     users = List.from(json['users']).map((e)=>Users.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['users'] = users.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }
class UserComment {
  UserComment({
    required this.userName,
    required this.userId,
    required this.identityId,
     this.profilePicture,
    required this.commentId,
    required this.comment,
    required this.commentedAt,
    required this.commentStatus,
    required this.authorThumbnail,
  });
  late final String userName;
  late final String userId;
  late final String identityId;
  final String? profilePicture;
  late final String commentId;
  late final String comment;
  late final String commentedAt;
  late final String commentStatus;
  late final String? authorThumbnail;

  factory UserComment.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;

    if (json['profilePicture'] != null) {
      if (json['userId'] == currentUserId) {
        authorThumbnail = json['profilePicture'];
      } else {
        authorThumbnail = json[
            'profilePicture']; //json['identityId'] + '/' + json['profilePicture'];
      }
    }

    return UserComment(
      userName: json['userName'],
      userId: json['userId'],
      identityId: json['identityId'],
      profilePicture: json['profilePicture'],
      commentId: json['commentId'],
      comment: json['comment'],
      commentedAt: json['commentedAt'],
      commentStatus: json['commentStatus'],
      authorThumbnail: authorThumbnail,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userName'] = userName;
    data['userId'] = userId;
    data['identityId'] = identityId;
    data['profilePicture'] = profilePicture;
    data['commentId'] = commentId;
    data['comment'] = comment;
    data['commentedAt'] = commentedAt;
    data['commentStatus'] = commentStatus;
    return data;
  }
}
