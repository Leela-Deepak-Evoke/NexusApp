import 'dart:io';

import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/timeline/timeline_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/generic_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMobileView extends ConsumerStatefulWidget {
  final User user;
  Function() onPostClicked;

  ProfileMobileView({
    super.key,
    required this.user,
    required this.onPostClicked,
  });

  @override
  _ProfileMobileViewState createState() => _ProfileMobileViewState();
}

class _ProfileMobileViewState extends ConsumerState<ProfileMobileView> {
  File? _image; // Variable to store the selected image

  @override
  Widget build(BuildContext context) {
    // Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 40), // Adjust the height as needed
            _profilePicWidget(widget.user, ref),
            TextButton(
              onPressed: () {
                
                ref.read(uploadProfileImageProvider(widget.user.userId));
          
              },
              child: const Text('Change Profile Picture',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  )),
            ),

            const SizedBox(height: 10),
            Text(
              widget.user.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.role,
              style: TextStyle(
                color: Color(0xff676A79),
                fontSize: 14.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: VerticalCardList(),
        ),
        const SizedBox(height: 20),
        LogoutButton(),
      ],
    );
  }

  Widget _profilePicWidget(User user, WidgetRef ref) {
    final avatarText = getAvatarText(user.name);

    final profileThumbnailAsyncValue =
        ref.watch(profileThumbnailProvider(user.profilePicture!));

    return profileThumbnailAsyncValue.when(
      data: (data) {
        if (data != null) {
          return Center(
              child: CircleAvatar(
            backgroundImage: NetworkImage(data),
            radius: 80.0,
          ));
        } else {
          // Render a placeholder or an error image
          return CircleAvatar(radius: 80.0, child: Text(avatarText));
        }
      },
      loading: () => const Center(
        child: SizedBox(
          height: 80.0,
          width: 80.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return CircleAvatar(radius: 80.0, child: Text(avatarText));
      },
    );
  }

  String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }

}

class VerticalCardList extends StatelessWidget {
  final List<String> cardTitles = [
    'TimeLine',
    'Notifications',
    'Settings',
    // Add more card titles as needed
  ];

  final List<IconData> icons = [
    Icons.timeline,
    Icons.notifications,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(cardTitles.length, (index) {
        return VerticalCard(
          title: cardTitles[index],
          icon: icons[index],
        );
      }),
    );
  }
}

class VerticalCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const VerticalCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  if (title == "TimeLine") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: false,
                            builder: (context) => const TimelineScreen()));
                  }
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  minLeadingWidth: 8,
                  leading: Icon(icon),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: GoogleFonts.notoSans().fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0, // Set the background color to transparent
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            color: Color(0xffB54242),
            fontSize: 20.0,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}



