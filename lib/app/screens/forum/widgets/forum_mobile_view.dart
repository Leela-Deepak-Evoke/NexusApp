import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/questions_list_mobile.dart';
import 'package:flutter/material.dart';

class ForumMobileView extends StatefulWidget {
  final User user;
  final String searchQuery;
  bool? isFilter;
  String? selectedCategory;
  Function() onPostClicked;
  ForumMobileView(
      {super.key,
      required this.user,
      required this.searchQuery,
      this.isFilter,
      this.selectedCategory,
      required this.onPostClicked});

  @override
  State<ForumMobileView> createState() => _ForumMobileViewCardState();
}

class _ForumMobileViewCardState extends State<ForumMobileView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
           // SearchHeaderView(name: "Forum", searchController: _searchController, size: size ,onSearchClicked: onSearchClicked),
       // SearchHeaderView(onIconClicked: onSearchClicked),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
            child: QuestionsListMobile(
              user: widget.user,
              searchQuery: widget.searchQuery,
              isFilter: widget.isFilter ?? false,
              selectedCategory:
                  widget.isFilter ?? false ? widget.selectedCategory : null,
            ),
          ),
        ),
      ],
    );
  }
}
