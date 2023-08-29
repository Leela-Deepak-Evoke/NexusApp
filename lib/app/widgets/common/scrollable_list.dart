import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class ScrollableList extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      "feed_id": "d1ff0c8d-ec6c-4f89-af33-8eb1b23d0169",
      "content": "Know Your Client!",
      "media": "assets/images/org1.jpg",
      "postedAt": "2023-08-10T10:35:02.653455",
      "likes": 4,
      "comments": 5,
      "author": {
        "userId": "c1838d5a-f081-706a-58ed-555f2ae9932d",
        "name": "Evoke Learning",
        "title": "L&D Group",
        "profilePicture": null
      }
    },
    {
      "feed_id": "d1ff0c8d-ec6c-4f89-af33-8eb1b23d0171",
      "content": "UI Practice July Newsletter",
      "media": "assets/images/news.jpg",
      "postedAt": "2023-08-10T09:35:02.653455",
      "likes": 4,
      "comments": 5,
      "author": {
        "userId": "b1028d5a-f081-706a-58ed-555f2ae9102d",
        "name": "UI Practice",
        "title": "UI Practice Group",
        "profilePicture": null
      }
    }
  ];

  ScrollableList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final author = item['author'];

        final formattedDate = DateFormat('MMM d HH:mm')
            .format(DateTime.parse(item['postedAt']).toLocal());

        final avatarText = author['profilePicture'] != null
            ? ''
            : getAvatarText(author['name']);

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
                  leading: CircleAvatar(
                    backgroundImage: author['profilePicture'] != null
                        ? AssetImage(author['profilePicture'])
                        : null,
                    radius: 30.0,
                    child: Text(avatarText),
                  ),
                  title: Text(author['name'],
                      style: const TextStyle(fontSize: 16)),
                  subtitle: Text(author['title'],
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
                    Text(item['content'], style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4.0),
                    item['media'] != null
                        ? AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              item['media'],
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              iconSize: 15,
                              color: Colors.blue,
                              onPressed: () {},
                            ),
                            const SizedBox(width: 2.0),
                            Text(item['likes'].toString(),
                                style: const TextStyle(fontSize: 12)),
                            const Text(' Likes',
                                style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 8.0),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              iconSize: 15,
                              color: Colors.blue,
                              onPressed: () {},
                            ),
                            const SizedBox(width: 2.0),
                            Text(item['comments'].toString(),
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
