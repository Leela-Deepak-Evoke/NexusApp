import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/user_comment.dart';
import 'package:evoke_nexus_app/app/provider/comment_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/delete_service_provider.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/edit_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsListMobileView extends ConsumerStatefulWidget {
  final User user;
  final String posttype;
  final String postId;
  final GetCommentsParams params;
  final Function(String, bool, UserComment)? onCommentEdited;

  const CommentsListMobileView(
      {super.key,
      required this.user,
      required this.posttype,
      required this.postId,
      required this.params,
      this.onCommentEdited});

  @override
  ConsumerState<CommentsListMobileView> createState() =>
      _CommentsListMobileViewState();
}

class _CommentsListMobileViewState
    extends ConsumerState<CommentsListMobileView> {
final List<Color> cardColors = [
                      const Color(0xffE6E3FB),
                      const Color(0xffBFE9EF),
                      const Color(0xffF6E2E1),
                      const Color(0xffE8CDEE),
                      const Color(0xffF7E1C1),
                      // Add more colors as needed
                    ]; 

                     // Map to store color associations for identity IDs
  late Map<String, Color> identityIdColorMap = {};

   @override
  void initState() {
    super.initState();
    // Initialize the identityId-color map
    identityIdColorMap = {};
  }
  
   // Generate a color for the given index
  Color getColorForIndex(int index) {
    return cardColors[index % cardColors.length];
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

  Widget _profilePicWidget(UserComment item, WidgetRef ref) {
    final avatarText = getAvatarText(item.userName);
    if (item.authorThumbnail == null) {
      return CircleAvatar(radius: 12.0, child: Text(avatarText));
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
              radius: 12.0,
              child: Text(
                avatarText,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 12.0, child: Text(avatarText));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 30.0,
            width: 30.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
            radius: 30.0,
            child: Text(avatarText)), // Handle error state appropriately
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsyncValue = ref.watch(commentsProvider(widget.params));

    if (commentsAsyncValue is AsyncData) {
      final items = commentsAsyncValue.value!;
      final Size size = MediaQuery.of(context).size;

          // Index counter to keep track of usernames encountered
    int indexCounter = 0;


      return SliverList.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            bool isCurrentUser = item.userId == widget.user.userId;
            // bool isUsersIDs = item.identityId == widget.user.userId;


  // Retrieve color for the current identityId
        Color identityIdColor;
        if (identityIdColorMap.containsKey(item.identityId)) {
          // Use the color associated with the identityId if it exists
          identityIdColor = identityIdColorMap[item.identityId]!;
        } else {
          // Generate a new color for the identityId if it doesn't exist
          identityIdColor = getColorForIndex(indexCounter);
          // Store the generated color for the identityId
          identityIdColorMap[item.identityId] = identityIdColor;
          // Increment index counter for the next identityId
          indexCounter++;
        }

        // Retrieve color for the current username
        Color usernameColor = getColorForIndex(indexCounter);
  // Increment index counter for the next username
        indexCounter++;

            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: CommentTreeWidget<Comment, Comment>(
                  Comment(
                      avatar: item.authorThumbnail,
                      userName: item.userName,
                      content: item.comment),
                  const [],
                  treeThemeData: const TreeThemeData(
                      lineColor: Colors.transparent, lineWidth: 0),
                  avatarRoot: (context, data) => PreferredSize(
                    preferredSize: const Size.fromRadius(18),
                    child: _profilePicWidget(item, ref),
                  ),

                  //Child tree list
                  avatarChild: (context, data) => PreferredSize(
                    preferredSize: const Size.fromRadius(12),
                    child: _profilePicWidget(item, ref),
                  ),

                  contentChild: (context, data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.userName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${data.content}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  contentRoot: (context, data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color: identityIdColor, // Use color based on username, //Colors.grey[100]
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                    // Wrap the Text widget with Align to eliminate top and bottom space
                                    child: Text(
                                  '${data.userName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                )),
                                const Spacer(), // Add a Spacer to push the PopupMenuButton to the right edge
                                if (isCurrentUser)
                                  SizedBox(
                                    width: 30, // Adjust the width as needed
                                    child: PopupMenuButton<String>(
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
                                  ),
                              ]),
                              Text(
                                Global.calculateTimeDifferenceBetween(Global.getDateTimeFromStringForPosts(item.commentedAt.toString())),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 9,
                                        color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${data.content}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          });
    }
    if (commentsAsyncValue is AsyncLoading) {
      return SliverList.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return const Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }

    if (commentsAsyncValue is AsyncError) {
      return SliverList.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return const Text('');
        },
      );
    }

    // This should ideally never be reached, but it's here as a fallback.
    return SliverList.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(color: Colors.amber);
      },
    );
  }

  void _editItem(UserComment item) {
    final TextEditingController editController = TextEditingController();
    editController.text = item.comment;
    widget.onCommentEdited!(editController.text, true, item);

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text("Edit Comment"),
    //       content: TextField(
    //         controller: editController,
    //         maxLines: null,
    //         decoration: const InputDecoration(
    //           labelText: "Edit your comment...",
    //           border: OutlineInputBorder(),
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           child: Text("Cancel"),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //         TextButton(
    //           child: Text("Save"),
    //           onPressed: () async {
    //             final updatedComment = editController.text;
    //             if (updatedComment.isNotEmpty) {
    //               // Call the callback function to pass the edited comment content
    //               widget.onCommentEdited!(updatedComment);

    //               Navigator.of(context).pop();
    //             }
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

// Delete an item
  void _deleteItem(UserComment item) async {
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
                    label: 'Comment',
                    idPropValue: item.commentId,
                    userId: widget.user.userId,
                  );
                  await ref.read(deleteProvider(deleteParams).future);
                  // await _onRefresh();
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
