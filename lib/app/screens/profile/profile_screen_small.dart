import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tab_bar/tab_bar_utils.dart';

class ProfileScreenSmall extends ConsumerWidget {
  const ProfileScreenSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
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
