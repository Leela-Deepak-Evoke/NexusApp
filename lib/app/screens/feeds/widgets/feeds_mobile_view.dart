import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_bar_small.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_list.dart';

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
      Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchBarSmall(
                searchController: _searchController,
                text: "Feed",
                width: size.width - 90,
                onPostSucess: onSearchClicked),
            const Spacer(),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color.fromRGBO(255, 255, 255, 0.2),
              ),
              child: IconButton(
                icon: Image.asset(
                  'assets/images/verticalLines.png',
                  width: 44,
                  height: 44,
                ),
                onPressed: () {
                  openBottomSheetForCategories();
                },
              ),
            ),
          ],
        ),
      ),
 Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 20),      
          child: FeedList(user: widget.user),
        ),
    ]);
  }

  //Call Back
  onSearchClicked() {
    setState(() {});
  }

  //BOTTOM SHEET CATEGORIES AND SORT
  openBottomSheetForCategories() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Container();
          // return FilterSortCategoryScreenSmall(
          //   title: 'Select Post Category', //Select Feeds',
          //   categories: categories,
          //   onCategoriesSelected: onCategoriesTapped,
          //   index: selectedIndex,
          // );
        },
        fullscreenDialog: true));
  }

  onCategoriesTapped(int? index) {}

  /// API Calls
  getFeedsAPi() async {}
}
