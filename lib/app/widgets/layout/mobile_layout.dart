import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/widgets/common/mobile_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app_router.dart';
import 'package:go_router/go_router.dart';

import 'package:evoke_nexus_app/app/widgets/common/mobile_custom_appbar.dart';

class MobileLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final User user;

  const MobileLayout({
    super.key,
    required this.child,
    required this.title,
      required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUri = Uri.parse(GoRouter.of(context).location);
    final currentPath = currentUri.path;

    // return Scaffold(
    //   appBar: AppBar(
    //     toolbarOpacity: 1.0,
    //     elevation: 2.0,
    //     backgroundColor: Colors.white,
    //     automaticallyImplyLeading: true,
    //     title: Text(
    //       title,
    //       style: const TextStyle(
    //         fontSize: 18,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     actions: <Widget>[
    //       IconButton(
    //         icon: const Icon(Icons.person),
    //         tooltip: "Profile",
    //         color: currentPath == '/profile'
    //             ? Colors.blue
    //             : null, // Highlight selected action
    //         onPressed: () {
    //           GoRouter.of(context).go('/profile');
    //         },
    //       ),
    //       const SizedBox(width: 4),
    //       IconButton(
    //         icon: const Icon(Icons.settings),
    //         tooltip: "Settings",
    //         color: currentPath == '/settings'
    //             ? Colors.blue
    //             : null, // Highlight selected action
    //         onPressed: () {
    //           GoRouter.of(context).go('/settings');
    //         },
    //       ),
    //       const SizedBox(width: 4),
    //       IconButton(
    //         tooltip: "Notifications",
    //         icon: const Icon(Icons.notifications),
    //         color: currentPath == '/notifications'
    //             ? Colors.blue
    //             : null, // Highlight selected action
    //         onPressed: () {
    //           GoRouter.of(context).go('/notifications');
    //         },
    //       ),
    //       const SizedBox(width: 4),
    //       IconButton(
    //         tooltip: "Logout",
    //         icon: const Icon(Icons.logout),
    //         color: currentPath == '/logout'
    //             ? Colors.blue
    //             : null, // Highlight selected action
    //         onPressed: () {
    //           GoRouter.of(context).go('/logout');
    //         },
    //       ),
    //     ],
    //   ),
    //   drawer: MobileAppDrawer(goRouter: router, user: user),
    //   body: SizedBox(
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //     child: Container(padding: const EdgeInsets.all(4), child: child),
    //   ),
    // );

    final ValueNotifier<double> headerNegativeOffset = ValueNotifier<double>(0);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const Drawer(),
      body: Stack(
        children: <Widget>[
          _buildHeader(size, headerNegativeOffset),
          Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 120),
              child: child),
          const CustomAppbar(title: "SOCIAL FEED"),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size, ValueNotifier<double> headerNegativeOffset) {
    const double maxHeaderHeight = 250.0;
    return Stack(
      children: [
        Container(
          child: ValueListenableBuilder<double>(
            valueListenable: headerNegativeOffset,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset * -1),
                child: SizedBox(
                  height: maxHeaderHeight,
                  width: size.width,
                  child: Image(
                    image: AssetImage('assets/images/navBarRect.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        // Other header elements can be added here if needed.
      ],
    );
  }
}
