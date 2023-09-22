import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/timeline/widgets/timeline_list_mobile.dart';
import 'package:flutter/material.dart';

class TimelineMobileView extends StatefulWidget {
  final User user;
  const TimelineMobileView({super.key, required this.user});

  @override
  State<TimelineMobileView> createState() => _TimelineMobileViewCardState();
}

class _TimelineMobileViewCardState extends State<TimelineMobileView> {
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
          // SearchHeaderView(name: "Feeds", searchController: _searchController, size: size, onSearchClicked: onSearchClicked),
        Expanded(
          child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10), 
            child: TimelineListMobile(user: widget.user),
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
