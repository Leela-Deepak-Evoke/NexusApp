import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/questions_list_mobile.dart';
import 'package:evoke_nexus_app/app/widgets/common/mobile_nav_topbar.dart';
import 'package:flutter/material.dart';

class ForumMobileView extends StatefulWidget {
  final User user;
  Function() onPostClicked;
   ForumMobileView({super.key, required this.user,required this.onPostClicked});

  @override
  State<ForumMobileView> createState() => _ForumMobileViewCardState();
}

class _ForumMobileViewCardState extends State<ForumMobileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  MobileAppNavTopBar(canPost: true,onPostClicked : widget.onPostClicked),
      body: QuestionsListMobile(user: widget.user),
    );


    // Row(
    //   children: [
    //     SizedBox(s
    //       width: MediaQuery.of(context).size.width - 600,
    //       child: QuestionsList(user: widget.user),
    //     ),
    //     SizedBox(
    //       width: 275,
    //       child: Column(
    //         children: [
    //           const Align(alignment: Alignment.topRight, child: SearchCard()),
    //           const Align(
    //             alignment: Alignment.centerRight,
    //             child: ForumFilterCard(),
    //           ),
    //           SizedBox(
    //             height: 40,
    //             child: Align(
    //               alignment: Alignment.bottomRight,
    //               child: PostForumFAB(user: widget.user),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
