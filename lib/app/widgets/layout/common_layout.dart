import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonLayout extends StatelessWidget {
  final Widget child;

  const CommonLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUri = Uri.parse(GoRouter.of(context).location);
    final currentPath = currentUri.path;
    print(currentPath);

    return Scaffold(
            // resizeToAvoidBottomInset:false,

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
            const SizedBox(width: 200),
            SizedBox(
              width: 500,
              height: 50,
              child: TextField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: "Home",
            color: currentPath == '/feeds'
                ? Colors.blue
                : null, // Highlight selected action
            onPressed: () {
              GoRouter.of(context).go('/feeds');
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.feed),
            tooltip: "Org Updates",
            color: currentPath == '/orgUpdates'
                ? Colors.blue
                : null, // Highlight selected action
            onPressed: () {
              GoRouter.of(context).go('/orgUpdates');
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            tooltip: "Forum",
            icon: const Icon(Icons.question_answer),
            color: currentPath == '/forum'
                ? Colors.blue
                : null, // Highlight selected action
            onPressed: () {
              GoRouter.of(context).go('/forum');
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
      body: child,
    );
  }
}
