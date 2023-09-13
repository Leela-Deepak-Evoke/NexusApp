import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_bar_small.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_list_mobile.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/post_feed_fab.dart';

class FeedsMobileView extends StatefulWidget {
  final User user;
  const FeedsMobileView({super.key, required this.user});

  @override
  State<FeedsMobileView> createState() => _FeedsMobileViewCardState();
}

class _FeedsMobileViewCardState extends State<FeedsMobileView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeedsAPi();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(children: [
   
        SearchHeaderView(name: "Feeds", searchController: _searchController, size: size, onSearchClicked: onSearchClicked),
        Expanded(
          child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10), 
            child: FeedListMobile(user: widget.user),
          ),
        ),
    ]);
  }

  //Call Back
  onSearchClicked() {
    setState(() {});
  }

  //BOTTOM SHEET CATEGORIES AND SORT

  onCategoriesTapped(int? index) {}

  /// API Calls
  getFeedsAPi() async {}
}
