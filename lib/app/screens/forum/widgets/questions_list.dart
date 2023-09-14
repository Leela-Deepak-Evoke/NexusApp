import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/answers_list.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/post_answer_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class QuestionsList extends ConsumerWidget {
  final User user;
  const QuestionsList({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsyncValue = ref.watch(questionsProvider(user));
    if (questionsAsyncValue is AsyncData) {

      final items = questionsAsyncValue.value!;
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final author = item.author;

          final formattedDate = DateFormat('MMM d HH:mm')
              .format(DateTime.parse(item.postedAt.toString()).toLocal());

          return 
          Card(
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: _profilePicWidget(item, ref),
                    title: Text(author!, style: const TextStyle(fontSize: 16)),
                    subtitle: Text(item.authorTitle!,
                        style: const TextStyle(fontSize: 14)),
                    trailing: Text(
                      formattedDate,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 14),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      contentViewWidget(item),
                      categoryViewWidget(item),
                      //const SizedBox(height: 4.0),
                      item.hasImage
                          ? AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                item.imagePath!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : const SizedBox(height: 2.0),
                      const SizedBox(height: 4.0),
                      const Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(width: 8.0),
                          OutlinedButton(
                            child: Text(
                                'View ${item.answers.toString()} Answers',
                                style: const TextStyle(fontSize: 12)),
                            onPressed: () {
                              _showAnswers(context, item.questionId, user);
                              print('Pressed');
                            },
                          ),
                          const SizedBox(width: 8.0),
                        //  PostAnswerFAB(user: user, questionId: item.questionId)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    if (questionsAsyncValue is AsyncLoading) {
      return  Container(
        color: Colors.white,
        child: 
       const Center(
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
      return Text(item.content!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(Question item, WidgetRef ref) {
    final avatarText = getAvatarText(item.author!);
    if (item.authorThumbnail == null) {
      return CircleAvatar(radius: 30.0, child: Text(avatarText));
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
              radius: 30.0,
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 30.0, child: Text(avatarText));
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
