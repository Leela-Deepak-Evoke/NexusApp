import 'dart:io';

import 'package:evoke_nexus_app/app/models/answer.dart';
import 'package:evoke_nexus_app/app/models/post_answer_params.dart';
import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/forum_service_provider.dart';
import 'package:evoke_nexus_app/app/services/feed_service.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

enum ContentType {
  image,
  video,
  document,
}

class PostAnswerMobileView extends ConsumerStatefulWidget {
  final User user;
  final Question question;
  final Answer? answerItem;
       bool? isEditAnswer;

   PostAnswerMobileView({super.key, required this.user,required this.question, this.answerItem, this.isEditAnswer});

  @override
  ConsumerState<PostAnswerMobileView> createState() =>
      _PostAnswerMobileViewState();
}

class _PostAnswerMobileViewState extends ConsumerState<PostAnswerMobileView> {
  // TextEditingController txtShareThoughts = TextEditingController();
  String? uploadedFilePath;

  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController mediaCaptionController = TextEditingController();
  final TextEditingController feedController = TextEditingController();
  Uri? uploadedFileName;
  final feedService = FeedService();
  bool isMediaSelect = false;
  bool isImageSelect = false;
  bool isVideoSelect = false;

  final ImagePicker imagePicker = ImagePicker();
  List<String> fileList = [];
  int? selectedIndex;
  List<XFile>? imageFileList = [];
  List<File>? _selectedPostImages;
  
  String selectedCategory = "General";
  List<File>? get selectedPostImages => _selectedPostImages;
  String contentTypeSelected = "";
 

  void _selectDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'xlsx'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      // fileList.add(result.files.single.bytes!);
      // postContentToAWSBucket(result.files.single.bytes!,
      //     result.files.single.name, result.files.single.extension ?? '');
    } else {
      // User canceled the picker
    }
  }

//Video
  VideoPlayerController? _videoPlayerController;
  File? _video;

  @override
  void initState() {
    super.initState();
     hashTagController.text = widget.question.content ?? "";
      if (widget.isEditAnswer == true) {
      feedController.text = widget.answerItem?.content ?? feedController.text;
    }
  }

  _selectFile(ContentType type) {
    // if (fileList.length == 3 && type.name == ContentType.image.name) {
    //   Fluttertoast.showToast(msg: 'Maximum of 3 files can be uploaded');
    //   return;
    // } else if (fileList.length == 1 && type.name == ContentType.video.name) {
    //   Fluttertoast.showToast(msg: 'Maximum of 1 file can be uploaded');
    //   return;
    // }
    setState(() {
      contentTypeSelected = type.name;
    });
    switch (type) {
      case ContentType.image:
        imageAttachment();
        break;
      case ContentType.video:
        videoAttachment();
        break;
      case ContentType.document:
      // _selectDocuments();
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    super.dispose();
    _videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
        feedController.text = feedController.text;
    return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    child: Column(
                      children: [
                        //Share your thoughts
                        feedsDescriptionUI(),

                        //VIDEOS,IMAGES PICKERS
                        videoPickerContent(size),

                        // Image Picker
                        imagePickerContent(size),

                        const SizedBox(
                          height: 80,
                        ),

                        //SELECT PHOTOS/VIDEOS/
                       // attchmentFileButtons(context, ref),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //POST BUTTON
                btnPost(size),
                
              
              ],
            ),
          ),
        ));
  }

  //CARD - Feeds Descriotion

  Widget feedsDescriptionUI() {
    return Column(
      children: [
       
       
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: TextFormField(
                enabled: false,
                validator: (value) => value!.isEmpty ? 'Title' : null,
                controller: hashTagController,
                textInputAction: TextInputAction.done,
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: GoogleFonts.notoSans().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
                decoration:
                    const InputDecoration.collapsed(hintText: "Title"),
              )),
            ],
          ),
        ),
         const Divider(
          thickness: 1,
          color: Color(0xffEAEAEA),
          height: 1,
        ),

         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: TextFormField(
                validator: (value) => value!.isEmpty
                    ? 'Share your thoughts cannot be blank'
                    : null,
                controller: feedController,
                textInputAction: TextInputAction.done,
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontFamily: GoogleFonts.notoSans().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
                decoration: const InputDecoration.collapsed(
                    hintText: "Share your thoughts with colleagues.."),
              )),
            ],
          ),
        ),
      ],
    );
  }

  //SELECT PHOTOS/VIDEOS/
  Widget attchmentFileButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //PHOTO
              Visibility(
                  visible: ((contentTypeSelected == ContentType.image.name) ||
                          (contentTypeSelected == ''))
                      ? true
                      : false,
                  child: TextButton.icon(
                    onPressed: () {
                      _selectFile(ContentType.image);
                    },
                    icon: Image.asset(
                      'assets/images/image.png',
                      width: 20,
                      height: 20,
                    ),
                    label: Text(
                      'Photo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade100),
                    ),
                  )),

              // visible: true),
              const SizedBox(
                width: 5,
              ),

              //VIDEO
              Visibility(
                  visible: ((contentTypeSelected == ContentType.video.name) ||
                          (contentTypeSelected == ''))
                      ? true
                      : false,
                  child: TextButton.icon(
                    onPressed: () {
                      _selectFile(ContentType.video);
                    },
                    icon: Image.asset(
                      'assets/images/Vector.png',
                      width: 20,
                      height: 20,
                    ),
                    label: Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade100)),
                  )),
              const SizedBox(
                width: 5,
              ),

              //DOCUMENT
              Visibility(
                  visible:
                      ((contentTypeSelected == ContentType.document.name) ||
                              (contentTypeSelected == ''))
                          ? true
                          : false,
                  child: TextButton.icon(
                    // <-- TextButton
                    onPressed: () {
                      _selectFile(ContentType.document);
                    },
                    icon: Image.asset(
                      'assets/images/Vector-1.png',
                      width: 20,
                      height: 20,
                    ),
                    label: Text(
                      'Document',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade100)),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  // IMAGE Content
  Widget imagePickerContent(Size size) {
     return SizedBox(
      height: size.height - 600,
      //color: Colors.green,
      child: 
      // Expanded(
      //     child: 
          Padding(
              padding: const EdgeInsets.all(0),
              child: GridView.builder(
                  itemCount: fileList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        //alignment: Alignment.topRight,
                        children: [
                          // SizedBox(
                          //   height: 100,
                          //   width: 100,
                          //   child: Image.file(File(imageFileList![index].path), fit: BoxFit.cover),
                          // ),


                          returnFileContainer(index),
                          Positioned(
                              top: -10,
                              right: 1,
                              child: IconButton(
                                onPressed: () {
                                  dltImages(fileList[index]);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: AppColors.blueTextColour,
                                ),
                              ))
                        ],
                      ),
                    );
                  })
                  )
                  // ),
    );
  }

  // VIDEO Content
  Widget videoPickerContent(Size size) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: 100,
      width: 100,
      //color: Colors.blue,
      child: Row(
        children: <Widget>[
          if (_videoPlayerController != null)
            _videoPlayerController!.value.isInitialized
                ? Expanded(
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!),
                          ),
                        ),
                        Positioned(
                          top: -15,
                          right: -15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: IconButton(
                                hoverColor: Colors.red,
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 23,
                                ),
                                onPressed: () => _removeVideo()),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          // else
          //   const Text(
          //     "test",
          //     style: TextStyle(fontSize: 18.0),
          //   ),
        ],
      ),
    );
  }

//IMAGE ATTACHMENT
  imageAttachment() async {
    final feedId = const Uuid().v4();

    Map<String, dynamic>? resultFileName = await feedService.uploadMedia(feedId, 'Image');
    if (resultFileName != null) {
      setState(() {
        isMediaSelect = true;
        isImageSelect = true;
        isVideoSelect = false;
       uploadedFilePath = resultFileName["platformFilePath"];
        uploadedFileName =  resultFileName["mediaPath"];
      });
       fileList.add(uploadedFilePath.toString());

    }
  }

  videoAttachment() async {
    final feedId = const Uuid().v4();
    Map<String, dynamic>? resultFileName = await feedService.uploadMedia(feedId, 'Video');
    if (resultFileName != null) {
      setState(() {
        isMediaSelect = true;
        isImageSelect = false;
        isVideoSelect = true;
         uploadedFilePath = resultFileName["platformFilePath"];
        uploadedFileName =  resultFileName["mediaPath"];
      });
        initializeVideo(uploadedFilePath.toString());
    }
  }

void initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.file(File(url))
      ..initialize().then((_) {
        _videoPlayerController!.setVolume(0);
        _videoPlayerController!.play();
        setState(() {});
      });
  }


 Widget returnFileContainer(int index) {
    if (!fileList[index].contains('mp4')) {
      return Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
             child: Image.file(File(uploadedFilePath ?? ""),
                  fit: BoxFit.cover)
          );
    } else {
      return FittedBox(
          fit: BoxFit.cover,
          child: Padding(
             padding: const EdgeInsets.only(top: 10, right: 10),
            // width: 100,
            // height: 100,
            child: VideoPlayer(_videoPlayerController!),
          ));
    }
  }

  void _removeVideo() {
    _resetValues();
     
        _videoPlayerController = null;

  }

  void _updateFilePath(String path) {
    setState(() {
      uploadedFilePath = path;
    });
  }

  void _resetValues() {
    setState(() {
      uploadedFilePath = null;
      feedController.clear();
      hashTagController.clear();
      mediaCaptionController.clear();
       _videoPlayerController!.dispose();
      // dropdownValue = 'General Feed';
    });
  }

  void _handleSubmit(PostAnswerParams params, WidgetRef ref) async {
     if (widget.isEditAnswer == true) {
      await ref.read(editAnswerProvider(params).future);
    } else {
    await ref.read(postAnswerProvider(params).future);
    }
      Navigator.pop(context);
       _resetValues();
  }

// POST BUTTON
  Widget btnPost(Size size) {
    return Container(
      height: 48,
      width: size.width - 30,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: const Color(0xffF2722B),
          side: const BorderSide(width: 1, color: Color(0xffF2722B)),
        ),
        // <-- OutlinedButton

        onPressed: () {
          if (feedController.value.text.isEmpty) {
            showMessage('Please share your thoughts');
          }
          //  else if (hashTagController == null ||
          //     hashTagController.value.text.isEmpty) {
          //   showMessage('Please add hashtag');
          // }
           else {
            createPost();
          }
        },
        //POSt Feed
        child: Text('Post',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.normal,
            )),
      ),
    );
  }

  createPost() async {

    final answerId = const Uuid().v4();
    final params = PostAnswerParams(
                    name: 'Answer',
                    userId: widget.user.userId,
                    questionId: widget.question.questionId,
                    // answerId: answerId,
                    answerId: widget.isEditAnswer == true ? widget.answerItem?.answerId ?? answerId: answerId,
                    content: feedController.text,
                    hasImage: false);
    _handleSubmit(params, ref);
    
   
  }

void dltImages(data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: const Text(''),
            content: const Text('Would you like to delete the image?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetValues();
                   setState(() {
                  fileList.remove(data);
                });
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
  

//Validation
  void showMessage(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
             content: Text(text),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetValues();
                  if (text == 'Feed posted successfully') {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
