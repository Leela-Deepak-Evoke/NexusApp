import 'dart:async';

import 'package:evoke_nexus_app/app/screens/tab_bar/feeds_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/forums_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/orgupdates_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/profile_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_utils.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_menu_item.dart';
import 'package:flutter/material.dart';

import '../../../app_router.dart';

final TabBarNotifier _tabBarNotifier = TabBarNotifier();

class TabBarHandler extends StatefulWidget {
  // TabBarHandler({Key? key, required this.logoutAction}) : super(key: key);
  // Function() logoutAction;

  Function() logoutAction;
  final BuildContext context;
   TabBarHandler({Key? key, required this.logoutAction, required this.context})
      : super(key: key);

  static const String route = '/';

  @override
  State<TabBarHandler> createState() => _TabBarHandlerState();
}

class _TabBarHandlerState extends State<TabBarHandler> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuItemlist = <TabMenuItem>[
      TabMenuItem(
          Icons.rss_feed,
          'Feeds',
          FeedsTabMenu(
            router: feedsRouter,
          )),
      TabMenuItem(Icons.forum, 'Fourms', ForumsTabMenu(router: forumsRouter)),
      TabMenuItem(
          Icons.update,
          'OrgUpdates',
          OrgUpdatesTabMenu(
            router: orgupdatesRouter,
          )),
      TabMenuItem(
          Icons.person,
          'Profile',
          ProfileTabMenu(logoutAction: widget.logoutAction, context: widget.context, router: profileRouter)
          // ProfileTabMenu(
          //   router: profileRouter,
          //   logoutAction: widget.logoutAction,
          // )
          ),
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
                      menuItemlist[i].child
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: TabBarMenu(
                      model: _tabBarNotifier,
                      onItemTapped: (x) {
                        if (_tabBarNotifier.index == x) {
                          _tabBarNotifier.popAllRoutes(x);
                        } else {
                          _tabBarNotifier.index = x;
                        }
                      },
                      menuItems: menuItemlist),
                ),
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
    switch (_tabBarNotifier.index) {
      case -1:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 0:
        if (feedkey.currentState != null && feedkey.currentState!.canPop()) {
          feedkey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 1:
        if (fourmskey.currentState != null &&
            fourmskey.currentState!.canPop()) {
          fourmskey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 2:
        if (orgupdateskey.currentState != null &&
            orgupdateskey.currentState!.canPop()) {
          orgupdateskey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 3:
        if (profileKey.currentState != null &&
            profileKey.currentState!.canPop()) {
          profileKey.currentState!.pop();
          exitingApp = false;
        }
        break;
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
