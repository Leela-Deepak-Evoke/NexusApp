import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/user_comment.dart';
import 'package:evoke_nexus_app/app/provider/comment_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsWidget extends ConsumerWidget {
  final String spaceName;
  final String spaceId;
  final String userId;

  const CommentsWidget(
      {super.key,
      required this.spaceName,
      required this.spaceId,
      required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(" Inside Like widget");
    Map<String, dynamic> params = {
      'spaceName': spaceName,
      'spaceId': spaceId,
      'userId': userId
    };
    // Watch the provider
    AsyncValue<List<UserComment>> likes = ref.watch(commentsProvider(GetCommentsParams(userId: userId, postId: spaceId, postType: spaceName)));
    print("Async value state: ${likes.runtimeType}");

    return likes.when(
      data: (userLikes) {
        print("Data received: $userLikes");
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                const Text(
                  "Likes",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 250, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: userLikes.length,
                    itemBuilder: (context, index) {
                      final userLike = userLikes[index];
                      return ListTile(
                          leading: _userProfilePicWidget(userLike, ref),
                          title: Text(userLike.userName));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        print("Data is loading");
        return const AlertDialog(
          content: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (e, s) {
        print("Error occurred: $e");
        return AlertDialog(
          content: Text('An error occurred: $e'),
        );
      },
    );
  }

  Widget _userProfilePicWidget(UserComment item, WidgetRef ref) {
    final avatarText = getAvatarText(item.userName);
    if (item.profilePicture!.isEmpty) {
      return CircleAvatar(radius: 25.0, child: Text(avatarText));
    } else {
      // Note: We're using `watch` directly on the provider.
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.profilePicture!));
      //print(profilePicAsyncValue);
      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            return CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 25.0,
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 30.0, child: Text(avatarText));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
            radius: 25.0,
            child: Text(avatarText)), // Handle error state appropriately
      );
    }
  }

  String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }
}
