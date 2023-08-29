import 'package:evoke_nexus_app/app/models/post_feed_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/video_uploader.dart';
import 'package:evoke_nexus_app/app/widgets/common/expandable_fab.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/image_uploader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';

class PostFeedFAB extends ConsumerStatefulWidget {
  const PostFeedFAB({super.key});

  @override
  ConsumerState<PostFeedFAB> createState() => _PostFeedFABState();
}

class _PostFeedFABState extends ConsumerState<PostFeedFAB> {
  String? uploadedFilePath;
  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController mediaCaptionController = TextEditingController();
  final TextEditingController feedController = TextEditingController();
  String dropdownValue = 'General Feed';
  late User user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = ref.watch(currentUserProvider.notifier).state!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 100,
      children: [
        ActionButton(
          onPressed: () => _showFeedDialog(context),
          icon: const Icon(Icons.format_size),
        ),
        ActionButton(
          onPressed: () => _showImageDialog(context),
          icon: const Icon(Icons.insert_photo),
        ),
        ActionButton(
          onPressed: () => _showVideoDialog(context),
          icon: const Icon(Icons.videocam),
        ),
        ActionButton(
          onPressed: () => _showClassifiedsDialog(context),
          icon: const Icon(Icons.sell),
        ),
      ],
    );
  }

  void _updateFilePath(String path) {
    setState(() {
      uploadedFilePath = path;
    });
  }

  void _showFeedDialog(BuildContext context) {
    final feedId = const Uuid().v4();

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
                  child: Text('Post a Feed',
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
            height: 250,
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Category:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['General Feed', 'Ideas', 'Car Pool']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: feedController,
                    maxLines: 5, // Increase this number for more lines
                    decoration: const InputDecoration(
                      hintText: 'What do you want to talk about?',
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
                final params = PostFeedParams(
                    userId: user.userId,
                    feedId: feedId,
                    content: feedController.text,
                    category: dropdownValue,
                    media: false,
                    hasImage: false,
                    hasVideo: false);

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

  void _showImageDialog(BuildContext context) {
    final feedId = const Uuid().v4();

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
                  child: Text('Post an Image',
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
            height: 250,
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Image:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      ImageUploader(
                          feedId: feedId, onFileUploaded: _updateFilePath),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Caption:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      Expanded(
                        // Add this
                        child: TextField(
                          controller: mediaCaptionController,
                          decoration: const InputDecoration(
                            hintText: 'caption',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('HashTag #:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      Expanded(
                        // Add this
                        child: TextField(
                          controller: hashTagController,
                          decoration: const InputDecoration(
                            hintText: '#hashtag',
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
                final params = PostFeedParams(
                  userId: user.userId,
                  feedId: feedId,
                  content: feedController.text,
                  media: true,
                  hasImage: true,
                  imagePath: uploadedFilePath!,
                  mediaCaption: mediaCaptionController.text,
                  hashTag: hashTagController.text,
                  hasVideo: false,
                  category: 'General Feed',
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

  void _showVideoDialog(BuildContext context) {
    final feedId = const Uuid().v4();

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
                  child: Text('Post a Video',
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
            height: 250,
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Video:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      VideoUploader(
                          feedId: feedId, onFileUploaded: _updateFilePath),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Caption:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      Expanded(
                        // Add this
                        child: TextField(
                          controller: mediaCaptionController,
                          decoration: const InputDecoration(
                            hintText: 'caption',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('HashTag #:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      Expanded(
                        // Add this
                        child: TextField(
                          controller: hashTagController,
                          decoration: const InputDecoration(
                            hintText: '#hashtag',
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
                final params = PostFeedParams(
                  userId: user.userId,
                  feedId: feedId,
                  content: feedController.text,
                  media: true,
                  hasImage: false,
                  mediaCaption: mediaCaptionController.text,
                  hashTag: hashTagController.text,
                  hasVideo: true,
                  videoPath: uploadedFilePath!,
                  category: 'General Feed',
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

  void _showClassifiedsDialog(BuildContext context) {
    final feedId = const Uuid().v4();

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
                  child: Text('Post a Classified',
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
                  Row(
                    children: [
                      const Text('Image:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      ImageUploader(
                          feedId: feedId, onFileUploaded: _updateFilePath),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: feedController,
                    maxLines: 5, // Increase this number for more lines
                    decoration: const InputDecoration(
                      hintText: 'What do you want to sell?',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15), // Adjust padding as needed
                    ),
                    maxLength: 3000,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('HashTag #:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 15),
                      Expanded(
                        // Add this
                        child: TextField(
                          controller: hashTagController,
                          decoration: const InputDecoration(
                            hintText: '#hashtag',
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
                final params = PostFeedParams(
                  userId: user.userId,
                  feedId: feedId,
                  content: feedController.text,
                  media: true,
                  hasImage: true,
                  hashTag: hashTagController.text,
                  hasVideo: false,
                  imagePath: uploadedFilePath!,
                  category: 'General Feed',
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

  void _handleSubmit(PostFeedParams params) async {
    await ref.read(postFeedProvider(params).future);
  }

  void _resetValues() {
    setState(() {
      uploadedFilePath = null;
      feedController.clear();
      hashTagController.clear();
      mediaCaptionController.clear();
      dropdownValue = 'General Feed';
    });
  }
}
