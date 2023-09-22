import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Screen"),
      ),
      body: MyScreenBody(),
    );
  }
}

class MyScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Header
        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              // Your comment items here, or a message if no comments available
              CommentItem(text: "Comment 1"),
              CommentItem(text: "Comment 2"),
              CommentItem(text: "Comment 3"),
            ],
          ),
        ),

        // Footer (Text Field)
        Container(
          padding: EdgeInsets.all(16.0),
          child: TextField(
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

  CommentItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(text),
      ),
    );
  }
}
