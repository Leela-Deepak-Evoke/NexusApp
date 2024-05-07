import 'dart:async';

import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/feeds_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/forums_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/orgupdates_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_utils.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_menu_item.dart';
import 'package:flutter/material.dart';
import '../../../app_router.dart';

final TabBarNotifier _tabBarNotifier = TabBarNotifier();

class TabBarHandler extends StatefulWidget {
  Function() logoutAction;
  User? user;

  final BuildContext? rootScreenMobileContext; // Add this parameter


  TabBarHandler(
      {Key? key,
      required this.logoutAction,
      this.rootScreenMobileContext,
      required this.user})
      : super(key: key);

  static const String route = '/';

  @override
  State<TabBarHandler> createState() => _TabBarHandlerState();
}

class _TabBarHandlerState extends State<TabBarHandler> {
      GlobalKey<HomeScreenSmallState> childKey = GlobalKey();

  @override
  void initState() {
    super.initState();

//DONT REMOVE THIS LINES IS FOR IF PROFILE BUTTON IS IN TAB, WHEN 1ST TIME USER COMES
    // if (widget.user!.lastLoginAt != null || widget.user!.status != "NEW") {
    //   _tabBarNotifier.index = 0;
    // } else {
    //   _tabBarNotifier.index = 4;
    // }

    _tabBarNotifier.index = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshScreen() {
    setState(() {
      // Add your logic to refresh the screen here
      // For example, you can trigger a rebuild of the widget

      childKey.currentState?.retry();

    });
  }
  @override
  Widget build(BuildContext context) {

    final menuItemlist = <TabMenuItem>[
      TabMenuItem(
          Icons.home,
          'Home',
          FeedsTabMenu(
            router: homeRouter,
          )),
      TabMenuItem(
          Icons.rss_feed,
          'Feeds',
          FeedsTabMenu(
            router: feedsRouter,
          )),
      TabMenuItem(Icons.forum, 'Forum', ForumsTabMenu(router: forumsRouter)),
      TabMenuItem(
          Icons.update,
          'OrgUpdates',
          OrgUpdatesTabMenu(
            router: orgupdatesRouter,
          )),
      // TabMenuItem(
      //     Icons.person,
      //     'Profile',
      //     ProfileTabMenu(
      //         logoutAction: widget.logoutAction,
      //         rootScreenMobileContext: widget.rootScreenMobileContext,
      //         router: profileRouter)),
    ];

    return Material(
      child: AnimatedBuilder(
          animation: _tabBarNotifier,
          builder: (context, snapshot) {
            return Stack(
              children: [
                IndexedStack(
                  index: _tabBarNotifier.index,
                  children: [
                    for (int i = 0; i < menuItemlist.length; i++)
                      menuItemlist[i].child,
                                      // Add HomeScreenSmall as one of the children
                HomeScreenSmall(key: childKey),

                  ],
                ),
            //      if (_tabBarNotifier.index == 0) // Check if Home tab is selected
            //  HomeScreenSmall(key: childKey),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: TabBarMenu(
                      model: _tabBarNotifier,
                      rootScreenMobileContext: widget.rootScreenMobileContext,
                      onItemTapped: (x) {
                        if (_tabBarNotifier.index == x) {
                          _tabBarNotifier.popAllRoutes(x);
                        } else {
                          _tabBarNotifier.index = x;

                          //NEWLY ADDED CODE
                       // If the tab containing HomeScreenSmall is tapped, refresh the screen
//                       if (x == 0) {
//                         // Call the refresh method on the instance of HomeScreenSmall
// // refreshScreen();
//                 HomeScreenSmall(key: childKey);

//                       }
                        }
                      },
                      menuItems: menuItemlist, refreshCallback: refreshScreen),

                ),
                 // Add HomeScreenSmall here as a child of the Stack
           
              ],
            );
          }),
    );
  }

  logoutAction() {
    widget.logoutAction;
  }
}

class TabBarNotifier extends ChangeNotifier {
  User? user;
  bool fromWelcomeScreen = false;

  int _index = 0;
  int get index => _index;
  bool _hideBottomTabBar = false;
  late BuildContext context;

  set index(int x) {
    _index = x;
    notifyListeners();
  }

  bool get hideBottomTabBar => _hideBottomTabBar;
  set hideBottomTabBar(bool x) {
    _hideBottomTabBar = x;
    notifyListeners();
  }

  FutureOr<bool> onBackButtonPressed() async {
    bool exitingApp = true;
    _tabBarNotifier.index; //// Use _index instead of _tabBarNotifier.index
    switch (_index) {
      case -1:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 0:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 1:
        if (feedkey.currentState != null && feedkey.currentState!.canPop()) {
          feedkey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 2:
        if (fourmskey.currentState != null &&
            fourmskey.currentState!.canPop()) {
          fourmskey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 3:
        if (orgupdateskey.currentState != null &&
            orgupdateskey.currentState!.canPop()) {
          orgupdateskey.currentState!.pop();
          exitingApp = false;
        }
        break;
      // case 4:
      //   if (profileKey.currentState != null &&
      //       profileKey.currentState!.canPop()) {
      //     profileKey.currentState!.pop();
      //     exitingApp = false;
      //   }
      //   break;
      default:
        return false;
    }
    if (exitingApp) {
      return true;
    } else {
      return false;
    }
  }

  void popAllRoutes(int index) {
    switch (index) {
      case -1:
        if (homeKey.currentState!.canPop()) {
          homeKey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 0:
        // GoRouter router = GoRouter.of(context);
        // router.go('/feeds');
        return;
      case 1:
        if (feedkey.currentState!.canPop()) {
          feedkey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 2:
        if (fourmskey.currentState!.canPop()) {
          fourmskey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 3:
        if (orgupdateskey.currentState!.canPop()) {
          orgupdateskey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      // case 3:
      //   if (profileKey.currentState!.canPop()) {
      //     profileKey.currentState!.popUntil((route) => route.isFirst);
      //   }
      //   return;
      default:
        break;
    }
  }

//DONT REMOVE THIS CODE
  void popAllRoutes_OLD(int index) {
    switch (index) {
      case -1:
        if (homeKey.currentState!.canPop()) {
          homeKey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 0:
        // GoRouter router = GoRouter.of(context);
        // router.go('/feeds');
        return;
      case 1:
        if (fourmskey.currentState!.canPop()) {
          fourmskey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 2:
        if (orgupdateskey.currentState!.canPop()) {
          orgupdateskey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 2:
        if (profileKey.currentState!.canPop()) {
          profileKey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      default:
        break;
    }
  }
}
