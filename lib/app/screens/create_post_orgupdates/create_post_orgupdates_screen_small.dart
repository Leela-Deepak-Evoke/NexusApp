import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/create_post_orgupdates/widgets/orgupdates_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/common/round_action_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostOrgUpdatesScreenSmall extends ConsumerStatefulWidget {
  OrgUpdate? orgUpdateItem; // Add a parameter for the Feed item
   bool? isEditOrgUpdate;

  CreatePostOrgUpdatesScreenSmall({Key? key, this.orgUpdateItem, this.isEditOrgUpdate}) : super(key: key);

  // const CreatePostFeedScreenSmall({super.key});

  @override
  ConsumerState<CreatePostOrgUpdatesScreenSmall> createState() =>
      _CreatePostOrgUpdatesScreenSmallState();
}

class _CreatePostOrgUpdatesScreenSmallState
    extends ConsumerState<CreatePostOrgUpdatesScreenSmall> {
  @override
  Widget build(BuildContext context) {
    final orgUpdateItem = widget.orgUpdateItem;

    String rightActionTitle = 'Select Category';
    GlobalKey<OrgUpdatesMobileViewMobileViewState> childKey = GlobalKey();

    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
        return MobileLayout(
          title: "Post OrgUpdates",
          user: data,
          hasBackAction: true,
          hasRightAction: true,
          topBarButtonAction: () {},
          backButtonAction: () {
            Navigator.pop(context);
          },
          rightChildWiget: RoundedActionView(
              onPressed: () {
                childKey.currentState?.onCategorySelected();
              },
              title: rightActionTitle),
          child: OrgUpdatesMobileView(
              key: childKey,
              user: data,
              slectedCategory: rightActionTitle,
              orgUpdateItem: orgUpdateItem, isEditOrgUpdate: widget.isEditOrgUpdate),
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
