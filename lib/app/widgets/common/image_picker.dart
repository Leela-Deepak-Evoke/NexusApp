import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    } catch (e) {
      print("Error while picking the image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _imageFile == null
            ? Text('No image selected.')
            : Image.file(_imageFile!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Take Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choose from Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              );
            },
          );
        },
        // child: Icon(Icons.add),
      ),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ImagePickerWidget extends StatefulWidget {
//   @override
//   _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   File? _imageFile;

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(source: source);
//       setState(() {
//         _imageFile = File(pickedFile!.path);
//       });
//     } catch (e) {
//       print("Error while picking the image: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker Example'),
//       ),
//       body: Center(
//         child: _imageFile == null
//             ? Text('No image selected.')
//             : Image.file(_imageFile!),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: () => _pickImage(ImageSource.camera),
//             tooltip: 'Pick Image from Camera',
//             child: Icon(Icons.camera),
//           ),
//           SizedBox(height: 16),
//           FloatingActionButton(
//             onPressed: () => _pickImage(ImageSource.gallery),
//             tooltip: 'Pick Image from Gallery',
//             child: Icon(Icons.photo_library),
//           ),
//         ],
//       ),
//     );
//   }
// }
