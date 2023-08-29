import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_media_view.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_comments.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';

class FeedList extends ConsumerWidget {
  final User user;
  const FeedList({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedsAsyncValue = ref.watch(feedsProvider(user));

    if (feedsAsyncValue is AsyncData) {
      final items = feedsAsyncValue.value!;
      return ListView.builder(
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
                      hasTagViewWidget(item),
                      //const SizedBox(height: 4.0),
                      item.media
                          ? AspectRatio(
                              aspectRatio: 16 / 9,
                              child: FeedMediaView(item: item),
                            )
                          : const SizedBox(height: 2.0),
                      const SizedBox(height: 4.0),
                      const Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up),
                                iconSize: 15,
                                color: Colors.blue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return LikesWidget(
                                        spaceId: item.feedId,
                                        spaceName: 'Feed',
                                        userId: user.userId,
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 2.0),
                              Text(item.likes.toString(),
                                  style: const TextStyle(fontSize: 12)),
                              const Text(' Likes',
                                  style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 8.0),
                              IconButton(
                                icon: const Icon(Icons.comment),
                                iconSize: 15,
                                color: Colors.blue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CommentsWidget(
                                        spaceId: item.feedId,
                                        spaceName: 'Feed',
                                        userId: user.userId,
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 2.0),
                              Text(item.comments.toString(),
                                  style: const TextStyle(fontSize: 12)),
                              const Text(' Comments',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up_outlined),
                                iconSize: 20,
                                color: Colors.blue,
                                onPressed: () {},
                                tooltip: "Like",
                              ),
                              const SizedBox(width: 4.0),
                              IconButton(
                                icon: const Icon(Icons.comment_outlined),
                                iconSize: 20,
                                color: Colors.blue,
                                onPressed: () {},
                                tooltip: "Comment",
                              ),
                            ],
                          ),
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
    if (feedsAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (feedsAsyncValue is AsyncError) {
      return Text('An error occurred: ${feedsAsyncValue.error}');
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }

  Widget hasTagViewWidget(Feed item) {
    if (item.hashTag != null) {
      return Text(item.hashTag!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget contentViewWidget(Feed item) {
    if (item.content != null) {
      return Text(item.content!, style: const TextStyle(fontSize: 14));
    } else if (item.mediaCaption != null) {
      return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(Feed item, WidgetRef ref) {
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
}
