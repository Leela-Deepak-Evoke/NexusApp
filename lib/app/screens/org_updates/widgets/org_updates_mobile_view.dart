
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_list_mobile.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';

class OrgUpdateMobileView extends StatefulWidget {
  final User user;
  Function() onPostClicked;
   OrgUpdateMobileView({super.key, required this.user,required this.onPostClicked});

  @override
  State<OrgUpdateMobileView> createState() => _OrgUpdateMobileViewCardState();
}

class _OrgUpdateMobileViewCardState extends State<OrgUpdateMobileView> {
   TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     final Size size = MediaQuery.of(context).size;
    return Column(children: [

      // SearchHeaderView(name: "OrgUpdates", searchController: _searchController, size: size ,onSearchClicked: () {
        
      // },),
      // SearchHeaderView(onIconClicked: onSearchClicked),

        Expanded(
          child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0), 
            child: OrgUpdateListMobile(user: widget.user),
          ),
        ),
    ]);
    
  }


  void onSearchClicked() {
  }
}
