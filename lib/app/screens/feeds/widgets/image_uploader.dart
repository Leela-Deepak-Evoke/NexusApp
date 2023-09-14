import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/services/feed_service.dart';

class ImageUploader extends StatefulWidget {
  final String feedId;
  final Function(String, String) onFileUploaded;
  const ImageUploader(
      {Key? key, required this.feedId, required this.onFileUploaded})
      : super(key: key);

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final feedService = FeedService();
  String? uploadedFileName;
  String? mediaPath;

  @override
  Widget build(BuildContext context) {
    return uploadedFileName == null
        ? Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              icon: const Icon(Icons.image),
              onPressed: () async {
                // Call the uploadMedia function
                Map<String, dynamic>? resultFileName =
                    await feedService.uploadMedia(widget.feedId, 'Image');
     

         if (resultFileName != null) {
                  widget.onFileUploaded(resultFileName["platformFilePath"], resultFileName["mediaPath"]);
                  setState(() {
                    uploadedFileName = resultFileName["platformFilePath"];
                    mediaPath = resultFileName["mediaPath"];

                  });
                }
              },
            ),
        )
        : Text(uploadedFileName! ,maxLines: 4 ,style: const TextStyle( fontSize: 15));
  }
}
