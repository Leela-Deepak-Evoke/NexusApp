import 'package:evoke_nexus_app/app/widgets/common/filter_card.dart';
import 'package:evoke_nexus_app/app/widgets/common/scrollable_list.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/profile_card.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_filter_card.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/post_feed_fab.dart';

class ContentCard extends StatefulWidget {
  final String contentKey;

  const ContentCard({
    super.key,
    required this.contentKey,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  @override
  Widget build(BuildContext context) {
    Widget getChildBasedOnKeyType() {
      switch (widget.contentKey) {
        case 'feeds':
          return Container();
        case 'profile':
          return Container();
        case 'orgUpdates':
          return ScrollableList();
        default:
          return Container(); // Default case if none of the keys match
      }
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ProfileCard(),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text('Terms of Use | Privacy Policy | Disclaimer',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 5, 14, 69),
                                  fontStyle: FontStyle.normal)),
                          SizedBox(height: 10),
                          Text(
                              'Evoke Technologies Pvt. Ltd. © 2023 All Rights Reserved.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 5, 14, 69),
                                  fontStyle: FontStyle.italic)),
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.topCenter,
                child: getChildBasedOnKeyType(),
              ),
            ),
            const SizedBox(width: 16),
            if (widget.contentKey == 'feeds')
              const Expanded(
                flex: 2,
                child: Column(children: [
                  FeedFilterCard(),
                  SizedBox(height: 200),
                  Align(alignment: Alignment.bottomRight, child: PostFeedFAB())
                ] // Replace with your desired widget
                    ),
              )
            else if (widget.contentKey == 'orgUpdates')
              const Expanded(flex: 2, child: FilterCard())
          ],
        ),
      ),
    );
  }
}
