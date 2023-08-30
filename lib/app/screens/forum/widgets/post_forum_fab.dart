import 'package:evoke_nexus_app/app/models/post_question_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/common/expandable_fab.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostForumFAB extends ConsumerStatefulWidget {
  final User user;
  const PostForumFAB({super.key, required this.user});

  @override
  ConsumerState<PostForumFAB> createState() => _PostForumFABState();
}

class _PostForumFABState extends ConsumerState<PostForumFAB> {
  String? uploadedFilePath;
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController feedController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 100,
      children: [
        ActionButton(
          onPressed: () => _showQuestionDialog(context),
          icon: const Icon(Icons.text_format),
        ),
      ],
    );
  }

  void _updateFilePath(String path) {
    setState(() {
      uploadedFilePath = path;
    });
  }

  void _showQuestionDialog(BuildContext context) {
    final questionId = const Uuid().v4();
    String selectedCategory = 'General';

    final List<String> categories = [
      'General',
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
                  child: Text('Post a Question',
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
            width: 700,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: feedController,
                    maxLines: 5, // Increase this number for more lines
                    decoration: const InputDecoration(
                      hintText: 'Write your Question?',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15), // Adjust padding as needed
                    ),
                    maxLength: 3000,
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        const Text('Category:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(width: 15),
                        Wrap(
                          spacing: 2.0,
                          runSpacing: 1.0,
                          children: categories.map((String category) {
                            return FilterChip(
                              label: Text(category),
                              selected: selectedCategory == category,
                              onSelected: (bool selected) {
                                selectedCategory =
                                    selected ? category : 'General';
                              },
                              selectedColor: Colors
                                  .lightBlue, // Customize the button color
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Sub Category:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      Expanded(
                        // Add this
                        child: TextField(
                          controller: subCategoryController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
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
                final params = PostQuestionParams(
                  name: 'Question',
                  userId: widget.user.userId,
                  questionId: questionId,
                  content: feedController.text,
                  hasImage: false,
                  subCategory: subCategoryController.text,
                  category: selectedCategory,
                );

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

  void _handleSubmit(PostQuestionParams params) async {
    await ref.read(postQuestionProvider(params).future);
  }

  void _resetValues() {
    setState(() {
      uploadedFilePath = null;
      feedController.clear();
      subCategoryController.clear();
    });
  }
}
