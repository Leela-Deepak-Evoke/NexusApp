import 'package:evoke_nexus_app/app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileCustomAppbar extends StatelessWidget {
  const MobileCustomAppbar({super.key});

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
              // leading: Image.asset(
              //   'assets/images/Nexus_logo-artwork.png',
              //    width: 24,
              //       height: 24,
              // ),
              // titleSpacing: 0,
              // centerTitle: false,
              // title: Text(
              //   "NEXUS",  //EVOKE NEXUS
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 16.0,
              //     fontFamily: GoogleFonts.poppins().fontFamily,
              //     fontWeight: FontWeight.w600,
              //   ),
              //   textAlign: TextAlign.left,
              // ), 
              // leading:   IconButton(
              //     icon: Image.asset(
              //       'assets/images/Nexus_logo-artwork.png',
              //       // width: 24,
              //       // height: 24,
              //     ),
              //     onPressed: () {},
              //   ),   
               leading: IconButton(
                      icon: Image.asset(
                        'assets/images/Nexus_logo-artwork.png',
                        width: 35,
                        height: 35,
                      ),
                      onPressed: () {},
                    ),  
                    titleSpacing: 0,
              centerTitle: false,
              title: Text(
                "NEXUS",  //EVOKE NEXUS
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),    
              actions: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/notifications.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {_showToast(context);},
                ),
                InkWell(
                  onTap: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );

  // Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         fullscreenDialog: true,
  //         // builder: (context) => CreatePostFeedScreen(feedItem: item, isEditFeed: true),
  //         builder: (context) => ProfileScreen(),
  //       ),
  //     );

                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xffF2722B),
                      child: Text('SM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
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

  CustomAppbar({
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
                      onPressed: () {},
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
                                  icon: Icon(Icons
                                      .search, color: Colors.white,), // Add your search icon here
                                  onPressed: () {
                                   topBarSearchButtonAction();
                                  },
                                )
                                ,
                                //  IconButton(
                                //   icon: Icon(Icons
                                //       .sort, color: Colors.white,), // Add your search icon here
                                //   onPressed: () {
                                //    topBarSortingButtonAction();
                                //   },
                                // ),

                              IconButton(
                                icon: Image.asset(
                                  'assets/images/create-post.png',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: () {
                                  topBarButtonAction();
                                },
                              ),
                            ],
                          ))
                    :  showSearchIcon ? Row(
                            children: [
                                IconButton(
                                  icon: Icon(Icons
                                      .search, color: Colors.white,), // Add your search icon here
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
                                ]) : SizedBox(),    //,
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
