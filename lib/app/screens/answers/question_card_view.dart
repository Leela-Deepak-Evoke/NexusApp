import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/create_post_answers/create_post_answer_screen.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../provider/comment_service_provider.dart';

class QuestionCardView extends ConsumerWidget {
  final User user;
  final Question item;
  const QuestionCardView({super.key, required this.user, required this.item});

  //final feedService = FeedService();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat('MMM d HH:mm')
        .format(DateTime.parse(item.postedAt.toString()).toLocal());
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: Colors.black,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              categoryHearViewWidget(item),
              const SizedBox(
                height: 5,
              ),
              contentViewWidget(item),
              const SizedBox(
                height: 10,
              ),
              askedbyViewHeader(item, ref),
              footerVIewWidget(formattedDate, item, context)
            ],
          )),
    );
  }

  Widget footerVIewWidget(
      String formattedDate, Question item, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Global.calculateTimeDifferenceBetween(
              Global.getDateTimeFromStringForPosts(item.postedAt.toString())),
          style: TextStyle(
            color: const Color(0xff676A79),
            fontSize: 12.0,
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontWeight: FontWeight.normal,
          ),
        ),
        Row(
          children: [
            TextButton.icon(
                onPressed: null,
                icon: Image.asset('assets/images/response.png'),
                label: Text(
                  '${item.answers}',
                  style: TextStyle(
                    color: const Color(0xff676A79),
                    fontSize: 12.0,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.normal,
                  ),
                )),
            Container(
              height: 26,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color(0xffF2722B),
                  side: const BorderSide(width: 1, color: Color(0xffF2722B)),
                ),
                // <-- OutlinedButton
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              CreatePostAnswerScreen(question: item)));
                },
                child: Text('Reply',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }

  Wrap askedbyViewHeader(Question item, WidgetRef ref) {
    bool isCurrentUser = item.authorId == user.userId;

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
            ))
      ],
    );
  }

  Widget categoryHearViewWidget(Question item) {
    return Container(
      child: Wrap(
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
                color: const Color(0xffB54242),
                fontSize: 12.0,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  );
                }
              } else {
                return CircleAvatar(
                  radius: 12.0,
                  child: Text(
                    avatarText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
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
}
