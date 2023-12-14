import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';

class S3Test extends StatefulWidget {
  const S3Test({super.key});

  @override
  _S3TestState createState() => _S3TestState();
}

class _S3TestState extends State<S3Test> {
  String _fileKey = '';

  @override
  void initState() {}

  void _upload() async {
    try {
      safePrint('In upload');
      // Select a file from the device
      final fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: false,
        // Ensure to get file stream for better performance
        withReadStream: true,
        allowedExtensions: ['jpg', 'png', 'gif'],
      );

      if (fileResult == null) {
        safePrint('No file selected');
        return;
      }
      final platformFile = fileResult.files.single;

      setState(() {
        _fileKey = platformFile.name;
      });
      const options = StorageUploadFileOptions(
        accessLevel: StorageAccessLevel.guest,
      );

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          platformFile.readStream!,
          size: platformFile.size,
        ),
        key: platformFile.name,
        //options: options,
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;
      safePrint('Successfully uploaded file: ${result.uploadedItem.key}');
    } catch (e) {
      safePrint('UploadFile Err: $e');
    }
  }

  void logout() async {
    await signOutCurrentUser();
  }

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
              resizeToAvoidBottomInset:false,

        appBar: AppBar(
          title: const Text('Amplify Flutter Storage Application'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _upload,
                child: const Text('Upload File'),
              ),
              ElevatedButton(
                onPressed: logout,
                child: const Text('Logout'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
