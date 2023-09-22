import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ContentType {
  image,
  video,
  document,
}

class CommentsMobileView extends ConsumerStatefulWidget {
  final User user;
  const CommentsMobileView({super.key, required this.user});

  @override
  ConsumerState<CommentsMobileView> createState() =>
      _CommentsMobileViewState();
}

class _CommentsMobileViewState extends ConsumerState<CommentsMobileView> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: CommentTreeWidget<Comment, Comment>(
          Comment(
              avatar: 'null',
              userName: 'null',
              content: 'felangel made felangel/cubit_and_beyond public '),
          [
            Comment(
                avatar: 'null',
                userName: 'null',
                content: 'A Dart template generator which helps teams'),
            Comment(
                avatar: 'null',
                userName: 'null',
                content:
                    'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
            Comment(
                avatar: 'null',
                userName: 'null',
                content: 'A Dart template generator which helps teams'),
            Comment(
                avatar: 'null',
                userName: 'null',
                content:
                    'A Dart template generator which helps teams generator which helps teams '),
          ],
          treeThemeData:
              const TreeThemeData(lineColor: Colors.transparent, lineWidth: 0),
          avatarRoot: (context, data) => PreferredSize(
            child: CircleAvatar(
              radius: 18,
              // backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/images/peopleTech.png'),
            ),
            preferredSize: Size.fromRadius(18),
          ),

          //Child tree list
          avatarChild: (context, data) => const PreferredSize(
            preferredSize: Size.fromRadius(12),
            child: CircleAvatar(
              radius: 12,
              // backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/images/peopleTech.png'),
            ),
          ),

          contentChild: (context, data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dangngocduc',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${data.content}',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                // DefaultTextStyle(
                //   style: Theme.of(context).textTheme.caption!.copyWith(
                //       color: Colors.grey[700], fontWeight: FontWeight.bold),
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 4),
                //     child: Row(
                //       children: [
                //         SizedBox(
                //           width: 8,
                //         ),
                //         Text('Like'),
                //         SizedBox(
                //           width: 24,
                //         ),
                //         Text('Reply'),
                //       ],
                //     ),
                //   ),
                // )
              ],
            );
          },
          contentRoot: (context, data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dangngocduc',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${data.content}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        // SizedBox(
                        //   width: 8,
                        // ),
                        // Text('Like'),
                        SizedBox(
                          width: 24,
                        ),
                        Text('Reply'),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    
        ));
  }

}
