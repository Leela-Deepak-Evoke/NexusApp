import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_filter_card.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/post_feed_fab.dart';
import 'package:evoke_nexus_app/app/screens/timeline/widgets/timeline_list.dart';
import 'package:evoke_nexus_app/app/widgets/common/common_search_bar.dart';
import 'package:flutter/material.dart';

class TimelineWebView extends StatefulWidget {
  final User user;
  const TimelineWebView({super.key, required this.user});

  @override
  State<TimelineWebView> createState() => _TimelineWebViewCardState();
}

class _TimelineWebViewCardState extends State<TimelineWebView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 600,
          child: TimelineList(user: widget.user),
        ),
        SizedBox(
          width: 275,
          child: Column(
            children: [
              const Align(alignment: Alignment.topRight, child: SearchCard()),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: FeedFilterCard(),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 130,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: PostFeedFAB(
                    user: widget.user,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
