import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/models/forum.dart';
import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/delete_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/answers_list.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/edit_delete_button.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsListMobile extends ConsumerStatefulWidget {
  final User user;
  String? searchQuery;
  bool? isFilter;
  String? selectedCategory;

  QuestionsListMobile(
      {super.key,
      required this.user,
      this.searchQuery,
      this.isFilter,
      this.selectedCategory});

  @override
  _QuestionsListMobileViewState createState() =>
      _QuestionsListMobileViewState();
}

class _QuestionsListMobileViewState extends ConsumerState<QuestionsListMobile> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final questionsAsyncValue = ref.watch(questionsProvider(widget.user));
    if (questionsAsyncValue is AsyncData) {
      final items = questionsAsyncValue.value!;
      if (items.isEmpty) {
        // Handle the case where there is no data found
        return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
      } else {
        List<Question> filteredItems = [];
        if (widget.searchQuery != "All" && widget.selectedCategory != "All") {
          filteredItems = items.where((item) {
            return item.author?.contains(widget.searchQuery ?? '') == true ||
                item.name.contains(widget.searchQuery ?? '') == true ||
                item.authorTitle?.contains(widget.searchQuery ?? '') == true ||
                item.content?.contains(widget.searchQuery ?? '') == true ||
                item.status.contains(widget.searchQuery ?? '') == true ||
                item.category?.contains(widget.searchQuery ?? '') == true;
          }).toList();
        } else if (widget.selectedCategory == "All" ||
            widget.searchQuery == "All") {
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
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: 0),
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final formattedDate = DateFormat('MMM d HH:mm').format(
                            DateTime.parse(item.postedAt.toString()).toLocal());

                        return InkWell(
                            onTap: () {
                              context.goNamed(
                                AppRoute.answersforum.name,
                                extra: item,
                              );
                            },
                            child: Card(
                              // margin: const EdgeInsets.all(0),
                              // clipBehavior: Clip.antiAlias,
                              //  shape: RoundedRectangleBorder(
                              //          borderRadius: BorderRadius.circular(0)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      categoryHearViewWidget(item),

                                      //
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      contentViewWidget(item),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      askedbyViewHeader(item, ref),
                                      footerVIewWidget(formattedDate, item)
                                    ],
                                  )),
                            ));
                      },
                      // separatorBuilder: (BuildContext context, int index) {
                      //   return const Divider();
                      // },
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ]),
              ));
        }
      }
    }
    if (questionsAsyncValue is AsyncLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // if (questionsAsyncValue is AsyncError) {
    //   return Text('An error occurred: ${questionsAsyncValue.error}');
    // }

    if (questionsAsyncValue is AsyncError) {
      return ErrorScreen(showErrorMessage: true, onRetryPressed: retry);
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }

  Widget footerVIewWidget(String formattedDate, Question item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Global.calculateTimeDifferenceBetween(
              Global.getDateTimeFromStringForPosts(item.postedAt.toString())),
          style: TextStyle(
            color: Color(0xff676A79),
            fontSize: 12.0,
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontWeight: FontWeight.normal,
          ),
        ),
        TextButton.icon(
            onPressed: () {},
            icon: Image.asset('assets/images/response.png'),
            label: Text(
              '${item.answers}',
              style: TextStyle(
                color: Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            )),
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
              color: Color(0xff393E41),
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Wrap askedbyViewHeader(Question item, WidgetRef ref) {
    bool isCurrentUser = item.authorId == widget.user.userId;

    return Wrap(
      direction: Axis.horizontal,
      spacing: 2,
      children: [
        _profilePicWidget(item, ref),
        const SizedBox(
          width: 5,
        ),
        Text("Asked by",
            style: TextStyle(
              color: Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            )),
        Text(isCurrentUser ? "me" : item.author ?? "",
            style: TextStyle(
              color: Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            )),
      ],
    );
  }

  Widget categoryHearViewWidget(Question item) {
    bool isCurrentUser = item.authorId == widget.user.userId;

    return Container(
      child: Row(
        children: [
          Wrap(
            spacing: 5,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const CircleAvatar(
                radius: 3,
                backgroundColor: Color(0xffB54242),
              ),
              Text(
                item.category ?? "General",
                style: TextStyle(
                  color: Color(0xffB54242),
                  fontSize: 12.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Spacer(), // Add a Spacer widget to push the PopupMenuButton to the right.
          if (isCurrentUser)
            Container(
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
            ),
        ],
      ),
    );
  }

  Widget categoryHearViewWidget_old(Question item) {
    bool isCurrentUser = item.authorId == widget.user.userId;

    return Container(
      child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
                spacing: 5,
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: Color(0xffB54242),
                  ),
                  Text(
                    item.category ?? "General",
                    style: TextStyle(
                      color: Color(0xffB54242),
                      fontSize: 12.0,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, //spaceBetween
                        children: [
                          if (isCurrentUser)
                            Container(
                              width: 30, // Adjust the width as needed
                              child: PopupMenuButton<String>(
                                //  padding: const EdgeInsets.only(left: 50, right: 0),

                                icon: const Icon(
                                  Icons.more_vert,
                                ),
                                onSelected: (String choice) {
                                  // Handle button selection here
                                  if (choice == 'Edit') {
                                    _editItem(item); // Call the edit function
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
                                          _deleteItem(
                                              item); // Call the delete function
                                        },
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            )
                        ]),
                  ),
                ])
          ]),
    );
  }

  Widget categoryViewWidget(Question item) {
    if (item.category != null && item.subCategory != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.category!, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 16.0),
          Text(item.category!, style: const TextStyle(fontSize: 14)),
        ],
      );
    } else if (item.category != null) {
      return Text(item.category!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget contentViewWidget(Question item) {
    if (item.content != null) {
      var content = '';
      if (item.content!.length > 80) {
        content = '${item.content!.substring(0, 80)}...';
      } else {
        content = item.content!;
      }
      return Text(content,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
          ));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(Question item, WidgetRef ref) {
    final avatarText = getAvatarText(item.author!);
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

  String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }

  Future<void> _onRefresh() async {
    ref.read(refresUserProvider(""));
    ref.watch(refresForumProvider(""));
  }

  void retry() {
    _onRefresh();
  }

  void _showAnswers(BuildContext context, String questionId, User user) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                color: Colors.indigoAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('View Answers',
                          style: TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              content: SingleChildScrollView(
                child: AnswerList(user: user, questionId: questionId),
              ));
        });
  }

// Edit an item
  void _editItem(Question item) {
    // Implement your edit logic here, e.g., navigate to the edit screen

    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CreatePostForumScreen(
                questionItem: item, isEditQuestion: true)),
      );
    });
  }

// Delete an item
  void _deleteItem(Question item) async {
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
                    label: 'Question',
                    idPropValue: item.questionId,
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
