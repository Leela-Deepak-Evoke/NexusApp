import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_filter_card.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_list.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/post_feed_fab.dart';
import 'package:evoke_nexus_app/app/widgets/common/common_search_bar.dart';
import 'package:flutter/material.dart';

class FeedsWebView extends StatefulWidget {
  final User user;
  const FeedsWebView({super.key, required this.user});

  @override
  State<FeedsWebView> createState() => _FeedsWebViewCardState();
}

class _FeedsWebViewCardState extends State<FeedsWebView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 600,
          child: FeedList(user: widget.user),
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
                child: FeedFilterCard(),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 130,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: PostFeedFAB(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
