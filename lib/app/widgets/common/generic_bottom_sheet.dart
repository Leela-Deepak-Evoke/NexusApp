import 'package:flutter/material.dart';

class GenericBottomSheet extends StatefulWidget {
  final Widget content;

  GenericBottomSheet({required this.content});

  @override
  _GenericBottomSheetState createState() => _GenericBottomSheetState();
}

class _GenericBottomSheetState extends State<GenericBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Customize the appearance of your bottom sheet here
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bottom Sheet Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Divider(), // Optional divider
          widget.content, // Content of the bottom sheet
        ],
      ),
    );
  }
}
