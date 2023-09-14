import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_media_view.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_media_view.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_comments.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';


class FeedListMobile extends ConsumerWidget {
  final User user;
  const FeedListMobile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final feedsAsyncValue = ref.watch(feedsProvider(user));
    if (feedsAsyncValue is AsyncData) {
      final items = feedsAsyncValue.value!;

      return Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        child: Column(
          children: 
          [ 
            Expanded(
              child:
               ListView.separated(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                print(item.feedId);
                final author = item.author;
                final formattedDate = DateFormat('MMM d HH:mm')
                    .format(DateTime.parse(item.postedAt.toString()).toLocal());
            
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          author!, //posts[index].postedBy ?? "",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          "${items[index].authorTitle}",
                          style: TextStyle(
                            color: Color(0xff676A79),
                            fontSize: 12.0,
                            fontFamily: GoogleFonts.notoSans().fontFamily,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        leading: _profilePicWidget(item, ref),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 0),
                          child: Column(
                            children: [
                             contentViewWidget(item),
                             hasTagViewWidget(item),
                            ]
                          )
                          ),
                          //const SizedBox(height: 4.0),
                          item.media
                              ? AspectRatio(
                                  aspectRatio: 16 / 9,
                                  //  child: OrgUpdateMediaView(item: item),
                                   child: FeedMediaView(item: item),
                                  // child: Container(color: Colors.amber,)
                                  // FeedMediaView(item: item),
                                )
                              : const SizedBox(height: 2.0),
                          const SizedBox(height: 4.0),
            
                          //LikesWidget comment
                          getInfoOFViewsComments(index, item),
                          const Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          btnSharingInfoLayout(index),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                      ),
            ),
        ]),
      );
    }

    if (feedsAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (feedsAsyncValue is AsyncError) {
      return Text('An error occurred: ${feedsAsyncValue.error}');
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
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
              Text(
                '0 comments',
                style: TextStyle(
                  color: Color(0xff676A79),
                  fontSize: 12.0,
                  fontFamily: GoogleFonts.notoSans().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // BUTTONS: REACT, COMMENT, SHARE
  Widget btnSharingInfoLayout(int index) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/thumb_up.png',
              width: 20,
              height: 20,
            ),
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
            onPressed: () {},
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
}
