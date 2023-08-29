import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/widgets/common/scrollable_list.dart';
import 'package:evoke_nexus_app/app/widgets/common/filter_card.dart';
import 'package:evoke_nexus_app/app/widgets/common/expandable_fab.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 350,
                      width: 350,
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding to the card
                          child: Column(
                            children: <Widget>[
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/profile-avatar.png'),
                                radius: 50.0,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Kalyan Kakarala',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Associate Architect',
                                style: TextStyle(
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
                                    onTap: () {
                                      // Handle button tap
                                    },
                                    leading: const Icon(Icons.person,
                                        size: 20, color: Colors.lightBlue),
                                    title: const Text('Profile'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      // Handle button tap
                                    },
                                    leading: const Icon(Icons.timeline,
                                        size: 20, color: Colors.lightBlue),
                                    title: const Text('Timeline'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      // Handle button tap
                                    },
                                    leading: const Icon(Icons.settings,
                                        size: 20, color: Colors.lightBlue),
                                    title: const Text('Settings'),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Align(
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
                      ))
                ],
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  child: ScrollableList(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const FilterCard(),
                  const SizedBox(height: 100),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ExpandableFab(
                        distance: 112,
                        children: [
                          ActionButton(
                            onPressed: () => _showAction(context, 0),
                            icon: const Icon(Icons.format_size),
                          ),
                          ActionButton(
                            onPressed: () => _showAction(context, 1),
                            icon: const Icon(Icons.insert_photo),
                          ),
                          ActionButton(
                            onPressed: () => _showAction(context, 2),
                            icon: const Icon(Icons.videocam),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
