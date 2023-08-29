import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/forum_filter_card.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/forum_list.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/post_forum_fab.dart';
import 'package:evoke_nexus_app/app/widgets/common/common_search_bar.dart';
import 'package:flutter/material.dart';

class ForumWebView extends StatefulWidget {
  final User user;
  const ForumWebView({super.key, required this.user});

  @override
  State<ForumWebView> createState() => _ForumWebViewCardState();
}

class _ForumWebViewCardState extends State<ForumWebView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 600,
          child: ForumList(user: widget.user),
        ),
        Container(
          width: 275,
          child: const Column(
            children: [
              Align(alignment: Alignment.topRight, child: SearchCard()),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ForumFilterCard(),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 130,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: PostForumFAB(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
