import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/widgets/common/profile_pic.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class WebAppDrawer extends StatelessWidget {
  final GoRouter goRouter;
  final User user;
  const WebAppDrawer({super.key, required this.goRouter, required this.user});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 250,
            child: Card(
              margin: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Add padding to the card
                child: Column(
                  children: <Widget>[
                    ProfilePic(user: user, size: "LARGE"),
                    const SizedBox(height: 5),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
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
          ),
        ),
        /* const Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Terms of Use | Privacy Policy | Disclaimer',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 5, 14, 69),
                          fontStyle: FontStyle.normal)),
                  SizedBox(height: 10),
                  Text(
                      'Evoke Technologies Pvt. Ltd. © 2023 All Rights Reserved.',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 5, 14, 69),
                          fontStyle: FontStyle.italic)),
                ],
              ))  */
      ],
    );
  }
}
