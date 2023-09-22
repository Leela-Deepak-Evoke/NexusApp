import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/widgets/postfeed_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostFeedScreenSmall extends ConsumerStatefulWidget {
  const CreatePostFeedScreenSmall({super.key});
  
  @override
  ConsumerState<CreatePostFeedScreenSmall> createState() => _CreatePostFeedScreenSmallState();
}

class _CreatePostFeedScreenSmallState extends ConsumerState<CreatePostFeedScreenSmall> {
  @override
  Widget build(BuildContext context) {
    String rightActionTitle = 'Select Category';
      GlobalKey<PostFeedsMobileViewState> childKey = GlobalKey();

    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
         return    MobileLayout(
          title: "Post Feed",
          user: data,
          hasBackAction: true,
          hasRightAction: true,

          topBarButtonAction: () {  

          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          rightChildWiget: RoundedActionView(onPressed:() {
            childKey.currentState?.onCategorySelected();
          }
          , title: rightActionTitle),
          child: PostFeedsMobileView(key: childKey, user: data,slectedCategory:  rightActionTitle,),

        );
  }, 
    loading: () => const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return Text('An error occurred: $error');
      },
  );
  }

  }


class RoundedActionView extends StatelessWidget {
  Function() onPressed;
  final String title;
  RoundedActionView({super.key,required this.onPressed ,required this.title});
  
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: 
      Center(
        child: SizedBox(
          height: 30,
          width: 150,
          child: 
          InkWell(
             onTap:() {
               onPressed();
             },
          child: Container(
            child: Center(
             child:   Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white
              ),

            )
            )
           ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), // Adjust the radius to make it rounded
              border: Border.all(
                color: Colors.white, // Set your desired border color
                width: 2.0, // Set your desired border width
              ),
              
          )

          )

        ),
      )
      )
    );
    
   
  }
}
