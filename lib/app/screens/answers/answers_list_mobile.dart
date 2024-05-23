import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/models/fetch_answer_params.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/post_likedislike_params.dart';
import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/comment_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/delete_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/like_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/answers/answer_header_card_view.dart';
import 'package:evoke_nexus_app/app/screens/comments/comments_screen.dart';
import 'package:evoke_nexus_app/app/screens/comments/widgets/comments_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/create_post_answers/create_post_answer_screen.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_header_card_view.dart';
import 'package:evoke_nexus_app/app/widgets/common/edit_delete_button.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evoke_nexus_app/app/models/answer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerListMobile extends ConsumerStatefulWidget {
  final User user;
  final String questionId;
  final FetchAnswerParams params;
  final Question question;

  const AnswerListMobile(
      {super.key,
      required this.params,
      required this.user,
      required this.questionId,
      required this.question});

  @override
  _AnswerListMobileViewState createState() => _AnswerListMobileViewState();
}

class _AnswerListMobileViewState extends ConsumerState<AnswerListMobile> {
  bool isCommentsVisible = false;
  Answer? selectedItem; // Define item here
  int? isCommentsVisibleList =
      -1; // List to store visibility state for each row

  @override
  Widget build(BuildContext context) {
    final answersAsyncValue = ref.watch(answerListProvider(widget.params));

    if (answersAsyncValue is AsyncData) {
      final items = answersAsyncValue.value!;
      return Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 100),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                // Store the current item in the selectedItem variable
                selectedItem = item;
                final author = item.author;
                final formattedDate = DateFormat('MMM d HH:mm')
                    .format(DateTime.parse(item.postedAt.toString()).toLocal());
                var params = GetCommentsParams(
                    userId: widget.user.userId,
                    postId: item.answerId,
                    postType: "Answer");

                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(5),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 1, // the size of the shadow
                      shadowColor: Colors.black,

                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            askedbyViewHeader(item, ref),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 0,
                              ),
                              child: contentViewWidget(item),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: TextButton.icon(
                                        onPressed: () => postLikeDislikeAction(
                                            context, index, item, ref),
                                        icon: Icon(
                                          item.currentUserLiked
                                              ? Icons.thumb_up
                                              : Icons.thumb_up_alt_outlined,
                                          color: const Color(0xffF16C24),
                                          size: 13,
                                        ),
                                        label: const Text("")
                                        // label: Text(
                                        //   '${item.likes}',
                                        //   style: TextStyle(
                                        //     color: Color(0xffF16C24),
                                        //     fontSize: 11.0,
                                        //     fontFamily:
                                        //         GoogleFonts.inter().fontFamily,
                                        //     fontWeight: FontWeight.normal,
                                        //   ),
                                        // ),
                                        ),
                                  ),
                                  if (item.likes != 0)
                                    TextButton.icon(
                                      // <-- TextButton
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            var params = GetCommentsParams(
                                                userId: widget.user.userId,
                                                postId: item.answerId,
                                                postType: "Answer");

                                            return LikesWidget(
                                                user: widget.user,
                                                spaceName: "Answer",
                                                spaceId: item.answerId,
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
                                          fontFamily:
                                              GoogleFonts.notoSans().fontFamily,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  btnCommentsLayout(context, index, item, ref),
                                ],
                              ),
                            ),
                            if (isCommentsVisibleList == index)
                              Visibility(
                                visible: isCommentsVisible,
                                child: navigateToCommentScreen(),

                                // SizedBox(
                                //   height: MediaQuery.of(context).size.height *
                                //       0.5,
                                //   child: CommentsMobileView(
                                //     user: widget.user,
                                //     postId: selectedItem?.answerId ?? '',
                                //     posttype: "Answer",
                                //   ),
                                // )
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
    if (answersAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (answersAsyncValue is AsyncError) {
      if (answersAsyncValue.error == "The incoming token has expired") {}
      return ErrorScreen(showErrorMessage: true, onRetryPressed: retry); //

      // return Text('An error occurred: ${answersAsyncValue.error}');
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }

  // Create a function for navigation
  Widget navigateToCommentScreen() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: CommentsMobileView(
        user: widget.user,
        postId: selectedItem?.answerId ?? '',
        posttype: "Answer",
        context: context,
      ),
    );
  }

  Future<void> _onRefresh() async {
    ref.read(refresUserProvider(""));
    ref.watch(refresAnswerProvider(""));
  }

  void retry() {
    _onRefresh();
  }

  void postLikeDislikeAction(
      BuildContext context, int index, Answer item, WidgetRef ref) {
    final likeDislikeResult =
        ref.read(genricPostlikeDislikeProvider(PostLikeDislikeParams(
      userId: widget.user.userId,
      action: item.currentUserLiked ? "DISLIKE" : "LIKE",
      postlabel: "Answer",
      postIdPropValue: item.answerId,
    )));
  }

  Widget askedbyViewHeader(Answer item, WidgetRef ref) {
    bool isCurrentUser = item.authorId == widget.user.userId;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        // Use a Row instead of Wrap for horizontal alignment
        children: [
          _profilePicWidget(item, ref),
          const SizedBox(
            width: 5,
          ),
          Text("Replied by ",
              style: TextStyle(
                color: const Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.normal,
              )),
          Text(isCurrentUser ? "me" : item.author ?? "",
              style: TextStyle(
                color: const Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.normal,
              )),
          const Spacer(), // Add a Spacer widget to push the PopupMenuButton to the right.
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
                    _editItem(item); // Call the edit function
                  } else if (choice == 'Delete') {
                    _deleteItem(item); // Call the delete function
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: EditButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _editItem(item); // Call the edit function
                        },
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: DeleteButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteItem(item); // Call the delete function
                        },
                      ),
                    ),
                  ];
                },
              ),
            )
        ],
      ),
    );
  }

  Widget contentViewWidget(Answer item) {
    if (item.content != null) {
      return Text(item.content!,
          style: TextStyle(
            color: const Color(0xff676A79),
            fontSize: 14.0,
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontWeight: FontWeight.normal,
          ));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(Answer item, WidgetRef ref) {
    // final avatarText = getAvatarText(item.author!);

    final String? authorName = item.author;
    if (authorName == null || authorName.isEmpty) {
      return CircleAvatar(radius: 20.0, child: Text('NO'));
    }
    // final avatarText = getAvatarText(item.author!);
    final avatarText = getAvatarText(authorName);

    if (item.authorThumbnail == null || item.authorThumbnail == "") {
      return CircleAvatar(radius: 10.0, child: Text(avatarText));
    } else {
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProviderComments(item.authorThumbnail!));
      return Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                image: new AssetImage("assets/images/user_pic_s3_new.png"),
                fit: BoxFit.fill,
              )),
          child: profilePicAsyncValue.when(
            data: (imageUrl) {
              if (imageUrl != null && imageUrl.isNotEmpty) {
                if (_isProperImageUrl(imageUrl)) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(imageUrl),
                    radius: 12.0,
                  );
                } else {
                  return CircleAvatar(
                    radius: 12.0,
                    child: Text(
                      avatarText,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  );
                }
              } else {
                return CircleAvatar(
                    radius: 12.0,
                    child: Text(
                      avatarText,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  );
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
          ));
    }
  }

  bool _isProperImageUrl(String imageUrl) {
    // Check if the image URL contains spaces in the filename
    if (imageUrl.contains('%20')) {
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

// Edit an item
  void _editItem(Answer item) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CreatePostAnswerScreen(
                  question: widget.question,
                  answerItem: item,
                  isEditAnswer: true)));
    });
  }

// Delete an item
  void _deleteItem(Answer item) async {
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
                    label: 'Answer',
                    idPropValue: item.answerId,
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

  // BUTTONS: COMMENT
  Widget btnCommentsLayout(
      BuildContext context, int index, Answer item, WidgetRef ref) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                // setState(() {
                //   isCommentsVisible = !isCommentsVisible;

                //   if (isCommentsVisible == false) {
                //     isCommentsVisibleList = -1;
                //   } else {
                //     isCommentsVisibleList = index;
                //   }
                // });

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => CommentScreen(
                              headerCard:
                                  AnswerHeaderCardView(item: item, ref: ref),
                              postId: item.answerId,
                              posttype: "Answer",
                            )));
              },
              icon: Image.asset(
                'assets/images/chat_bubble_outline.png',
                width: 20,
                height: 20,
              ),
              //    label: Text(
              //   'View ${item.comments} Comments',
              //   style: TextStyle(
              //     color: const Color(0xff393E41),
              //     fontFamily: GoogleFonts.inter().fontFamily,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              label: Text(
                isCommentsVisible && isCommentsVisibleList == index
                    ? 'Hide Comments'
                    : 'View ${item.comments} Comments',
                style: TextStyle(
                  color: const Color(0xff393E41),
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
