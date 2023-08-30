import 'package:evoke_nexus_app/app/models/post_org_update_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/video_uploader.dart';
import 'package:evoke_nexus_app/app/widgets/common/expandable_fab.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/image_uploader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostOrgUpdateFAB extends ConsumerStatefulWidget {
  final User user;
  const PostOrgUpdateFAB({super.key, required this.user});

  @override
  ConsumerState<PostOrgUpdateFAB> createState() => _PostOrgUpdateFABState();
}

class _PostOrgUpdateFABState extends ConsumerState<PostOrgUpdateFAB> {
  String? uploadedFilePath;
  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController mediaCaptionController = TextEditingController();
  final TextEditingController orgUpdateController = TextEditingController();
  String dropdownValue = 'General';

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
          onPressed: () => _showOrgUpdateDialog(context),
          icon: const Icon(Icons.format_size),
        ),
        ActionButton(
          onPressed: () => _showImageDialog(context),
          icon: const Icon(Icons.insert_photo),
        ),
        ActionButton(
          onPressed: () => _showVideoDialog(context),
          icon: const Icon(Icons.videocam),
        )
      ],
    );
  }

  void _updateFilePath(String path) {
    setState(() {
      uploadedFilePath = path;
    });
  }

  void _showOrgUpdateDialog(BuildContext context) {
    final orgUpdateId = const Uuid().v4();

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
                  child: Text('Post an OrgUpdate',
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: orgUpdateController,
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
                final params = PostOrgUpdateParams(
                    userId: widget.user.userId,
                    orgUpdateId: orgUpdateId,
                    content: orgUpdateController.text,
                    category: dropdownValue,
                    media: false,
                    hasImage: false,
                    hasVideo: false);

                _handleSubmit(params);
                Navigator.of(context).pop();
                //context.go('orgUpdates');
              },
            ),
          ],
        );
      },
    );
  }

  void _showImageDialog(BuildContext context) {
    final orgUpdateId = const Uuid().v4();

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
                          orgUpdateId: orgUpdateId,
                          onFileUploaded: _updateFilePath),
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
                final params = PostOrgUpdateParams(
                  userId: widget.user.userId,
                  orgUpdateId: orgUpdateId,
                  content: orgUpdateController.text,
                  media: true,
                  hasImage: true,
                  imagePath: uploadedFilePath!,
                  mediaCaption: mediaCaptionController.text,
                  hashTag: hashTagController.text,
                  hasVideo: false,
                  category: dropdownValue,
                );

                _handleSubmit(params);
                Navigator.of(context).pop();
                //context.go('orgUpdates');
              },
            ),
          ],
        );
      },
    );
  }

  void _showVideoDialog(BuildContext context) {
    final orgUpdateId = const Uuid().v4();

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
                          orgUpdateId: orgUpdateId,
                          onFileUploaded: _updateFilePath),
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
                final params = PostOrgUpdateParams(
                  userId: widget.user.userId,
                  orgUpdateId: orgUpdateId,
                  content: orgUpdateController.text,
                  media: true,
                  hasImage: false,
                  mediaCaption: mediaCaptionController.text,
                  hashTag: hashTagController.text,
                  hasVideo: true,
                  videoPath: uploadedFilePath!,
                  category: dropdownValue,
                );

                _handleSubmit(params);
                Navigator.of(context).pop();
                //context.go('orgUpdates');
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit(PostOrgUpdateParams params) async {
    await ref.read(postOrgUpdateProvider(params).future);
  }

  void _resetValues() {
    setState(() {
      uploadedFilePath = null;
      orgUpdateController.clear();
      hashTagController.clear();
      mediaCaptionController.clear();
      dropdownValue = 'General';
    });
  }
}
