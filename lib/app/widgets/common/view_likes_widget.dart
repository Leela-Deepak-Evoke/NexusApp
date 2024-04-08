import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/user_like.dart';
import 'package:evoke_nexus_app/app/provider/like_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/profile_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LikesWidget extends ConsumerStatefulWidget {
  final User user;
  final String spaceName;
  final String spaceId;
  final GetCommentsParams params;

  const LikesWidget({
    Key? key,
    required this.user,
    required this.spaceName,
    required this.spaceId,
    required this.params,
  }) : super(key: key);

  @override
  ConsumerState<LikesWidget> createState() => _LikesWidgetViewState();
}

class _LikesWidgetViewState extends ConsumerState<LikesWidget> {
  @override
  Widget build(BuildContext context) {
    final likesAsyncValue = ref.watch(likesProvider(widget.params));
    if (likesAsyncValue is AsyncData) {
      final items = likesAsyncValue.value!;
      return _buildLikesDialog(items, context);
    }

    if (likesAsyncValue is AsyncLoading) {
      return _buildLoadingIndicator();
    }

    if (likesAsyncValue is AsyncError) {
      return _buildErrorWidget();
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingIndicator() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const Center(
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

  Widget _buildErrorWidget() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const Text('An error occurred.');
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLikesDialog(List<UserLike> items, BuildContext context) {
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
                    color: const Color(0xff676A79),
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
                      return FutureBuilder<Widget>(
                        future: _userProfilePicWidget(userLike, ref),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ListTile(
                                leading: snapshot.data,
                                minLeadingWidth: 0,
                                minVerticalPadding: 15,
                                title: Text(userLike.userName),
                                onTap: () {
                                  //     Navigator.push(
                                  // context,
                                  // MaterialPageRoute(
                                  //   builder: (context) => ProfileScreen(),
                                  // ));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MobileLayout(
                                              title: 'User Profile',
                                              user: widget.user,
                                              hasBackAction: true,
                                              hasRightAction: userLike.userId == widget.user.userId ? true : false,
                                              topBarButtonAction: () {},
                                              backButtonAction: () {
                                                Navigator.pop(context);
                                              },
                                              child: ProfileMobileView(
                                                user: widget.user,
                                                context: context,
                                                otherUser: userLike,
                                                isFromOtherUser: true,
                                                onPostClicked: () {},
                                              ),
                                            )),
                                  );
                                });
                          } else {
                            // Return a placeholder while loading
                            return ListTile(
                              leading: const CircularProgressIndicator(),
                              title: Text(userLike.userName),
                            );
                          }
                        },
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

  Future<Widget> _userProfilePicWidget(UserLike item, WidgetRef ref) async {
    final avatarText = getAvatarText(item.userName);
    if (item.profilePicture.isEmpty) {
      return CircleAvatar(radius: 15.0, child: Text(avatarText));
    } else {
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProviderViewLike(item.profilePicture));
      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            return CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 15.0,
            );
          } else {
            return CircleAvatar(radius: 15.0, child: Text(avatarText));
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => CircleAvatar(
          radius: 15.0,
          child: Text(avatarText),
        ),
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
