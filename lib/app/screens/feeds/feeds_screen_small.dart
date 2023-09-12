import 'package:evoke_nexus_app/app/provider/authentication_provider.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_utils.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_routes.dart';

class FeedsScreenSmall extends ConsumerStatefulWidget {
  const FeedsScreenSmall({super.key});
  @override
  ConsumerState<FeedsScreenSmall> createState() => _FeedsScreenSmallState();
}

class _FeedsScreenSmallState extends ConsumerState<FeedsScreenSmall> {
  Widget build(BuildContext context) {
    // final userAsyncValue = ref.watch(fetchUserProvider);
    // return userAsyncValue.when(
    //   data: (data) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: 
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Container(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset('assets/images/Nexus.png',fit: BoxFit.fill,width: 50,height: 50,),
                    Spacer(flex: 10,),
                    const Text('Nexus',style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),)
                   ,Flex(direction: Axis.horizontal)
                  ],
                ),
              ),
            ),
            backgroundColor: Color(0XFF8E54E9),
            actions: [
              Padding(padding: EdgeInsets.fromLTRB(0,0,0,0),child: Image.asset('assets/images/create-post.png',width: 22,height: 22,))
            ,SizedBox(width: 20,),
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Center(
              child :
              Row(
                children: [
                  Text("feeds"),
                  TextButton(onPressed: () =>
                  {
                    context.goNamed(AppRoute.forum.name)
                  }
                  , child: Text("Next"))

                ],
              )
            ),
          ),
        );
        
      // },
      // loading: () => const Center(
      //   child: SizedBox(
      //     height: 50.0,
      //     width: 50.0,
      //     child: CircularProgressIndicator(),
      //   ),
      // ),
      // error: (error, stack) {
      //   // Handle the error case if needed
      //   return Text('An error occurred: $error');
      // },
  //  );
  }
}
