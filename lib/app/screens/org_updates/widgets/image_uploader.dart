import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/services/org_update_service.dart';

class ImageUploader extends StatefulWidget {
  final String orgUpdateId;
  final Function(String) onFileUploaded;
  const ImageUploader(
      {Key? key, required this.orgUpdateId, required this.onFileUploaded})
      : super(key: key);

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final orgUpdateService = OrgUpdateService();
  String? uploadedFileName;

  @override
  Widget build(BuildContext context) {
    return uploadedFileName == null
        ? IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              // Call the uploadMedia function
              String? resultFileName = await orgUpdateService.uploadMedia(
                  widget.orgUpdateId, 'Image');
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
