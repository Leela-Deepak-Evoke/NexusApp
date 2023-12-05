class User {
  final String userId;
  final String identityId;
  final String name;
  final String email;
  final String title;
  final String role;
  final DateTime createdAt;
  final String status;
  final String? about;
  final String? profilePicture;
  final String? socialLinks;
  
  final DateTime? currentLoginAt;
  final DateTime? lastLoginAt;

  User(
      {required this.userId,
      required this.identityId,
      required this.name,
      required this.email,
      required this.title,
      required this.createdAt,
      required this.role,
      required this.status,
      this.about,
      this.profilePicture,
      this.socialLinks,
       this.currentLoginAt,
        this.lastLoginAt,
      });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'identityId': identityId,
        'name': name,
        'email': email,
        'title': title,
        'createdAt': createdAt,
        'role': role,
        'status': status,
        'about': about,
        'profilePicture': profilePicture,
        'socialLinks': socialLinks,
         'currentLoginAt': currentLoginAt,
          'lastLoginAt': lastLoginAt
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        identityId: json['identityId'],
        name: json['name'],
        email: json['email'],
        title: json['title'],
        createdAt: DateTime.parse(json['createdAt']),
        role: json['role'],
        status: json['status'],
        about: json['about'],
        profilePicture: json['profilePicture'],
        socialLinks: json['socialLinks'],
        currentLoginAt: DateTime.parse(json['currentLoginAt']),
        lastLoginAt: DateTime.parse(json['lastLoginAt'])
        );
  }
}
