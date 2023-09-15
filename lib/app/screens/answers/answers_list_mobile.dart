import 'package:evoke_nexus_app/app/models/fetch_answer_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_utils.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_comments.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evoke_nexus_app/app/models/answer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerListMobile extends ConsumerWidget {
  final User user;
  final String questionId;
  final FetchAnswerParams params;
  const AnswerListMobile({
    super.key,
    required this.params,
    required this.user,
    required this.questionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answersAsyncValue = ref.watch(answerListProvider(params));

    if (answersAsyncValue is AsyncData) {
      final items = answersAsyncValue.value!;
      print(items);
      return Container(
          alignment: AlignmentDirectional.topStart,
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: Column(children: [
            Expanded(
                child: ListView.builder(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final author = item.author;

                final formattedDate = DateFormat('MMM d HH:mm')
                    .format(DateTime.parse(item.postedAt.toString()).toLocal());

                return Card(
                  margin: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        askedbyViewHeader(item, ref),
                        Divider(),
                        //  Divider(height: 1,color: Colors.grey,),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 0),
                            child: contentViewWidget(item)),

                        // const SizedBox(
                        //   height: 10,
                        // ),

                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  // width: double.infinity, // <-- match_parent
                                  // height: double.infinity,
                                  child: TextButton.icon(
                                    // <-- TextButton
                                    onPressed: () => likeed(),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 246, 230, 222))),
                                    icon: Icon(
                                      Icons.thumb_up_alt_outlined,
                                      color: Color(0xffF16C24),
                                      size: 13,
                                    ),
                                    label: Text(
                                      '${item.likes}',
                                      style: TextStyle(
                                        color: Color(0xffF16C24),
                                        fontSize: 11.0,
                                        fontFamily:
                                            GoogleFonts.inter().fontFamily,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))

                        // ListTile(
                        //   leading: _profilePicWidget(item, ref),
                        //   title: Text(author!, style: const TextStyle(fontSize: 16)),
                        //   subtitle: Text(item.authorTitle!,
                        //       style: const TextStyle(fontSize: 14)),
                        //   trailing: Text(
                        //     formattedDate,
                        //     style: const TextStyle(
                        //         fontStyle: FontStyle.italic, fontSize: 14),
                        //   ),
                        // ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const SizedBox(height: 4.0),
                        //     contentViewWidget(item),
                        //     const SizedBox(height: 4.0),
                        //     const Divider(
                        //       thickness: 1.0,
                        //       height: 1.0,
                        //     ),
                        //     Row(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       children: [
                        //         Row(
                        //           children: [
                        //             IconButton(
                        //               icon: const Icon(Icons.thumb_up),
                        //               iconSize: 15,
                        //               color: Colors.blue,
                        //               onPressed: () {
                        //                 showDialog(
                        //                   context: context,
                        //                   builder: (BuildContext context) {
                        //                     return LikesWidget(
                        //                       spaceId: item.answerId,
                        //                       spaceName: 'Answer',
                        //                       userId: user.userId,
                        //                     );
                        //                   },
                        //                 );
                        //               },
                        //             ),
                        //             const SizedBox(width: 2.0),
                        //             Text(item.likes.toString(),
                        //                 style: const TextStyle(fontSize: 12)),
                        //             const Text(' Likes',
                        //                 style: TextStyle(fontSize: 12)),
                        //             const SizedBox(width: 8.0),
                        //             IconButton(
                        //               icon: const Icon(Icons.comment),
                        //               iconSize: 15,
                        //               color: Colors.blue,
                        //               onPressed: () {
                        //                 showDialog(
                        //                   context: context,
                        //                   builder: (BuildContext context) {
                        //                     return CommentsWidget(
                        //                       spaceId: item.answerId,
                        //                       spaceName: 'Answer',
                        //                       userId: user.userId,
                        //                     );
                        //                   },
                        //                 );
                        //               },
                        //             ),
                        //             const SizedBox(width: 2.0),
                        //             Text(item.comments.toString(),
                        //                 style: const TextStyle(fontSize: 12)),
                        //             const Text(' Comments',
                        //                 style: TextStyle(fontSize: 12)),
                        //           ],
                        //         ),
                        //         const SizedBox(width: 8.0),
                        //         Row(
                        //           children: [
                        //             IconButton(
                        //               icon: const Icon(Icons.thumb_up_outlined),
                        //               iconSize: 20,
                        //               color: Colors.blue,
                        //               onPressed: () {},
                        //               tooltip: "Like",
                        //             ),
                        //             const SizedBox(width: 4.0),
                        //             IconButton(
                        //               icon: const Icon(Icons.comment_outlined),
                        //               iconSize: 20,
                        //               color: Colors.blue,
                        //               onPressed: () {},
                        //               tooltip: "Comment",
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                );
              },
              
            ))
          ]));
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
      return Text('An error occurred: ${answersAsyncValue.error}');
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }

  void likeed() {}

  Widget askedbyViewHeader(Answer item, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
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
          Text(item.author ?? "",
              style: TextStyle(
                color: Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.normal,
              ))
        ],
      ),
    );
  }

  Widget contentViewWidget(Answer item) {
    if (item.content != null) {
      return Text(item.content!,
          style: TextStyle(
            color: Color(0xff676A79),
            fontSize: 14.0,
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontWeight: FontWeight.normal,
          ));
    } else {
      return const SizedBox(height: 5.0);
    }
  }



  Widget _profilePicWidget(Answer item, WidgetRef ref) {
    final avatarText = getAvatarText(item.author!);
    if (item.authorThumbnail == null) {
      return CircleAvatar(radius: 10.0, child: Text(avatarText));
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
}
