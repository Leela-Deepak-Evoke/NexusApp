import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_web_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:evoke_nexus_app/app/widgets/layout/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class OrgUpdatesScreenSmall extends ConsumerStatefulWidget {
  const OrgUpdatesScreenSmall({super.key});
  @override
  ConsumerState<OrgUpdatesScreenSmall> createState() =>
      _OrgUpdatesScreenSmall();
}

class _OrgUpdatesScreenSmall extends ConsumerState<OrgUpdatesScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data)
       {
        return MobileLayout(
          title: 'Organization Updates',
          user: data,
          child: OrgUpdateMobileView(user: data, onPostClicked: () {  },),
          hasBackAction: false,
          hasRightAction: (data.role == 'Member') ? false : true,
          topBarButtonAction: () {
            
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
