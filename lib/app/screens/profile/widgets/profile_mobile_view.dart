
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_list_mobile.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_utils.dart';
import 'package:evoke_nexus_app/app/screens/timeline/timeline_screen.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileMobileView extends StatefulWidget {
  final User user;
  Function() onPostClicked;
   ProfileMobileView({super.key, required this.user,required this.onPostClicked});

  @override
  State<ProfileMobileView> createState() => _ProfileMobileViewCardState();
}

class _ProfileMobileViewCardState extends State<ProfileMobileView> {
   TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     final Size size = MediaQuery.of(context).size;
    return Column(children: 
    [
          Center(child: TextButton(child: Text("Timeline"),onPressed: () {
             Navigator.push(
              context,
              MaterialPageRoute(fullscreenDialog: false,
                  builder: (context) =>const TimelineScreen()));
  
          },),)
      
    ]);
    
  }


  void onSearchClicked() {
  }
}
