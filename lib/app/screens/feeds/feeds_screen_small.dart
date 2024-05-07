// import 'package:evoke_nexus_app/app/models/user.dart';
// import 'package:evoke_nexus_app/app/provider/get_categories_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
// import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
// import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_mobile_view.dart';
// import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FeedsScreenSmall extends ConsumerStatefulWidget {
//    bool? isFromHomePage;

//    FeedsScreenSmall({super.key, this.isFromHomePage});
//   @override
//   ConsumerState<FeedsScreenSmall> createState() => _FeedsScreenSmallState();
// }

// class _FeedsScreenSmallState extends ConsumerState<FeedsScreenSmall> {
//   final TextEditingController _searchController = TextEditingController();
//   String? searchQuery = '';
//   int? selectedIndex;
//   List<String> checkListItems = [];
//   String selectedCategory = '';
//   bool isFilter = false;

//   // Multiple Categories - Define a Set to store selected categories
//   Set<String> selectedCategories = Set();

//   @override
//   Widget build(BuildContext context) {
//     final userAsyncValue = ref.watch(fetchUserProvider);
//     final categoryAsyncValue = ref.watch(categoriesProviderFeed);

//     return userAsyncValue.when(
//       data: (data) {
//         return MobileLayout(
//           title: 'Feeds',
//           user: data,
//           hasBackAction: widget.isFromHomePage == true ? true : false,
//           hasRightAction: true,
//           showSearchIcon: true,
//           topBarButtonAction: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     fullscreenDialog: true,
//                     builder: (context) => CreatePostFeedScreen()));
//           },
//           topBarSearchButtonAction: () {
//             onSearchClicked(data, categoryAsyncValue);
//             if (categoryAsyncValue is AsyncLoading) {
//               const Center(
//                 child: SizedBox(
//                   height: 50.0,
//                   width: 50.0,
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }
//           },
//           backButtonAction: () {
//             Navigator.pop(context);
//           },
//           child: FeedsMobileView(
//               user: data,
//               searchQuery: searchQuery ?? "",
//               isFilter: isFilter,
//               selectedCategory: selectedCategory
//               // filterfeedsList: isFilter == true ? null : null
//               ),
//         );
//       },
//       loading: () => const Center(
//         child: SizedBox(
//           height: 50.0,
//           width: 50.0,
//           child: CircularProgressIndicator(),
//         ),
//       ),
//       error: (error, stack) {
//         // Handle the error case if needed
//         return Text('An error occurred: $error');
//       },
//     );
//   }

//   void onSearchClicked(User data, AsyncValue<List<String>> categoryAsyncValue) {
//     if (categoryAsyncValue is AsyncData<List<String>>) {
//       final feedsCategoryList = categoryAsyncValue;
//       checkListItems = feedsCategoryList.value;
//       _showBottomSheet(context, data);
//     }
//     if (categoryAsyncValue is AsyncLoading) {
//       const Center(
//         child: SizedBox(
//           height: 50.0,
//           width: 50.0,
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     if (categoryAsyncValue is AsyncError) {
//       Text('An error occurred: ${categoryAsyncValue.error}');
//     }
//   }

//   void _showBottomSheet(BuildContext context, User data) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       'Search And Filter',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Search Feeds',
//                     ),
//                     onEditingComplete: () {
//                       _onSearchEditingComplete(data);
//                     },
//                     onChanged: (value) {
//                       setState(() {
//                         searchQuery = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   const Text(
//                     'Category',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   Wrap(
//                     spacing: 8.0,
//                     children: [
//                       _buildCategoryButton(
//                           'All', selectedCategory == 'All', setState, data),
//                       ...checkListItems.map((category) => _buildCategoryButton(
//                           category,
//                           selectedCategory == category,
//                           setState,
//                           data)),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _onSearchEditingComplete(User data) {
//     Navigator.of(context).pop();
//     isFilter = false;
//     setState(() {
//       Expanded(
//         child: Padding(
//             padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
//             child: FeedsMobileView(
//                 user: data,
//                 searchQuery: searchQuery ?? "",
//                 isFilter: isFilter,
//                 selectedCategory: selectedCategory)),
//       );
//     });
//   }

//   Widget _buildCategoryButton(
//       String category, bool isSelected, StateSetter setState, User data) {
//     return OutlinedButton(
//       //SINGLE Categorie SELECTED
//       // onPressed: () {
//       //   setState(() {
//       //     selectedCategory = category;
//       //     _onCategorySelected(selectedCategory, data);

//       //     // Implement category filter logic here
//       //   });
//       // },

//       style: OutlinedButton.styleFrom(
//         side: BorderSide(
//           color: isSelected ? const Color(0xffFFA500) : Colors.grey,
//           width: 1.0,
//         ),
//       ),
//       child: Text(
//         category,
//         style: TextStyle(
//           color: const Color(0xff676A79),
//           fontSize: 14.0,
//           fontFamily: GoogleFonts.notoSans().fontFamily,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

// // API

//   void _onCategorySelected(String selectedCategory, User data) async {
//     try {
//       isFilter = true;
//       selectedCategory = selectedCategory;
//       searchQuery = selectedCategory;

//       Navigator.of(context).pop();
//       setState(() {});
//     } catch (error) {
//       // Handle errors if necessary
//       print('Error filtering feeds: $error');
//     }
//   }
// }

import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/get_categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feeds_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedsScreenSmall extends ConsumerStatefulWidget {
  final bool? isFromHomePage;

  const FeedsScreenSmall({Key? key, this.isFromHomePage}) : super(key: key);

  @override
  ConsumerState<FeedsScreenSmall> createState() => _FeedsScreenSmallState();
}

class _FeedsScreenSmallState extends ConsumerState<FeedsScreenSmall> {
  final TextEditingController _searchController = TextEditingController();
  String? searchQuery = '';
  Set<String>? selectedCategories = Set(); // Track selected categories
  bool isFilter = false;

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    final categoryAsyncValue = ref.watch(categoriesProviderFeed);

    return userAsyncValue.when(
      data: (data) {
        return MobileLayout(
          title: 'Feeds',
          user: data,
          hasBackAction: widget.isFromHomePage == true,
          hasRightAction: true,
          showSearchIcon: true,
          topBarButtonAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => CreatePostFeedScreen(),
              ),
            );
          },
          topBarSearchButtonAction: () {
            onSearchClicked(data, categoryAsyncValue);
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          child: FeedsMobileView(
            user: data,
            searchQuery: searchQuery ?? "",
            isFilter: isFilter,
            selectedCategory: "",
            selectedCategories: selectedCategories?.toList(),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return Text('An error occurred: $error');
      },
    );
  }

  void onSearchClicked(User data, AsyncValue<List<String>> categoryAsyncValue) {
    if (categoryAsyncValue is AsyncData<List<String>>) {
      final feedsCategoryList = categoryAsyncValue;
      final List<String> checkListItems = feedsCategoryList.value;
      _showBottomSheet(context, data, checkListItems);
    }
  }

  void _showBottomSheet(
      BuildContext context, User data, List<String> categories) {
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
              padding: const EdgeInsets.all(16.0),
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
                        'All',
                        selectedCategories!.contains('All'),
                        setState,
                        'All',
                        data,
                      ),
                      ...categories.map((category) => _buildCategoryButton(
                            category,
                            selectedCategories!.contains(category),
                            setState,
                            category,
                            data,
                          )),
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
  Widget _buildCategoryButton(
    String category,
    bool isSelected,
    StateSetter setState,
    String categoryValue,
    User data,
  ) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedCategories!.remove(categoryValue); // Deselect category
          } else {
            selectedCategories!.add(categoryValue); // Select category
          }
           _onCategorySelected(selectedCategories, data);
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? const Color(0xffFFA500) : Colors.grey,
          width: 1.0,
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: const Color(0xff676A79),
          fontSize: 14.0,
          fontFamily: GoogleFonts.notoSans().fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onSearchEditingComplete_OLD(User data) {
    Navigator.of(context).pop();
    isFilter = false;
    setState(() {});
  }

  void _onSearchEditingComplete(User data) {
    Navigator.of(context).pop();
    isFilter = false;
    setState(() {
      Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
            child: FeedsMobileView(
                user: data,
                searchQuery: searchQuery ?? "",
                isFilter: isFilter,
               selectedCategory: "",
            selectedCategories: selectedCategories?.toList()
                )),
      );
    });
  }

    void _onCategorySelected(Set<String>? selectedCategories, User data) async {
    try {
      isFilter = true;
      selectedCategories = selectedCategories;
      // searchQuery = selectedCategories;

      Navigator.of(context).pop();
      setState(() {});
    } catch (error) {
      // Handle errors if necessary
      print('Error filtering feeds: $error');
    }
  }
}

