import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:evoke_nexus_app/app/models/post_likedislike_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/delete_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/like_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen.dart';
import 'package:evoke_nexus_app/app/screens/create_post_orgupdates/create_post_orgupdates_screen.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_header_card_view.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_media_view.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/edit_delete_button.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrgUpdateListMobile extends ConsumerStatefulWidget {
  final User user;
  String? searchQuery;
  bool? isFilter;
  String? selectedCategory;

   OrgUpdateListMobile({super.key, required this.user, this.searchQuery,
      this.isFilter,
      this.selectedCategory});

  @override
  _OrgUpdateListMobileViewState createState() =>
      _OrgUpdateListMobileViewState();
}

class _OrgUpdateListMobileViewState extends ConsumerState<OrgUpdateListMobile> {
  @override
  Widget build(BuildContext context) {
    final orgUpdatesAsyncValue = ref.watch(orgUpdatesProvider(widget.user));

    if (orgUpdatesAsyncValue is AsyncData) {
      final items = orgUpdatesAsyncValue.value!;
      if (items.isEmpty) {
        // Handle the case where there is no data found
        return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
      } else {
         List<OrgUpdate> filteredItems = [];
        if (widget.searchQuery != "All" && widget.selectedCategory != "All") {
          filteredItems = items.where((item) {
            return item.author?.contains(widget.searchQuery ?? '') == true ||
                item.name.contains(widget.searchQuery ?? '') == true ||
                item.authorTitle?.contains(widget.searchQuery ?? '') == true ||
                item.content?.contains(widget.searchQuery ?? '') == true ||
                item.status.contains(widget.searchQuery ?? '') == true;
          }).toList();
        } else if (widget.selectedCategory == "All" || widget.searchQuery == "All") {
          // If selectedCategory is "All", consider all items
          filteredItems = List.from(items);
        }
if (filteredItems.isEmpty) {
        return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
      } else { 

        return Container(
            alignment: AlignmentDirectional.topStart,
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Column(children: [
                Expanded(
                    child: ListView.separated(
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
                        padding: const EdgeInsets.all(8.0),
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
                               trailing: isCurrentUser && (widget.user.role != 'Group' || widget.user.role != 'Leader')
                                  ? Container(
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
                                              // padding: const EdgeInsets.only(left: 50, right: 0),

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
                                              // padding: const EdgeInsets.only(left: 50, right: 0),
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
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: contentViewWidget(item)),
                                // Padding(
                                //     padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                //     child: hasTagViewWidget(item)),

                                //const SizedBox(height: 4.0),
                                item.media
                                    ? AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: OrgUpdateMediaView(item: item),
                                      )
                                    : const SizedBox(height: 2.0),
                                const SizedBox(height: 4.0),
                                // const Divider(
                                //   thickness: 1.0,
                                //   height: 1.0,
                                // ),

                                //LikesWidget comment
                                getInfoOFViewsComments(
                                    context, ref, index, item),
                                const Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                btnSharingInfoLayout(context, index, item, ref)
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
                const SizedBox(
                  height: 100,
                )
              ]),
            ));
      }
      }
    }
    if (orgUpdatesAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    // if (orgUpdatesAsyncValue is AsyncError) {
    //   return Text('An error occurred: ${orgUpdatesAsyncValue.error}');
    // }

    if (orgUpdatesAsyncValue is AsyncError) {
      return ErrorScreen(showErrorMessage: true, onRetryPressed: retry);
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }

  void _onCommentsPressed(BuildContext context, OrgUpdate item, WidgetRef ref) {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CommentScreen(
                  headerCard: OrgUpdateHeaderCardView(item: item),
                  postId: item.orgUpdateId,
                  posttype: "OrgUpdate",
                )));
  }

  Widget hasTagViewWidget(OrgUpdate item) {
    if (item.hashTag != null) {
      return Text(item.hashTag!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget contentViewWidget(OrgUpdate item) {
    if (item.content != null) {
      return Text(item.content!, style: const TextStyle(fontSize: 14));
    } else if (item.mediaCaption != null) {
      return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(OrgUpdate item, WidgetRef ref) {
    final avatarText = getAvatarText(item.author!);
    if (item.authorThumbnail == null) {
      return CircleAvatar(radius: 20.0, child: Text(avatarText));
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
              radius: 20.0,
            );
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
      BuildContext context, int index, OrgUpdate item, WidgetRef ref) {
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
                postlabel: "OrgUpdate",
                postIdPropValue: item.orgUpdateId,
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
              _onCommentsPressed(context, item, ref);
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

// NUMBER OF VIEWS AND COMMENTS
  Widget getInfoOFViewsComments(
      BuildContext context, WidgetRef ref, int index, OrgUpdate item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () {
                showDialog(
                context: context,
                builder: (BuildContext context) {
                  var params = GetCommentsParams(
                      userId: widget.user.userId,
                      postId: item.orgUpdateId,
                      postType: "OrgUpdate");

                  return LikesWidget(
                      user: widget.user,
                      spaceName: "OrgUpdate",
                      spaceId: item.orgUpdateId,
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
                onPressed: () {},
                icon: SizedBox(
                  height: 15,
                  width: 15,
                  child: Center(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
     ref.read(refresUserProvider(""));
    ref.watch(refresOrgUpdatesProvider(""));
  }

  void retry() {
    _onRefresh();
  }

  // Edit an item
  void _editItem(OrgUpdate item) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CreatePostOrgUpdatesScreen(orgUpdateItem: item, isEditOrgUpdate: true)),
      );
    });
  }

// Delete an item
  void _deleteItem(OrgUpdate item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                try {
                  final deleteParams = Delete(
                    label: 'OrgUpdate',
                    idPropValue: item.orgUpdateId,
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
}
