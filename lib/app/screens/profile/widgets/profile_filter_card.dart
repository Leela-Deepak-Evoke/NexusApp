import 'package:flutter/material.dart';

class ProfileFilterCard extends StatefulWidget {
  const ProfileFilterCard({super.key});

  @override
  State<ProfileFilterCard> createState() => _ProfileFilterCardState();
}

class _ProfileFilterCardState extends State<ProfileFilterCard> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Java',
    'Microsoft',
    'Open Source',
    'HR',
    'Salesforce',
    'Pega',
    'UI',
    'Cloud',
    'RPA',
    'Medical Insurance'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Q&A Preferences : ',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Wrap(
                    spacing: 2.0,
                    runSpacing: 2.0,
                    children: _categories.map((String category) {
                      return FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = selected ? category : 'All';
                          });
                        },
                        selectedColor:
                            Colors.lightBlue, // Customize the button color
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 4.0),
                  const Divider(
                    height: 2,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  const SizedBox(
                      height:
                          4.0), // Add spacing between FilterChip set and buttons
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white60,
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.normal),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
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
