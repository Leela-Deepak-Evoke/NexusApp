import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MobileAppNavTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canPost;
  final double height;
   Function()? onPostClicked;

   MobileAppNavTopBar(
      {super.key, required this.canPost,  this.height = kToolbarHeight, required this.onPostClicked});
  @override
  Widget build(BuildContext context) {
    return AppBar(
          backgroundColor: const Color(ColorConstants.topbarbg),
          foregroundColor: Colors.white,
          
          title: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Padding(padding: EdgeInsets.all(0),child: Image.asset("assets/images/Nexus.png",width: 30,height: 30,fit: BoxFit.fill,)),
            SizedBox(width: 5,),
            Text("Nexus",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),)
           ],
          ),
          actions: [
          canPost ? SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () {
                  onPostClicked!();
                },
                icon: Image.asset('assets/images/create-post.png'),
                  ),
            ):SizedBox(),
            const SizedBox(width: 20,)
          ],
    );
  }
 
 @override
  Size get preferredSize => Size.fromHeight(height);
}



