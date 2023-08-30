import 'package:flutter/material.dart';

class ForumFilterCard extends StatefulWidget {
  const ForumFilterCard({super.key});

  @override
  State<ForumFilterCard> createState() => _ForumFilterCardState();
}

class _ForumFilterCardState extends State<ForumFilterCard> {
  String _topOrRecent = 'Recent';
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
    'RPA'
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Sort By : ',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  //const Spacer(),
                  ChoiceChip(
                    label: const Text('Recent'),
                    selected: _topOrRecent == 'Recent',
                    onSelected: (bool selected) {
                      setState(() {
                        _topOrRecent = selected ? 'Recent' : 'Top';
                      });
                    },
                    selectedColor:
                        Colors.lightBlue, // Customize the button color
                  ),
                  const SizedBox(width: 8.0),
                  ChoiceChip(
                    label: const Text('Top'),
                    selected: _topOrRecent == 'Top',
                    onSelected: (bool selected) {
                      setState(() {
                        _topOrRecent = selected ? 'Top' : 'Recent';
                      });
                    },
                    selectedColor:
                        Colors.lightBlue, // Customize the button color
                  ),
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter : ',
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
