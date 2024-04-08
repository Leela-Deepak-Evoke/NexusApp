import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Screen"),
      ),
      body: const MyScreenBody(),
    );
  }
}

class MyScreenBody extends StatelessWidget {
  const MyScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Header
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Header Title",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                "Header Description",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),

        // Content (List of Comments)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: const <Widget>[
              // Your comment items here, or a message if no comments available
              CommentItem(text: "Comment 1"),
              CommentItem(text: "Comment 2"),
              CommentItem(text: "Comment 3"),
            ],
          ),
        ),

        // Footer (Text Field)
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const TextField(
            decoration: InputDecoration(
              labelText: "Add a comment...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class CommentItem extends StatelessWidget {
  final String text;

  const CommentItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(text),
      ),
    );
  }
}
