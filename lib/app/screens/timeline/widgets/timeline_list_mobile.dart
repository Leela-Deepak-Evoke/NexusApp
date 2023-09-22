import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/models/post_likedislike_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/like_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/timeline_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_header_card_view.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_media_view.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TimelineListMobile extends ConsumerWidget {
  final User user;
  const TimelineListMobile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final timelineAsyncValue = ref.watch(timelineProvider(user));
    if (timelineAsyncValue is AsyncData) {
      final items = timelineAsyncValue.value!;

      return Container(
          alignment: AlignmentDirectional.topStart,
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
          child: Column(children: [
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  final author = item.author;
                  final formattedDate = DateFormat('MMM d HH:mm').format(
                      DateTime.parse(item.postedAt.toString()).toLocal());

                  return Card(
                    margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: _profilePicWidget(item, ref),
                            title: Text(author!,
                                style: const TextStyle(fontSize: 16)),
                            subtitle: Text(
                              "${item.authorTitle!} | ${Global.calculateTimeDifferenceBetween(Global.getDateTimeFromStringForPosts(item.postedAt.toString()))}",
                              style: TextStyle(
                                color: Color(0xff676A79),
                                fontSize: 12.0,
                                fontFamily: GoogleFonts.notoSans().fontFamily,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4.0),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: contentViewWidget(item)),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: hasTagViewWidget(item)),

                              //const SizedBox(height: 4.0),
                              item.media
                                  ? AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: FeedMediaView(item: item),
                                    )
                                  : const SizedBox(height: 2.0),
                              const SizedBox(height: 4.0),
                              // const Divider(
                              //   thickness: 1.0,
                              //   height: 1.0,
                              // ),

                              //LikesWidget comment
                              getInfoOFViewsComments(index, item),
                              const Divider(
                                thickness: 1.0,
                                height: 1.0,
                              ),
                              btnSharingInfoLayout(context, index, item, ref),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ]));
    }

    if (timelineAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (timelineAsyncValue is AsyncError) {
      return Text('An error occurred: ${timelineAsyncValue.error}');
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }

  Widget hasTagViewWidget(Feed item) {
    if (item.hashTag != null) {
      return Text(item.hashTag!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget contentViewWidget(Feed item) {
    if (item.content != null) {
      return Text(item.content!, style: const TextStyle(fontSize: 14));
    } else if (item.mediaCaption != null) {
      return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(Feed item, WidgetRef ref) {
    final avatarText = getAvatarText(item.author!);
    if (item.authorThumbnail == null) {
      return CircleAvatar(radius: 26.0, child: Text(avatarText));
    } else {
      // Note: We're using `watch` directly on the provider.
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.authorThumbnail!));
      //print(profilePicAsyncValue);
      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            return CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 26.0,
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 26.0, child: Text(avatarText));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 26.0,
            width: 26.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
            radius: 26.0,
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

// BUTTONS: REACT, COMMENT, SHARE
  Widget btnSharingInfoLayout(
      BuildContext context, int index, Feed item, WidgetRef ref) {
    

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () async {
              print("Click on Like");
              // Perform the like/dislike action
              final likeDislikeResult =
                  ref.read(genricPostlikeDislikeProvider(PostLikeDislikeParams(
                userId: user.userId,
                action: item.currentUserLiked ? "DISLIKE" : "LIKE",
                postlabel: "Feed",
                postIdPropValue: item.feedId,
              )));
            },
            icon: (item.currentUserLiked
                ? Icon(Icons.thumb_up)
                : Image.asset(
                    'assets/images/thumb_up.png',
                    width: 20,
                    height: 20,
                  )),
            label: Text(
              'Like',
              style: TextStyle(
                color: Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              //  Navigator.push(
              // context,
              // MaterialPageRoute(fullscreenDialog: true,
              //     builder: (context) =>const CommentScreen()));
              _onCommentsPressed(context, ref, item);
            },
            icon: Image.asset(
              'assets/images/chat_bubble_outline.png',
              width: 20,
              height: 20,
            ),
            label: Text(
              'Comment',
              style: TextStyle(
                color: Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ]);
  }


void _onCommentsPressed(BuildContext context,WidgetRef ref, Feed item ) {
      Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CommentScreen(
                    headerCard: FeedHeaderCardView(item: item, ref: ref),
                    postId: item.feedId,
                    posttype: "Feed",
                  )));
    }
// NUMBER OF VIEWS AND COMMENTS
  Widget getInfoOFViewsComments(int index, Feed item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () {},
            icon: Image.asset(
              'assets/images/reactions.png',
            ),
            label: Text(
              '${item.likes}',
              style: TextStyle(
                color: Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton.icon(
            // <-- TextButton
            onPressed: () {
             _onCommentsPressed(context, ref, item);
            },
            icon: 
            SizedBox(
              height: 15,
              width: 15,
              child: 
              Center(
                child: Image.asset(
                  'assets/images/chat_bubble_outline.png',
                ),
              ),
            ),
            label: Text(
              '${item.comments} comments',
              style: TextStyle(
                color: Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
