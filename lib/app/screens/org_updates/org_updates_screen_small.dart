import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/get_categories_provider.dart';
import 'package:evoke_nexus_app/app/screens/create_post_orgupdates/create_post_orgupdates_screen.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OrgUpdatesScreenSmall extends ConsumerStatefulWidget {
     bool? isFromHomePage;

   OrgUpdatesScreenSmall({super.key, this.isFromHomePage});
  @override
  ConsumerState<OrgUpdatesScreenSmall> createState() => _OrgUpdatesScreenSmall();
}


class _OrgUpdatesScreenSmall extends ConsumerState<OrgUpdatesScreenSmall> {
    final TextEditingController _searchController = TextEditingController();
  String? searchQuery = '';
  int? selectedIndex;
  List<String> checkListItems = [];
  String selectedCategory = '';
  bool isFilter = false;

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    final categoryAsyncValue = ref.watch(categoriesProviderorgUpdates);
    return userAsyncValue.when(
      data: (data) {
        return MobileLayout(
          title: 'Organization Updates',
          user: data,
          hasBackAction: widget.isFromHomePage == true ? true : false,
          showSearchIcon: true,
          hasRightAction:
              (data.role == 'Group' || data.role == 'Leader') ? true : false,
          topBarButtonAction: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => CreatePostOrgUpdatesScreen()));
          },
          topBarSearchButtonAction: () {
            onSearchClicked(data, categoryAsyncValue);
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          child: OrgUpdateMobileView(
                          user: data,
              searchQuery: searchQuery ?? "",
              isFilter: isFilter,
              selectedCategory: selectedCategory,
            onPostClicked: () {},
          ),
        );
      },
      loading: () => const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return Text('An error occurred: $error');
      },
    );
  }

  void onSearchClicked(User data, AsyncValue<List<String>> categoryAsyncValue) {
    if (categoryAsyncValue is AsyncData<List<String>>) {
      final orgUpdatesCategoryList = categoryAsyncValue;
      checkListItems = orgUpdatesCategoryList.value;
      _showBottomSheet(context, data);
    }
    if (categoryAsyncValue is AsyncLoading) {
      const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  void _showBottomSheet(BuildContext context, User data) {
    final Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
                      hintText: 'Search Organization Updates',
                    ),
                    onEditingComplete: () {
                      _onSearchEditingComplete(data);
                    },
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
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
                          'All', selectedCategory == 'All', setState, data),
                      ...checkListItems.map((category) => _buildCategoryButton(
                          category,
                          selectedCategory == category,
                          setState,
                          data)),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onSearchEditingComplete(User data) {
    Navigator.of(context).pop();
    isFilter = false;
    setState(() {
      Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
            child: OrgUpdateMobileView(
                user: data,
                searchQuery: searchQuery ?? "",
                isFilter: isFilter,
                selectedCategory: selectedCategory,  onPostClicked: () {},)),
      );
    });
  }

  Widget _buildCategoryButton(
      String category, bool isSelected, StateSetter setState, User data) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
          _onCategorySelected(selectedCategory, data);

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

// API

  void _onCategorySelected(String selectedCategory, User data) async {
    try {
      isFilter = true;
      selectedCategory = selectedCategory;
      searchQuery = selectedCategory;

      Navigator.of(context).pop();
      setState(() {});
    } catch (error) {
      // Handle errors if necessary
      print('Error filtering feeds: $error');
    }
  }
  }
