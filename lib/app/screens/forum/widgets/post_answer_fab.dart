import 'package:evoke_nexus_app/app/models/post_answer_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostAnswerFAB extends ConsumerStatefulWidget {
  final User user;
  final String questionId;
  const PostAnswerFAB(
      {super.key, required this.user, required this.questionId});

  @override
  ConsumerState<PostAnswerFAB> createState() => _PostAnswerFABState();
}

class _PostAnswerFABState extends ConsumerState<PostAnswerFAB> {
  String? uploadedFilePath;
  final TextEditingController feedController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // isExtended: true,
      child: const Icon(Icons.add),
      onPressed: () => _showAnswerDialog(context),
    );
  }

  void _updateFilePath(String path) {
    setState(() {
      uploadedFilePath = path;
    });
  }

  void _showAnswerDialog(BuildContext context) {
    final answerId = const Uuid().v4();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            color: Colors.indigoAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Write an Answer',
                      style: TextStyle(color: Colors.white)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    _resetValues();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          content: SizedBox(
            height: 275,
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: feedController,
                    maxLines: 5, // Increase this number for more lines
                    decoration: const InputDecoration(
                      hintText: 'Write your Answer!',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15), // Adjust padding as needed
                    ),
                    maxLength: 3000,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _resetValues();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                final params = PostAnswerParams(
                    name: 'Answer',
                    userId: widget.user.userId,
                    questionId: widget.questionId,
                    answerId: answerId,
                    content: feedController.text,
                    hasImage: false);

                _handleSubmit(params);
                Navigator.of(context).pop();
                //context.go('feeds');
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit(PostAnswerParams params) async {
    await ref.read(postAnswerProvider(params).future);
  }

  void _resetValues() {
    setState(() {
      uploadedFilePath = null;
      feedController.clear();
    });
  }
}
