import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen.dart';
import 'package:evoke_nexus_app/app/screens/review/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileCustomAppbar extends ConsumerStatefulWidget {
  const MobileCustomAppbar({Key? key}) : super(key: key);
  @override
  MobileCustomAppbarState createState() => MobileCustomAppbarState();
}

class MobileCustomAppbarState extends ConsumerState<MobileCustomAppbar> {
// class MobileCustomAppbar extends StatelessWidget {
//   const MobileCustomAppbar({super.key});
  String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    User? user; // Nullable User
    final userAsyncValue = ref.watch(fetchUserProvider);
    String avatarText = "";

    userAsyncValue.when(
      data: (data) {
        user = data;
        final String name = user!.name;
        avatarText = getAvatarText(name);
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {},
    );

    final ValueNotifier<bool> appbarShadow = ValueNotifier<bool>(false);
    return Positioned(
      left: 0.0,
      right: 16.0,
      top: 0.0,
      child: ValueListenableBuilder<bool>(
          valueListenable: appbarShadow,
          builder: (context, value, child) {
            return AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Image.asset(
                  'assets/images/Nexus_logo-artwork.png',
                  width: 35,
                  height: 35,
                ),
                onPressed: null, // Disable user interaction
              ),
              titleSpacing: 0,
              centerTitle: false,
              title: Text(
                "NEXUS", //EVOKE NEXUS
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              actions: [
              if (user != null && (user!.role != "Group" || user!.role != "Leader"))
                IconButton(
                    icon: Image.asset(
                      'assets/images/viewIcon.png',
                      width: 28,
                      height: 28,
                    ),
                    onPressed: () {
                      // print("Hello");
                      //  _showToast(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  ReviewScreen()),
                      );
                    },
                  ),
                
                SizedBox(width: 24),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xffF2722B),
                      child: Text(avatarText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                )
              ],
              elevation: value ? 2.0 : 0.0,
            );
          }),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
          height: 70,
          child: Text('In Progress Evita'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  final String title;
  final bool hasBackAction;
  final bool hasRightAction;
  final Widget? rightChildWiget;
  final bool showSearchIcon; // Add this flag
  final bool showSortingIcon; // Add this flag
  final Function() topBarButtonAction;
  final Function() backButtonAction;
  final Function() topBarSearchButtonAction;
  final Function() topBarSortingButtonAction;

  const CustomAppbar({
    super.key,
    required this.title,
    required this.hasBackAction,
    required this.hasRightAction,
    required this.showSearchIcon, // Add this line
    required this.showSortingIcon, // Add this line
    required this.topBarButtonAction,
    required this.backButtonAction,
    required this.rightChildWiget,
    required this.topBarSearchButtonAction,
    required this.topBarSortingButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> appbarShadow = ValueNotifier<bool>(false);
    return Positioned(
      left: 0.0,
      right: 16.0,
      top: 0.0,
      child: ValueListenableBuilder<bool>(
          valueListenable: appbarShadow,
          builder: (context, value, child) {
            return AppBar(
              backgroundColor: Colors.transparent,
              leading: hasBackAction
                  ? IconButton(
                      icon: Image.asset(
                        'assets/images/back.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        backButtonAction();
                      },
                    )
                  : IconButton(
                      icon: Image.asset(
                        'assets/images/Nexus_logo-artwork.png',
                        width: 35,
                        height: 35,
                      ),
                      // onPressed: () {},
                      onPressed: null, // Disable user interaction
                    ),

              titleSpacing: 0,
              centerTitle: false,
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              actions: [
                hasRightAction
                    ? ((rightChildWiget != null)
                        ? SizedBox(
                            height: 30,
                            width: 150,
                            child: rightChildWiget!,
                          )
                        : Row(
                            children: [
                              if (showSearchIcon)
                                IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ), // Add your search icon here
                                  onPressed: () {
                                    topBarSearchButtonAction();
                                  },
                                ),
                              //  IconButton(
                              //   icon: Icon(Icons
                              //       .sort, color: Colors.white,), // Add your search icon here
                              //   onPressed: () {
                              //    topBarSortingButtonAction();
                              //   },
                              // ),

                              // IconButton(
                              //   icon: Image.asset(
                              //     'assets/images/white_add-48.png',
                              //     width: 24,
                              //     height: 24,
                              //   ),
                              //   onPressed: () {
                              //     topBarButtonAction();
                              //   },
                              // ),

                              IconButton(
                                icon: Image.asset(
                                  // title == 'Profile'
                                  (title == 'Profile' ||
                                          title == 'User Profile')
                                      ? 'assets/images/viewIcon.png'
                                      : 'assets/images/white_add-48.png',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: () {
                                  topBarButtonAction();
                                },
                              ),
                            ],
                          ))
                    : showSearchIcon
                        ? Row(children: [
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ), // Add your search icon here
                              onPressed: () {
                                topBarSearchButtonAction();
                              },
                            ),
                            // IconButton(
                            //   icon: Icon(Icons
                            //       .sort, color: Colors.white,), // Add your search icon here
                            //   onPressed: () {
                            //    topBarSortingButtonAction();
                            //   },
                            // ),
                          ])
                        : const SizedBox(), //,
              ],
              // actions: [

              //     hasRightAction ?
              //    ((rightChildWiget != null) ?
              //     SizedBox(
              //       height: 30,
              //       width: 150,
              //       child: rightChildWiget!) :
              //    IconButton(
              //   icon: Image.asset(
              //     'assets/images/create-post.png',
              //     width: 24,
              //     height: 24,
              //   ),
              //   onPressed: () {
              //     topBarButtonAction();
              //   },
              // ) )
              // : SizedBox()
              // ],
              elevation: value ? 2.0 : 0.0,
            );
          }),
    );
  }
}
