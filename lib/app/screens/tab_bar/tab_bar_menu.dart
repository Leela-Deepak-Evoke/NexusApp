import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_handler.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_menu_item.dart';
import 'package:flutter/material.dart';

class TabBarMenu extends StatefulWidget {
  final BuildContext? rootScreenMobileContext; // Add this parameter

  const TabBarMenu(
      {Key? key,
      required this.model,
      required this.menuItems,
      required this.rootScreenMobileContext,
      required this.onItemTapped})
      : super(key: key);
  final List<TabMenuItem> menuItems;
  final TabBarNotifier model;
  final Function(int) onItemTapped;

  @override
  _TabBarMenuState createState() => _TabBarMenuState();
}

class _TabBarMenuState extends State<TabBarMenu> {
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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.model.index,
      onTap: (x) {
        // if (x == 3) {
        //    GoRouter.of(context).go('/${AppRoute.profile.name}',extra: widget.rootScreenMobileContext, // Pass the context here
        // );
        // }
        widget.onItemTapped(x);
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
