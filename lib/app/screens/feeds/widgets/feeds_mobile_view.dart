import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_list_mobile.dart';

class FeedsMobileView extends StatefulWidget {
  final User user;
  final String searchQuery;
  bool? isFilter;
  String? selectedCategory;
// AsyncValue<List<Feed>>? filterfeedsList;
  List<String>? selectedCategories; // Track selected categories

  FeedsMobileView(
      {super.key,
      required this.user,
      required this.searchQuery,
      this.isFilter,
      this.selectedCategory,
       this.selectedCategories
      // this.filterfeedsList
      });

  @override
  State<FeedsMobileView> createState() => _FeedsMobileViewCardState();
}

class _FeedsMobileViewCardState extends State<FeedsMobileView> {
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

  return Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: FeedListMobile(
            user: widget.user,
            searchQuery: widget.searchQuery,
            isFilter: widget.isFilter ?? false,
            selectedCategory: widget.isFilter ?? false ? widget.selectedCategory : null,
            selectedCategories:  widget.isFilter ?? false ? widget.selectedCategories?.toList() : null,
          ),
        ),
      ),
    ],
  );
}



  //BOTTOM SHEET CATEGORIES AND SORT

  onCategoriesTapped(int? index) {}

  /// API Calls
  getFeedsAPi() async {}
}
