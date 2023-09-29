import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_list_mobile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// class FeedsMobileView extends StatefulWidget {
//   final User user;
//   const FeedsMobileView({super.key, required this.user});

//   @override
//   State<FeedsMobileView> createState() => _FeedsMobileViewCardState();
// }

// class _FeedsMobileViewCardState extends State<FeedsMobileView> {

//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getFeedsAPi();
//   }
//   @override
//   void didUpdateWidget(covariant FeedsMobileView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Column(children: [
   
//         SearchHeaderView(name: "Feeds", searchController: _searchController, size: size, onSearchClicked: onSearchClicked),
//         Expanded(
//           child: Padding(
//           padding: const EdgeInsets.only(left: 0, right: 0, top: 10), 
//             child: FeedListMobile(user: widget.user),
//           ),
//         ),
//     ]);
//   }

//   //Call Back
//   onSearchClicked() {
//     setState(() {});
//   }

//   //BOTTOM SHEET CATEGORIES AND SORT

//   onCategoriesTapped(int? index) {}

//   /// API Calls
//   getFeedsAPi() async {}
// }


class FeedsMobileView extends ConsumerStatefulWidget {
  final User user;
  const FeedsMobileView({super.key, required this.user});

  @override
  _FeedsMobileViewCardState createState() => _FeedsMobileViewCardState();
}

class _FeedsMobileViewCardState extends ConsumerState<FeedsMobileView> {
  final TextEditingController _searchController = TextEditingController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getFeedsAPi();
  }

  @override
  void didUpdateWidget(covariant FeedsMobileView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(children: [
      SearchHeaderView(name: "Feeds", searchController: _searchController, size: size, onSearchClicked: onSearchClicked),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: FeedListMobile(user: widget.user),
          ),
        ),
      ),
    ]);
  }

  // Callback for pull-to-refresh
  Future<void> _onRefresh() async {
    // Add your logic to fetch new data here, for example:
    // await getFeedsAPi();

    // Access the 'ref' here
    final ref = this.ref;

    // Trigger a refresh of the feedsProvider to fetch new data
    await ref.refresh(feedsProvider(widget.user));

    // After fetching new data, remember to call refreshController.refreshCompleted()
    // to indicate that the refresh is complete.
    _refreshController.refreshCompleted();
  }

  // Callback for search
  onSearchClicked() {
    setState(() {});
  }

  // API Calls
  getFeedsAPi() async {
    // Add your API call logic here to fetch feeds
  }
}
