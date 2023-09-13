import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../provider/comment_service_provider.dart';

class QuestionCardView extends ConsumerWidget {
  final User user;
  final Question item;
  const QuestionCardView({super.key, required this.user ,required this.item});

  //final feedService = FeedService();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final formattedDate = DateFormat('MMM d HH:mm')
                          .format(DateTime.parse(item.postedAt.toString()).toLocal());
    return Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
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
    );
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
 
}
