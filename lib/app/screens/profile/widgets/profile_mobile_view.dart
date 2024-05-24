// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/user_like.dart';
import 'package:evoke_nexus_app/app/models/userhome.dart';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/common/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileMobileView<T> extends ConsumerStatefulWidget {
  final User user;
  final BuildContext context;
  final bool isFromOtherUser;
  // UserLike? otherUser;
  T? otherUser;
  Function() onPostClicked;

  ProfileMobileView({
    Key? key,
    required this.user,
    required this.context,
    required this.isFromOtherUser,
    this.otherUser,
    required this.onPostClicked,
  }) : super(key: key);

  @override
  _ProfileMobileViewState createState() => _ProfileMobileViewState();
}

class _ProfileMobileViewState extends ConsumerState<ProfileMobileView> {
  File? _image;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 20),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  // height: MediaQuery.of(context).size.height,
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          // _profilePicWidget(widget.user, ref),
                          ProfilePic(
                            user: widget.user,
                            size: "LARGE",
                            isFromOtherUser: widget.isFromOtherUser,
                            otherUser: widget.isFromOtherUser
                                ? widget.otherUser
                                : null,
                          ),

                          TextButton(
                            onPressed: () {
                              ref.read(uploadProfileImageProvider(
                                  widget.user.userId));
                            },
                            child: widget.isFromOtherUser == false
                                ? Text(
                                    widget.user.profilePicture != null &&
                                            widget
                                                .user.profilePicture!.isNotEmpty
                                        ? 'Change Profile Picture'
                                        : 'Add Profile Picture',
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : widget.user.identityId ==
                                        widget.otherUser!.identityId
                                    ? Text(
                                        widget.user.profilePicture != null &&
                                                widget.user.profilePicture!
                                                    .isNotEmpty
                                            ? 'Change Profile Picture'
                                            : 'Add Profile Picture',
                                        style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Container(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.isFromOtherUser == false
                                ? widget.user.name
                                : (widget.otherUser is UserLike
                                    ? widget.otherUser!.userName
                                    : (widget.otherUser is Feed
                                        ? (widget.otherUser as Feed).author
                                        : (widget.otherUser is OrgUpdate
                                            ? (widget.otherUser as OrgUpdate)
                                                .author
                                            : (widget.otherUser is Question
                                                ? (widget.otherUser as Question)
                                                    .author
                                                : (widget.otherUser
                                                        is LatestUpdate
                                                    ? (widget.otherUser
                                                            as LatestUpdate)
                                                        .user
                                                        .name
                                                    : (widget.otherUser
                                                            is LatestQuestion
                                                        ? (widget.otherUser
                                                                as LatestQuestion)
                                                            .user
                                                            .name
                                                        : (widget.otherUser
                                                                as UserList)
                                                            .name)))))),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: GoogleFonts.notoSans().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Text(
                            widget.isFromOtherUser == false
                                ? widget.user.role
                                : (widget.otherUser is UserLike
                                    ? widget.otherUser!.title
                                    : (widget.otherUser is Feed
                                        ? (widget.otherUser as Feed).authorTitle
                                        : (widget.otherUser is OrgUpdate
                                            ? (widget.otherUser as OrgUpdate)
                                                .authorTitle
                                            : (widget.otherUser is Question
                                                ? (widget.otherUser as Question)
                                                    .authorTitle
                                                : (widget.otherUser
                                                        is LatestUpdate
                                                    ? (widget.otherUser
                                                            as LatestUpdate)
                                                        .user
                                                        .title
                                                    : (widget
                                                                .otherUser
                                                            is LatestQuestion
                                                        ? (widget.otherUser
                                                                as LatestQuestion)
                                                            .user
                                                            .title
                                                        : (widget.otherUser
                                                                as UserList)
                                                            .title)))))),
                            style: TextStyle(
                              color: const Color(0xff676A79),
                              fontSize: 14.0,
                              fontFamily: GoogleFonts.notoSans().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),

                      // widget.isFromOtherUser == false
                      //     ? Padding(
                      //         padding: const EdgeInsets.all(16.0),
                      //         child: _buildViewProfile(),
                      //       )
                      //     : widget.user.identityId ==
                      //             widget.otherUser!.identityId
                      //         ? Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: _buildViewProfile(),
                      //           )
                      //         : Container(),

                      // widget.isFromOtherUser == false
                      //     ? Padding(
                      //         padding: const EdgeInsets.all(16.0),
                      //         child: _buildViewProfile(),
                      //       )
                      //     : widget.user.identityId ==
                      //             widget.otherUser!.identityId
                      //         ? Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: _buildViewProfile(),
                      //           )
                      //         : widget.user.identityId ==
                      //                 (widget.otherUser is LatestUpdate
                      //                     ? (widget.otherUser as LatestUpdate)
                      //                         .user
                      //                         .identityId
                      //                     : null)
                      //             ? Padding(
                      //                 padding: const EdgeInsets.all(16.0),
                      //                 child: _buildViewProfile(),
                      //               )
                      //             : Container(),

                      widget.isFromOtherUser == false
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildViewProfile(),
                            )
                          : widget.user.identityId ==
                                  widget.otherUser!.identityId
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: _buildViewProfile(),
                                )
                              : widget.user.identityId ==
                                      (widget.otherUser is LatestUpdate
                                          ? (widget.otherUser as LatestUpdate)
                                              .user
                                              .identityId
                                          : (widget.otherUser is LatestQuestion
                                              ? (widget.otherUser
                                                      as LatestQuestion)
                                                  .user
                                                  .identityId
                                              : null))
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: _buildViewProfile(),
                                    )
                                  : Container(),

                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: VerticalCardList(),
                      // ),
                      // const SizedBox(height: 20),
                      // LogoutButton(),
                      // _logout(),
                    ],
                  )),
              // )
            ])));
  }

  Widget _buildViewProfile() {
    safePrint("----------- OTHER USER !!!!! ______________-");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.user.about != null && widget.user.about!.trim().isNotEmpty)
          Text(
            'About Me: ',
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 16.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (widget.user.about != null && widget.user.about!.trim().isNotEmpty)
          Text(
            '${widget.user.about}',
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 14.0, // Font size for `${widget.user.about}`
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight:
                  FontWeight.w500, // Font weight for `${widget.user.about}`
            ),
          ),
        const SizedBox(height: 20),

        //Social Link Dont Remove below Code
        // if (widget.user.socialLinks != null &&
        //     widget.user.socialLinks!.trim().isNotEmpty)
        //   Text(
        //     'Social Link: ',
        //     style: TextStyle(
        //       color: const Color(0xff676A79),
        //       fontSize: 16.0,
        //       fontFamily: GoogleFonts.notoSans().fontFamily,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // if (widget.user.socialLinks != null &&
        //     widget.user.socialLinks!.trim().isNotEmpty)
        //   Text(
        //     '${widget.user.socialLinks}',
        //     style: TextStyle(
        //       color: Colors.blue, // Blue color for links
        //       fontSize: 14.0, // Font size for `${widget.user.socialLinks}`
        //       fontFamily: GoogleFonts.notoSans().fontFamily,
        //       fontWeight: FontWeight
        //           .w500, // Font weight for `${widget.user.socialLinks}`
        //       decoration: TextDecoration.underline, // Add underline to links
        //     ),
        //   ),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Application Version: ',
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 14.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '1.0(1)',
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 16.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.w500,
            ),
          )
        ]),
        //  const SizedBox(height: 10),

//  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text(
//             'Build Number: ',
//             style: TextStyle(
//               color: const Color(0xff676A79),
//               fontSize: 14.0,
//               fontFamily: GoogleFonts.notoSans().fontFamily,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Text(
//             '1.0',
//             style: TextStyle(
//               color: const Color(0xff676A79),
//               fontSize: 16.0,
//               fontFamily: GoogleFonts.notoSans().fontFamily,
//               fontWeight: FontWeight.w500,
//             ),
//           )
//         ]),

        // _logout(),
        const SizedBox(height: 90),
      ],
    );
  }

  Widget _profilePicWidget_WORKING(User user, WidgetRef ref) {
    final avatarText = getAvatarText(user.name);

    final profileThumbnailAsyncValue = ref.watch(profileThumbnailProvider(
        widget.isFromOtherUser == false
            ? user.profilePicture ?? ""
            : widget.otherUser!.profilePicture ?? ""));

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

  Widget _profilePicWidget(User user, WidgetRef ref) {
    final String? authorName = user.name;
    if (authorName == null || authorName.isEmpty) {
      return CircleAvatar(
          backgroundColor: Colors.transparent, radius: 80.0, child: Text('NO'));
    }
    // final avatarText = getAvatarText(item.author!);
    final avatarText = getAvatarText(authorName);

    if (user.profilePicture == null || user.profilePicture == "") {
      return CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 80.0,
          child: Text(avatarText));
    } else {
      final profilePicAsyncValue = ref.watch(profileThumbnailProvider(
          widget.isFromOtherUser == false
              ? user.profilePicture ?? ""
              : widget.otherUser!.profilePicture ?? ""));

      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            if (_isProperImageUrl(imageUrl)) {
              return Center(
                  child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(imageUrl),
                radius: 80.0,
              ));
            } else {
              return CircleAvatar(
                radius: 80.0,
                child: Text(
                  avatarText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w600),
                ),
              );
            }
          } else {
            return CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 80.0,
                child: Text(avatarText));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 80.0,
            width: 80.0,
            child: CircularProgressIndicator(
              semanticsLabel: 'Circular progress indicator',
            ),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 80.0,
            child: Text(avatarText)),
      );
    }
  }

  bool _isProperImageUrl(String imageUrl) {
    // Check if the image URL contains spaces in the filename
    if (imageUrl.contains('%20')) {
      return false;
    }
    return true;
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

  Widget _logout() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // bool confirmed = false;

          // Show a confirmation dialog
          await showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text("Confirmation"),
                content: const Text("Are you sure you want to logout?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false); // No
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true); // Yes
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          ).then((value) {
            // The user's choice will be available in the 'value' variable
            if (value == true) {
              // User clicked "Yes," proceed with the logout
              doLogout();
              _showToast(context);
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0, // Set the background color to transparent
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            color: const Color(0xffB54242),
            fontSize: 20.0,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void doLogout() async {
    await signOutCurrentUser();
  }

  Future<void> signOutCurrentUser() async {
    final SignOutResult result = await Amplify.Auth.signOut(
      options: const SignOutOptions(globalSignOut: true),
    );
    safePrint('result: $result');

    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
      // Navigator.popUntil(context, ModalRoute.withName("/${AppRoute.login.name}"));
      // GoRouter.of(context).goNamed('/${AppRoute.login.name}');

      setState(() {
        safePrint('Inside setState');

        GoRouter.of(context).goNamed('/');
        safePrint('After /login');

        // Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);

        // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return const LoginScreen();
        //     },
        //   ),
        //   (_) => false,
        // );
      });
      safePrint('Outside setState');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  doLogout_old() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');

      // GoRouter.of(context).goNamed('/${AppRoute.login.name}');

      Navigator.popUntil(context, ModalRoute.withName("/"));

// Navigator.pushNamedAndRemoveUntil(context, '/${AppRoute.login.name}', (Route<dynamic> route) => false);

      // widget.context.replaceNamed(AppRoute.login.name);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      //                         builder: (context) => const LoginScreen()), (route) => false);

//  showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Dialog(
//                         child: Text('Dialog.'),
//                       );
//                     });

      // setState(() {
      //   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) {
      //         return const LoginScreen();
      //       },
      //     ),
      //     (_) => false,
      //   );

      // });
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
          height: 70,
          child: Text('In Progress'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
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

  VerticalCardList({super.key});

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

  const VerticalCard({super.key, required this.title, required this.icon});

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
                  if (title == "TimeLine" ||
                      title == "Notifications" ||
                      title == "Settings") {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         fullscreenDialog: false,
                    //         builder: (context) => const TimelineScreen()));

                    _showToast(context);
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

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
          height: 70,
          child: Text('In Progress'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

//Remove browser redirection after signOut() in app using social sign in #401 Closed /https://github.com/aws-amplify/amplify-flutter/issues/401
