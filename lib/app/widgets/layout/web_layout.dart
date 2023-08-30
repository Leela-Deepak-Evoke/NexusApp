import 'package:evoke_nexus_app/app/widgets/common/web_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:evoke_nexus_app/app/models/user.dart';

class WebLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final User user;

  const WebLayout(
      {super.key,
      required this.child,
      required this.title,
      required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUri = Uri.parse(GoRouter.of(context).location);
    final currentPath = currentUri.path;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        toolbarOpacity: 1.0,
        elevation: 10.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/nexus_logo.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 100),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Profile",
            color: currentPath == '/profile'
                ? Colors.blue
                : null, // Highlight selected action
            onPressed: () {
              GoRouter.of(context).go('/profile');
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            color: currentPath == '/settings'
                ? Colors.blue
                : null, // Highlight selected action
            onPressed: () {
              GoRouter.of(context).go('/settings');
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            tooltip: "Notifications",
            icon: const Icon(Icons.notifications),
            color: currentPath == '/notifications'
                ? Colors.blue
                : null, // Highlight selected action
            onPressed: () {
              GoRouter.of(context).go('/notifications');
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            color: currentPath == '/logout'
                ? Colors.blue
                : null, // Highlight selected action
            onPressed: () {
              GoRouter.of(context).go('/logout');
            },
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                SizedBox(
                    width: 275,
                    child: WebAppDrawer(goRouter: router, user: user)),
                //const SizedBox(width: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 300,
                    child: child)
              ]),
        ),
      ),
    );
  }
}
