import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/edit_profile.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/profile_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreenSmall extends ConsumerStatefulWidget {
final BuildContext context;

const ProfileScreenSmall({
    super.key,
    required this.context,
  });


  //  const ProfileScreenSmall({super.key});

 @override
  ConsumerState<ProfileScreenSmall> createState() => _ProfileScreenSmallState();
}

class _ProfileScreenSmallState extends ConsumerState<ProfileScreenSmall> {

  @override
   Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        
        return MobileLayout(
          title: 'Profile',
          user: data,
          child:ProfileMobileView(user: data, context: widget.context, isFromOtherUser: false, onPostClicked: () {
            
          },),
          hasBackAction: false,
          hasRightAction: true,
          topBarButtonAction: () {
              Navigator.push(
              context,
              MaterialPageRoute(fullscreenDialog: true,
                  builder: (context) => UserForm(user: data)));
          },
          backButtonAction: () {
            Navigator.pop(context);
          },
        
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
