import 'dart:io';

import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/post_likedislike_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/delete_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/like_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_header_card_view.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_media_view.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/edit_delete_button.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedListMobile extends ConsumerStatefulWidget {
  final User user;
  String? searchQuery;
  bool? isFilter;
  String? selectedCategory;
  // AsyncValue<List<Feed>>? filterfeedsList;
  List<String>? selectedCategories; // Track selected categories

  FeedListMobile(
      {super.key,
      required this.user,
      this.searchQuery,
      this.isFilter,
      this.selectedCategory,
      this.selectedCategories
      // this.filterfeedsList
      });

  @override
  _FeedListMobileViewState createState() => _FeedListMobileViewState();
}

class _FeedListMobileViewState extends ConsumerState<FeedListMobile> {
  late Future<AsyncValue<List<Feed>>> filterFeedsFuture;

  @override
  void initState() {
     super.initState();
  }

  void _onCommentsPressed(Feed item) {
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

  @override
  Widget build(BuildContext context) {
    final feedsAsyncValue = ref.watch(feedsProvider(widget.user));

    if (feedsAsyncValue is AsyncData) {
      final items = feedsAsyncValue.value!;
      if (items.isEmpty) {
        // Handle the case where there is no data found
        return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
      } else {
        // Filter the items based on the search query
        List<Feed> filteredItems = [];
        if (widget.searchQuery != "All" && widget.selectedCategories != "All") {
          filteredItems = items.where((item) {
            return item.author?.contains(widget.searchQuery ?? '') == true ||
                item.name.contains(widget.searchQuery ?? '') == true ||
                item.authorTitle?.contains(widget.searchQuery ?? '') == true ||
                item.content?.contains(widget.searchQuery ?? '') == true ||
                item.status.contains(widget.searchQuery ?? '') == true;
          }).toList();
        } else if (widget.selectedCategories == "All" ||
            widget.searchQuery == "All") {
          // If selectedCategory is "All", consider all items
          filteredItems = List.from(items);
        }

        if (filteredItems.isEmpty) {
          // Handle the case where there is no data found
          return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
        } else {
          return Container(
              // alignment: AlignmentDirectional.topStart,
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(children: [
                  Expanded(
                      child: ListView.separated(
                    // controller: _refreshController.scrollController,
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 0),
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final author = item.author;

                      final formattedDate = DateFormat('MMM d HH:mm').format(
                          DateTime.parse(item.postedAt.toString()).toLocal());
                      bool isCurrentUser = item.authorId == widget.user.userId;

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
                                minLeadingWidth: 0,
                                minVerticalPadding: 15,
                                title: Text(author!,
                                    style: const TextStyle(fontSize: 16)),
                                subtitle: Text(
                                  "${item.authorTitle!} | ${Global.calculateTimeDifferenceBetween(Global.getDateTimeFromStringForPosts(item.postedAt.toString()))}",
                                  style: TextStyle(
                                    color: const Color(0xff676A79),
                                    fontSize: 12.0,
                                    fontFamily:
                                        GoogleFonts.notoSans().fontFamily,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                trailing: isCurrentUser
                                    ? SizedBox(
                                        width: 30, // Adjust the width as needed
                                        child: PopupMenuButton<String>(
                                          //  padding: const EdgeInsets.only(left: 50, right: 0),

                                          icon: const Icon(
                                            Icons.more_vert,
                                          ),
                                          onSelected: (String choice) {
                                            // Handle button selection here
                                            if (choice == 'Edit') {
                                              _editItem(
                                                  item); // Call the edit function
                                            } else if (choice == 'Delete') {
                                              _deleteItem(
                                                  item); // Call the delete function
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                value: 'Edit',
                                                child: EditButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);

                                                    _editItem(
                                                        item); // Call the edit function
                                                  },
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'Delete',
                                                child: DeleteButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _deleteItem(
                                                        item); // Call the delete function
                                                  },
                                                ),
                                              ),
                                            ];
                                          },
                                        ),
                                      )
                                    : null,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4.0),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: contentViewWidget(item)),
                                  // Padding(
                                  //     padding: const EdgeInsets.fromLTRB(
                                  //         20, 5, 20, 10),
                                  //     child: hasTagViewWidget(item)),

                                  const SizedBox(height: 10.0),
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
                                  getInfoOFViewsComments(index, item, context),
                                  const Divider(
                                    thickness: 1.0,
                                    height: 1.0,
                                  ),
                                  btnSharingInfoLayout(
                                      context, index, item, ref),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  )),
                  if (Platform.isAndroid)
                    const SizedBox(
                      height: 60,
                    ),
                  if (Platform.isIOS)
                    const SizedBox(
                      height: 100,
                    ),
                ]),
              ));
        }
      }
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
      return ErrorScreen(showErrorMessage: true, onRetryPressed: retry);
    }
    // }
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
    if (item.authorThumbnail == null || item.authorThumbnail == "" ) {
      return CircleAvatar(radius: 20.0, child: Text(avatarText));
    } else {
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.authorThumbnail!));
      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty){
          // Check if imageUrl is proper or not
          if (_isProperImageUrl(imageUrl)) {
            return CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 20.0,
            );
          } else {
            // Render text as a fallback when imageUrl is not proper
            return CircleAvatar(
              radius: 20.0,
              child: Text(
                avatarText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            );
          }
        } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 20.0, child: Text(avatarText));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
            radius: 20.0,
            child: Text(avatarText)), // Handle error state appropriately
      );
    }
  }

    bool _isProperImageUrl(String imageUrl) {
    // Check if the image URL contains spaces in the filename
    if ( imageUrl.contains('%20')) {
      return false;
    }
    return true;
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
                userId: widget.user.userId,
                action: item.currentUserLiked ? "DISLIKE" : "LIKE",
                postlabel: "Feed",
                postIdPropValue: item.feedId,
              )));

              if (likeDislikeResult is AsyncData) {
                // Update the current item's like state
                setState(() {
                  item.currentUserLiked = !item.currentUserLiked;
                  print("Like status updated: ${item.currentUserLiked}");
                });
              }
            },
            icon: (item.currentUserLiked
                ? const Icon(Icons.thumb_up)
                : Image.asset(
                    'assets/images/thumb_up.png',
                    width: 20,
                    height: 20,
                  )),
            label: Text(
              'Like',
              style: TextStyle(
                color: const Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              _onCommentsPressed(item);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         fullscreenDialog: true,
              //         builder: (context) =>
              //           CommentScreen(
              //             headerCard:
              //                 FeedHeaderCardView(item: item, ref: ref),
              //                 postId: item.feedId,
              //                 posttype: "Feed",))
              //                 );
            },
            icon: Image.asset(
              'assets/images/chat_bubble_outline.png',
              width: 20,
              height: 20,
            ),
            label: Text(
              'Comment',
              style: TextStyle(
                color: const Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              _showToast(context);
            },
            icon: Image.asset(
              'assets/images/Vector-2.png',
              width: 20,
              height: 20,
            ),
            label: Text(
              'Report',
              style: TextStyle(
                color: const Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ]);
  }

// NUMBER OF VIEWS AND COMMENTS
  Widget getInfoOFViewsComments(int index, Feed item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () {
              if (item.likes != 0)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  var params = GetCommentsParams(
                      userId: widget.user.userId,
                      postId: item.feedId,
                      postType: "Feed");
                  return LikesWidget(
                      user: widget.user,
                      spaceName: "Feed",
                      spaceId: item.feedId,
                      params: params);
                },
              );
            },
            icon: Image.asset(
              'assets/images/reactions.png',
            ),
            label: Text(
              '${item.likes}',
              style: TextStyle(
                color: const Color(0xff676A79),
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
                icon: SizedBox(
                  height: 15,
                  width: 15,
                  child: Center(
                    child: Image.asset(
                      'assets/images/chat_bubble_outline.png',
                    ),
                  ),
                ),
                onPressed: () {
                  _onCommentsPressed(item);
                },
                label: Text('${item.comments} comments',
                    style: TextStyle(
                      color: const Color(0xff676A79),
                      fontSize: 12.0,
                      fontFamily: GoogleFonts.notoSans().fontFamily,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    ref.read(refresUserProvider(""));
    ref.watch(refresFeedsProvider(""));
  }

  void retry() {
    _onRefresh();
  }

// Edit an item
  void _editItem(Feed item) async {
    // setState(() {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       fullscreenDialog: true,
    //       builder: (context) => CreatePostFeedScreen(feedItem: item, isEditFeed: true),
    //     ),
    //   );
    // });

// setState(() {
    var result = Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            CreatePostFeedScreen(feedItem: item, isEditFeed: true),
      ),
    );
    await ref.read(feedsProvider(widget.user).future);
    await _onRefresh();
//  });
  }

// Delete an item
  void _deleteItem(Feed item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                try {
                  final deleteParams = Delete(
                    label: 'Feed',
                    idPropValue: item.feedId,
                    userId: widget.user.userId,
                  );
                  await ref.read(deleteProvider(deleteParams).future);
                  await _onRefresh();
                } catch (error) {
                  print("Error deleting item: $error");
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
          height: 70,
          child: Text('In Progress'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
