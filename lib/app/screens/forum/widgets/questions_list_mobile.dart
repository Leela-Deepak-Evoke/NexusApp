import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/answers_list.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsListMobile extends ConsumerWidget {
  final User user;

  const QuestionsListMobile({super.key, required this.user});

  //final feedService = FeedService();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _searchController = TextEditingController();
    final Size size = MediaQuery.of(context).size;
    final questionsAsyncValue = ref.watch(questionsProvider(user));
    if (questionsAsyncValue is AsyncData) {
      final items = questionsAsyncValue.value!;

      return Container(
        alignment: AlignmentDirectional.topStart,
        padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final formattedDate = DateFormat('MMM d HH:mm')
                    .format(DateTime.parse(item.postedAt.toString()).toLocal());

                return InkWell(
                    onTap: () {
                      context.goNamed(AppRoute.answersforum.name,
                          extra: item,
                          queryParameters: {'questionid': item.questionId});
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
      );
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

    if (questionsAsyncValue is AsyncError) {
      return Text('An error occurred: ${questionsAsyncValue.error}');
    }
    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }

  Widget footerVIewWidget(String formattedDate, Question item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
             Global.calculateTimeDifferenceBetween(Global.getDateTimeFromStringForPosts(item.postedAt.toString())),
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
            ))
      ],
    );
  }

  Wrap askedbyViewHeader(Question item, WidgetRef ref) {
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
        Text(item.author ?? "",
            style: TextStyle(
              color: Color(0xff676A79),
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
                color: Color(0xffB54242),
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
}
