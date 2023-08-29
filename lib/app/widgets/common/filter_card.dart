import 'package:flutter/material.dart';

class FilterCard extends StatefulWidget {
  const FilterCard({super.key});

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  String _topOrRecent = 'Recent';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'L&D',
    'HR',
    'Finance',
    'Admin & Facilities',
    'IT & Security',
    'Java Practice',
    'Microsoft Practice',
    'Pega Practice',
    'UI Practice',
    'OpenSource Practice',
    'CSC',
    'Leaders Space'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              const Text(
                'Sort By : ',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
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
                selectedColor: Colors.lightBlue, // Customize the button color
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
                selectedColor: Colors.lightBlue, // Customize the button color
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
                'Filter by Group : ',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
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
              const SizedBox(height: 8.0),
              const Divider(
                height: 5,
                thickness: 1,
                indent: 5,
                endIndent: 5,
              ),
              const SizedBox(
                  height:
                      8.0), // Add spacing between FilterChip set and buttons
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
    );
  }
}
