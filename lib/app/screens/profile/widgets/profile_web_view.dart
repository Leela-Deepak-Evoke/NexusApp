import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/edit_profile.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/profile_filter_card.dart';
import 'package:flutter/material.dart';

class ProfileWebView extends StatefulWidget {
  final User user;
  const ProfileWebView({super.key, required this.user});

  @override
  State<ProfileWebView> createState() => _ProfileWebView();
}

class _ProfileWebView extends State<ProfileWebView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 600,
          child: UserForm(user: widget.user, isFromWelcomeScreen: false),
        ),
        const SizedBox(
          width: 275,
          child: Align(
            alignment: Alignment.centerRight,
            child: ProfileFilterCard(),
          ),
        ),
      ],
    );
  }
}
