
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/questions_list_mobile.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_header_view.dart';
import 'package:flutter/material.dart';

class ForumMobileView extends StatefulWidget {
  final User user;
  Function() onPostClicked;
   ForumMobileView({super.key, required this.user,required this.onPostClicked});

  @override
  State<ForumMobileView> createState() => _ForumMobileViewCardState();
}

class _ForumMobileViewCardState extends State<ForumMobileView> {
   TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     final Size size = MediaQuery.of(context).size;
    return Column(children: [

      // SearchHeaderView(name: "Forum", searchController: _searchController, size: size ,onSearchClicked: onSearchClicked),
            // SearchHeaderView(onIconClicked: onSearchClicked),

        Expanded(
          child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10), 
            child: QuestionsListMobile(user: widget.user),
          ),
        ),
    ]);
    
  }


  void onSearchClicked() {
    _showToast(context);
  }

   void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
              height:70,
              child: Text('In Progress'),
        ),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
