import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/review/widgets/review_list_mobile.dart';

class ReviewMobileView extends StatefulWidget {
  final User user;
  final String searchQuery;
  bool? isFilter;
  String? selectedCategory;

  ReviewMobileView(
      {super.key,
      required this.user,
      required this.searchQuery,
      this.isFilter,
      this.selectedCategory,
      //  this.selectedCategories
      // this.filterfeedsList
      });

  @override
  State<ReviewMobileView> createState() => _ReviewMobileViewCardState();
}

class _ReviewMobileViewCardState extends State<ReviewMobileView> {
  @override
  void initState() {
    super.initState();
    getFeedsAPi();
  }

  @override
  void didUpdateWidget(covariant ReviewMobileView oldWidget) {
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
          child: ReviewListMobile(
            user: widget.user,
            searchQuery: widget.searchQuery,
            isFilter: widget.isFilter ?? false,
            selectedCategory: widget.isFilter ?? false ? widget.selectedCategory : null,
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
