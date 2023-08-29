import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/services/feed_service.dart';

class VideoUploader extends StatefulWidget {
  final String feedId;
  final Function(String) onFileUploaded;
  const VideoUploader(
      {Key? key, required this.feedId, required this.onFileUploaded})
      : super(key: key);

  @override
  State<VideoUploader> createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  final feedService = FeedService();
  String? uploadedFileName;

  @override
  Widget build(BuildContext context) {
    return uploadedFileName == null
        ? IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              // Call the uploadMedia function
              String? resultFileName =
                  await feedService.uploadMedia(widget.feedId, 'Video');
              if (resultFileName != null) {
                widget.onFileUploaded(resultFileName);
                setState(() {
                  uploadedFileName = resultFileName;
                });
              }
            },
          )
        : Text(uploadedFileName!);
  }
}
