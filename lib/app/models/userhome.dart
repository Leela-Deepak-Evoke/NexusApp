// import 'package:evoke_nexus_app/app/models/user.dart';
// import 'package:evoke_nexus_app/app/models/org_updates.dart';

class UserHome {
  late UserDetails userDetails;
  late List<LatestQuestion> latestQuestions;
  late List<LatestUpdate> latestUpdates;

  UserHome({
    required this.userDetails,
    required this.latestQuestions,
    required this.latestUpdates,
  });

  UserHome.fromJson(Map<String, dynamic> json) {
    userDetails = UserDetails.fromJson(json['user_details']);
    latestQuestions = List<LatestQuestion>.from(json['latest_questions'].map((x) => LatestQuestion.fromJson(x)));
    latestUpdates = List<LatestUpdate>.from(json['latest_updates'].map((x) => LatestUpdate.fromJson(x)));
  }
}



class UserList {
  late String userId;
  late String? identityId; // Nullable
  late String profilePicture;
  late String name;
  late String? title; // Nullable

  UserList({
    required this.userId,
    this.identityId,
    required this.profilePicture,
    required this.name,
    this.title,
  });

  UserList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    identityId = json['identityId'];
    profilePicture = json['profilePicture'];
    name = json['name'];
    title = json['title'];
  }
}

class UserDetails {
  late String userId;
  late String name;
  late String profilePicture;
  late String lastLoginAt;
  late String createdAt;
  late String status;

  UserDetails({
    required this.userId,
    required this.name,
    required this.profilePicture,
    required this.lastLoginAt,
    required this.createdAt,
    required this.status,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    profilePicture = json['profilePicture'];
    lastLoginAt = json['lastLoginAt'];
    createdAt = json['createdAt'];
    status = json['status'];
  }
}

class LatestQuestion {
  late UserList user;
  late QuestionHome question;
  late int answers;

  LatestQuestion({
    required this.user,
    required this.question,
    required this.answers,
  });

  LatestQuestion.fromJson(Map<String, dynamic> json) {
    user = UserList.fromJson(json['user']);
    question = QuestionHome.fromJson(json['question']);
    answers = json['answers'];
  }
}


class QuestionHome {
  late bool hasVideo;
  late String questionId;
  late String postedAt;
  late bool hasDocument;
  late String name;
  late bool hasImage;
  late bool media;
  late String category;
  late String content;
  late String? updatedAt; // Nullable
  late String status;

  QuestionHome({
    required this.hasVideo,
    required this.questionId,
    required this.postedAt,
    required this.hasDocument,
    required this.name,
    required this.hasImage,
    required this.media,
    required this.category,
    required this.content,
    this.updatedAt,
    required this.status,
  });

  QuestionHome.fromJson(Map<String, dynamic> json) {
    hasVideo = json['hasVideo'];
    questionId = json['questionId'];
    postedAt = json['postedAt'];
    hasDocument = json['hasDocument'];
    name = json['name'];
    hasImage = json['hasImage'];
    media = json['media'];
    category = json['category'];
    content = json['content'];
    updatedAt = json['updatedAt'];
    status = json['status'];
  }
}

class LatestUpdate {
  late UserList user;
  late OrgUpdateHome orgUpdate;
  late int likes;
  late int comments;
  late bool currentUserLiked;

  LatestUpdate({
    required this.user,
    required this.orgUpdate,
    required this.likes,
    required this.comments,
    required this.currentUserLiked,
  });

  LatestUpdate.fromJson(Map<String, dynamic> json) {
    user = UserList.fromJson(json['user']);
    // orgUpdate = OrgUpdate.fromJson(json['orgUpdate'], user.userId);
        orgUpdate = OrgUpdateHome.fromJson(json['orgUpdate']);

    likes = json['likes'];
    comments = json['comments'];
    currentUserLiked = json['currentUserLiked'];
  }
}

class OrgUpdateHome {
  late bool hasVideo;
  late bool hasDocument;
  late String postedAt;
  late String imagePath;
  late String name;
  late bool hasImage;
  late bool media;
  late String orgUpdateId;
  late String content;
  late String status;

  OrgUpdateHome({
    required this.hasVideo,
    required this.hasDocument,
    required this.postedAt,
    required this.imagePath,
    required this.name,
    required this.hasImage,
    required this.media,
    required this.orgUpdateId,
    required this.content,
    required this.status,
  });

  OrgUpdateHome.fromJson(Map<String, dynamic> json) {
    hasVideo = json['hasVideo'];
    hasDocument = json['hasDocument'];
    postedAt = json['postedAt'];
    imagePath = json['imagePath'];
    name = json['name'];
    hasImage = json['hasImage'];
    media = json['media'];
    orgUpdateId = json['orgUpdateId'];
    content = json['content'];
    status = json['status'];
  }
}









































// import 'package:evoke_nexus_app/app/models/user.dart';
// import 'package:evoke_nexus_app/app/models/question.dart';
// import 'package:evoke_nexus_app/app/models/org_updates.dart';

// class UserHome {
//   late UserDetails userDetails;
//   late List<LatestQuestion> latestQuestions;
//   late List<LatestUpdate> latestUpdates;

//   UserHome({
//     required this.userDetails,
//     required this.latestQuestions,
//     required this.latestUpdates,
//   });

//   UserHome.fromJson(Map<String, dynamic> json) {
//     userDetails = UserDetails.fromJson(json['user_details']);
//     latestQuestions = List<LatestQuestion>.from(
//         json['latest_questions'].map((x) => LatestQuestion.fromJson(x)));
//     latestUpdates = List<LatestUpdate>.from(
//         json['latest_updates'].map((x) => LatestUpdate.fromJson(x)));
//   }
// }

// class UserDetails {
//   late String userId;
//   late String name;
//   late String profilePicture;
//   late String lastLoginAt;
//   late String createdAt;
//   late String status;

//   UserDetails({
//     required this.userId,
//     required this.name,
//     required this.profilePicture,
//     required this.lastLoginAt,
//     required this.createdAt,
//     required this.status,
//   });

//   UserDetails.fromJson(Map<String, dynamic> json) {
//     userId = json['userId'];
//     name = json['name'];
//     profilePicture = json['profilePicture'];
//     lastLoginAt = json['lastLoginAt'];
//     createdAt = json['createdAt'];
//     status = json['status'];
//   }
// }

// class LatestQuestion {
//   late User user;
//   late Question question;
//   late int answers;

//   LatestQuestion({
//     required this.user,
//     required this.question,
//     required this.answers,
//   });

//   LatestQuestion.fromJson(Map<String, dynamic> json) {
//     user = User.fromJson(json['user']);
//     question = Question.fromJson(json['question'], user.userId);
//     answers = json['answers'];
//   }
// }


// class LatestUpdate {
//   late User user;
//   late OrgUpdate orgUpdate;
//   late int likes;
//   late int comments;
//   late bool currentUserLiked;

//   LatestUpdate({
//     required this.user,
//     required this.orgUpdate,
//     required this.likes,
//     required this.comments,
//     required this.currentUserLiked,
//   });

//   LatestUpdate.fromJson(Map<String, dynamic> json) {
//     user = User.fromJson(json['user']);
//     orgUpdate = OrgUpdate.fromJson(json['orgUpdate'], user.userId);
//     likes = json['likes'];
//     comments = json['comments'];
//     currentUserLiked = json['currentUserLiked'];
//   }
// }





