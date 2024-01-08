import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_list_mobile.dart';
import 'package:flutter/material.dart';

class OrgUpdateMobileView extends StatefulWidget {
  final User user;
  final String searchQuery;
  bool? isFilter;
  String? selectedCategory;
  Function() onPostClicked;

  OrgUpdateMobileView(
      {super.key,
      required this.user,
      required this.searchQuery,
      this.isFilter,
      this.selectedCategory,
      required this.onPostClicked});

  @override
  State<OrgUpdateMobileView> createState() => _OrgUpdateMobileViewCardState();
}

class _OrgUpdateMobileViewCardState extends State<OrgUpdateMobileView> {
  @override
  Widget build(BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: OrgUpdateListMobile(
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

  void onSearchClicked() {}
}
