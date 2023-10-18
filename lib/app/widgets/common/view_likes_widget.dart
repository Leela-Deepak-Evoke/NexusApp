import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/user_like.dart';
import 'package:evoke_nexus_app/app/provider/like_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LikesWidget extends ConsumerStatefulWidget {
  final User user;
  final String spaceName;
  final String spaceId;
  final GetCommentsParams params;

  const LikesWidget(
      {super.key,
      required this.user,
      required this.spaceName,
      required this.spaceId,
      required this.params});

  @override
  ConsumerState<LikesWidget> createState() => _LikesWidgetViewState();
}

class _LikesWidgetViewState extends ConsumerState<LikesWidget> {
  
@override
Widget build(BuildContext context) {
  final likesAsyncValue = ref.watch(likesProvider(widget.params));
  if (likesAsyncValue is AsyncData) {
    final items = likesAsyncValue.value!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dialog(
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                 Text(
                  "Likes",
                  style: TextStyle(
                                  color: Color(0xff676A79),
                                  fontSize: 20.0,
                                  fontFamily: GoogleFonts.notoSans().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 250, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final userLike = items[index];
                      return ListTile(
                        leading: _userProfilePicWidget(userLike, ref),
                          minLeadingWidth: 0,
                              minVerticalPadding: 15,
                        title: Text(userLike.userName),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

if (likesAsyncValue is AsyncLoading) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(),
                ),
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  if (likesAsyncValue is AsyncError) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Text('');
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  return SizedBox.shrink();
}



  Widget _userProfilePicWidget(UserLike item, WidgetRef ref) {
    final avatarText = getAvatarText(item.userName);
    if (item.profilePicture.isEmpty) {
      return CircleAvatar(radius: 15.0, child: Text(avatarText));
    } else {
      // Note: We're using `watch` directly on the provider.
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.profilePicture));
      //print(profilePicAsyncValue);
      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            return CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 15.0,
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 15.0, child: Text(avatarText));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 15.0,
            width: 15.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
            radius: 15.0,
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
