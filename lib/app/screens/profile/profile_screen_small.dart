import 'package:evoke_nexus_app/app/widgets/common/mobile_nav_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../forum/widgets/forum_mobile_view.dart';
import '../tab_bar/tab_bar_utils.dart';

class ProfileScreenSmall extends ConsumerStatefulWidget {
   const ProfileScreenSmall({super.key});

 @override
  ConsumerState<ProfileScreenSmall> createState() => _ProfileScreenSmallState();
}

class _ProfileScreenSmallState extends ConsumerState<ProfileScreenSmall> {

  @override
  Widget build(BuildContext context) {

   void postcliked()
  {

  }


    return Scaffold(
      appBar: MobileAppNavTopBar(canPost: true, onPostClicked: postcliked),
      
      body: 
       Container(
      color: Colors.amber,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile" , style:  TextStyle(color: Colors.black),),
            TextButton(onPressed:() {
                navigate(context, '/profile/profileDetails',
                      isRootNavigator: false,
                      arguments: {'id': '3'});
              
            },
            child: Text("next" , style:  TextStyle(color: Colors.black)))
          ],
        ),
      ),
    ),
    );
  }
}
