import 'package:evoke_nexus_app/app/screens/home/home_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_handler.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_menu_item.dart';
import 'package:flutter/material.dart';

class TabBarMenu extends StatefulWidget {
  final BuildContext? rootScreenMobileContext; // Add this parameter
  final VoidCallback refreshCallback; // Add this parameter

  const TabBarMenu(
      {Key? key,
      required this.model,
      required this.menuItems,
      required this.rootScreenMobileContext,
      required this.onItemTapped,
      required this.refreshCallback})
      : super(key: key);
  final List<TabMenuItem> menuItems;
  final TabBarNotifier model;
  final Function(int) onItemTapped;

  @override
  _TabBarMenuState createState() => _TabBarMenuState();
}

class _TabBarMenuState extends State<TabBarMenu> {
        // GlobalKey<HomeScreenSmallState> childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  // void refreshScreen() {
  //   setState(() {
  //     // Add your logic to refresh the screen here
  //     // For example, you can trigger a rebuild of the widget

  //     childKey.currentState?.retry();

  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.model.index,
      onTap: (x) {
        // if (x == 3) {
        //    GoRouter.of(context).go('/${AppRoute.profile.name}',extra: widget.rootScreenMobileContext, // Pass the context here
        // );
        // }
        widget.onItemTapped(x); // Call the onItemTapped method

         // If the tapped tab is the one requiring refresh, call the refreshScreen method
        if (x == 0) {
          widget.refreshCallback();
        }
      },
      showUnselectedLabels: true,
      backgroundColor: const Color(0XFF0707b5),  //Color(0XFF4776E6),
      // unselectedItemColor: Colors.white,
      // selectedItemColor: Color(0XFFF2722B),

      unselectedItemColor: Colors.white,
      selectedItemColor: const Color(0xffFFA500),

      items: widget.menuItems
          .map((TabMenuItem menuItem) => BottomNavigationBarItem(
                backgroundColor: Colors.orange,
                icon: Icon(menuItem.iconData),
                label: menuItem.text,
              ))
          .toList(),
    );
  }
}
