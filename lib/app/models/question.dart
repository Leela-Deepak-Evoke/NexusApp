class Question {
  final String questionId;
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
  final String? category;
  final String? subCategory;
  final int answers;

  Question(
      {required this.questionId,
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
      required this.category,
      required this.subCategory,
      required this.answers});

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
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
        'category': category,
        'subCategory': subCategory,
        'answers': answers,
      };

  factory Question.fromJson(Map<String, dynamic> json, String currentUserId) {
    String? authorThumbnail;
    if (json['user']['profilePicture'] != null) {
      if (json['user']['userId'] == currentUserId) {
        authorThumbnail = json['user']['profilePicture'];
      } else {
        authorThumbnail = json['user']['profilePicture'];
        //json['user']['identityId'] + '/' + json['user']['profilePicture'];
      }
    }else{
        authorThumbnail = 'assets/images/avthar.png';
    }

    return Question(
        questionId: json['question']['questionId'],
        hasImage: json['question']['hasImage'],
        imagePath: json['question']['imagePath'],
        name: json['question']['name'],
        content: json['question']['content'],
        postedAt: DateTime.parse(json['question']['postedAt']),
        status: json['question']['status'],
        author: json['user']['name'],
        authorId: json['user']['userId'],
        authorTitle: json['user']['title'],
        authorThumbnail: authorThumbnail,
        category: json['question']['category'],
        subCategory: json['question']['subCategory'],
        answers: json['answers'] ?? 0);
  }
}
