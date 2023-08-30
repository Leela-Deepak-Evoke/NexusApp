import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_filter_card.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_list.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/post_org_updates_fab.dart';
import 'package:evoke_nexus_app/app/widgets/common/common_search_bar.dart';
import 'package:flutter/material.dart';

class OrgUpdatesWebView extends StatefulWidget {
  final User user;
  const OrgUpdatesWebView({super.key, required this.user});

  @override
  State<OrgUpdatesWebView> createState() => _OrgUpdatesWebViewCardState();
}

class _OrgUpdatesWebViewCardState extends State<OrgUpdatesWebView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 600,
          child: OrgUpdateList(user: widget.user),
        ),
        SizedBox(
          width: 275,
          child: Column(
            children: [
              const Align(alignment: Alignment.topRight, child: SearchCard()),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: OrgUpdatesFilterCard(),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 130,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ['Group', 'Leader'].contains(widget.user.role)
                      ? PostOrgUpdateFAB(user: widget.user)
                      : const SizedBox(height: 5, width: 5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
