import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/answers_list.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


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

      return Column(
        children: [
          SearchHeaderView(
              name: 'Q&A', searchController: _searchController, size: size),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
    
              itemBuilder: (context, index) {
                final item = items[index];
                final formattedDate = DateFormat('MMM d HH:mm')
                    .format(DateTime.parse(item.postedAt.toString()).toLocal());

                return InkWell(
                  onTap: () 
                  {
                    context.goNamed(AppRoute.answersforum.name,queryParameters: {'questionid' : item.questionId});
                  },
                child:
                  Card(
                  margin: const EdgeInsets.all(10),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 2,
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
                          footerVIewWidget(formattedDate, item)
                        ],
                      )),
                )
             ); },
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedDate,
            style: TextStyle(fontSize: 12),
          ),
          TextButton.icon(
              onPressed: () {},
              icon: Image.asset('assets/images/response.png'),
              label: Text('${item.answers}',
                  style: TextStyle(fontSize: 12, color: Colors.black)))
        ],
      ),
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
        const Text("asked by"),
        Text(item.author ?? "")
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
              backgroundColor: Colors.red,
            ),
            Text(
              item.category ?? "General",
              style: const TextStyle(
                  color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
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
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(Question item, WidgetRef ref) {
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
              radius: 10,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    avatarText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  );
                },
              ),
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 10.0, child: Text(avatarText));
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
