import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_list_mobile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedsMobileView extends StatefulWidget {
  final User user;
  final VoidCallback onSearchClicked;

  const FeedsMobileView(
      {super.key, required this.user, required this.onSearchClicked});

  @override
  State<FeedsMobileView> createState() => _FeedsMobileViewCardState();
  // Static method to be called without an instance of FeedsMobileView
  static void onSearchClickedStatic() {
    // Implement the logic as needed
        // FeedsMobileView.onSearchClicked();

  }

}

class _FeedsMobileViewCardState extends State<FeedsMobileView> {
  final TextEditingController _searchController = TextEditingController();
  String? searchQuery = '';

  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    // Add more items as needed
  ];

  List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    // Add more categories as needed
  ];

  String selectedCategory = 'All'; // Default category is 'All'

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
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: FeedListMobile(user: widget.user, searchQuery: searchQuery),
        ),
      ),
    ]);
  }

  // Call this method when you want to trigger the search
  
  //Call Back
  void onSearchClicked() {
    setState(() {});
    // _showToast(context);
    _showBottomSheet(context);
  }

  void _showBottomSheet(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Search And Filter',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Feeds',
                    ),
                    onEditingComplete: () {
                      // Trigger the search or hide bottom sheet when "Done" is pressed
                      _onSearchEditingComplete();
                    },
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(
                        //         left: 0, right: 0, top: 10),
                        //     child: FeedListMobile(
                        //         user: widget.user, searchQuery: searchQuery),
                        //   ),
                        // ); // Update the search query
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _buildCategoryButton(
                          'All', selectedCategory == 'All', setState),
                      ...categories.map((category) => _buildCategoryButton(
                          category, selectedCategory == category, setState)),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Implement your filtering logic based on search and category
                        if (selectedCategory == 'All' ||
                            items[index].contains(_searchController.text) &&
                                items[index].contains(selectedCategory)) {
                          return ListTile(
                            title: Text(items[index]),
                          );
                        } else {
                          return Container(); // Empty container for items not meeting criteria
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onSearchEditingComplete() {
    // You can add additional search logic here if needed
    // For now, let's just hide the bottom sheet
    Navigator.of(context).pop();
    setState(() {
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: FeedListMobile(user: widget.user, searchQuery: searchQuery),
        ),
      );
    });
  }

  Widget _buildCategoryButton(
      String category, bool isSelected, StateSetter setState) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
          // Implement category filter logic here
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? Color(0xffFFA500) : Colors.grey,
          width: 1.0,
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Color(0xff676A79),
          fontSize: 14.0,
          fontFamily: GoogleFonts.notoSans().fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
          height: 70,
          child: Text('In Progress'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  //BOTTOM SHEET CATEGORIES AND SORT

  onCategoriesTapped(int? index) {}

  /// API Calls
  getFeedsAPi() async {}
}
