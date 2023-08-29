import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/widgets/common/profile_pic.dart';

class MobileAppDrawer extends StatelessWidget {
  final GoRouter goRouter;
  final User user;
  const MobileAppDrawer(
      {super.key, required this.goRouter, required this.user});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Card(
        margin: const EdgeInsets.all(4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Add padding to the card
          child: Column(
            children: <Widget>[
              ProfilePic(user: user, size: "SMALL"),
              const SizedBox(height: 2),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              const Divider(
                color: Colors.indigo,
                height: 5,
                thickness: 1,
                indent: 5,
                endIndent: 5,
              ),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home,
                        size: 20, color: Colors.lightBlue),
                    title: const Text('Home'),
                    onTap: () {
                      goRouter.go('/home');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.rss_feed,
                        size: 20, color: Colors.lightBlue),
                    title: const Text('Feeds'),
                    onTap: () {
                      goRouter.go('/feeds');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.update,
                        size: 20, color: Colors.lightBlue),
                    title: const Text('Org Updates'),
                    onTap: () {
                      goRouter.go('/orgUpdates');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.forum,
                        size: 20, color: Colors.lightBlue),
                    title: const Text('Forum'),
                    onTap: () {
                      goRouter.go('/forum');
                    },
                  ),
                  ListTile(
                    onTap: () {
                      // Handle button tap
                    },
                    leading: const Icon(Icons.timeline,
                        size: 20, color: Colors.lightBlue),
                    title: const Text('Timeline'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
