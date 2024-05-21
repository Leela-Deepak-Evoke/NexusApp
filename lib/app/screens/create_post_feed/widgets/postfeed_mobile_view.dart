import 'dart:io';
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/models/post_feed_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/get_categories_provider.dart';
import 'package:evoke_nexus_app/app/screens/feeds/widgets/feed_media_view.dart';
import 'package:evoke_nexus_app/app/services/feed_service.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/generic_bottom_sheet.dart';
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

class PostFeedsMobileView extends ConsumerStatefulWidget {
  final User? user;
  final String? slectedCategory;
  final Feed? feedItem;
  final bool? isEditFeed;

  const PostFeedsMobileView(
      {super.key,
      this.user,
      this.slectedCategory,
      this.feedItem,
      this.isEditFeed});

  @override
  PostFeedsMobileViewState createState() => PostFeedsMobileViewState();
}

class PostFeedsMobileViewState extends ConsumerState<PostFeedsMobileView> {
  String? uploadedFilePath;
  String? uploadedFileName;

  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController mediaCaptionController = TextEditingController();
  final TextEditingController feedController = TextEditingController();
  final feedService = FeedService();
  bool isMediaSelect = false;
  bool isImageSelect = false;
  bool isVideoSelect = false;
  bool replaceImageTriggered = false;
  bool updateEditCategories = false;

  String? selectedCategory;
  final ImagePicker imagePicker = ImagePicker();
  List<String> fileList = [];
  int? selectedIndex;
  List<XFile>? imageFileList = [];
  List<File>? _selectedPostImages;
  List<File>? get selectedPostImages => _selectedPostImages;
  String contentTypeSelected = "";
  bool isVisible = true; // Set this boolean based on your condition
  final FocusNode feedFocusNode = FocusNode();
  bool _isLoading = false;

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

  void onCategorySelected() {
    _showBottomSheet(context);
  }

  //Categories Static Array
  List<String> checkListItems = [];

//Video
  VideoPlayerController? _videoPlayerController;
  File? _video;

  @override
  void initState() {
    super.initState();
    if (widget.isEditFeed == true) {
      feedController.text = widget.feedItem?.content ?? feedController.text;
      isMediaSelect = widget.feedItem?.hasImage ?? false;
      isImageSelect = widget.feedItem?.hasImage ?? false;
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
      //   if (widget.isEditFeed == true) {
      // contentTypeSelected = widget.feedItem?.name ?? type.name;
      //  }else{
      //    contentTypeSelected =  type.name;
      //  }
    });
    switch (type) {
      case ContentType.image:
        replaceImageTriggered = true;
        imageAttachment();
        break;
      case ContentType.video:
        replaceImageTriggered = true;
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
    final categoryAsyncValue = ref.watch(categoriesProviderFeed);
    if (categoryAsyncValue is AsyncData<List<String>>) {
      final feedsCategoryList = categoryAsyncValue;
      checkListItems = feedsCategoryList.value;
    }
    if (categoryAsyncValue is AsyncLoading) {
      const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }
    final Size size = MediaQuery.of(context).size;
    feedController.text = feedController.text;
    return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Container(
            // height: MediaQuery.of(context).size.height,
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        categoryHearViewWidget(),
                        feedsDescriptionUI(context),
                        videoPickerContent(size),
                        if (isVisible) imagePickerContent(size),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        //SELECT PHOTOS/VIDEOS/
                        attchmentFileButtons(context, ref),
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
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ));
  }

//   //CARD - Feeds Descriotion
  Widget feedsDescriptionUI(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Focus on TextFormField when Container is tapped
        FocusScope.of(context).requestFocus(feedFocusNode);
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 200), // Set a minimum height
        color: Colors.white, // Background color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: feedFocusNode,
                      cursorColor: Color(0xffB54242),
                      enabled: true,
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
                        hintText: "Share your thoughts with colleagues..",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feedsDescriptionUI_OLD(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .requestFocus(FocusNode()); // Focus on TextFormField
        },
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextFormField(
                    cursorColor: Color(0xffB54242),
                    enabled: true,
                    //  focusNode: feedFocusNode, // Assign the FocusNode
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
                    // Listen for when the "Done" button is pressed
                    //   onFieldSubmitted: (_) {
                    //   feedFocusNode.unfocus(); // Unfocus the TextFormField
                    // },
                  )),
                ],
              ),
            ),
            // const Divider(
            //   thickness: 1,
            //   color: Color(0xffEAEAEA),
            //   height: 1,
            // ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Expanded(
//                   child: TextFormField(
//                 validator: (value) => value!.isEmpty ? 'HashTag #' : null,
//                 controller: hashTagController,
//                 textInputAction: TextInputAction.done,
//                 maxLines: null,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14.0,
//                   fontFamily: GoogleFonts.notoSans().fontFamily,
//                   fontWeight: FontWeight.normal,
//                 ),
//                 decoration:
//                     const InputDecoration.collapsed(hintText: "HashTag1 #"),
// //                     InputDecoration.collapsed(
// //   hintText: ref.read(selectedItemProvider)?.hashTag ?? 'HashTag #',
// // )
//               )
//               ),
//             ],
//           ),
//         ),
          ],
        ));
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
                      // Unfocus keyboard when tapping outside of TextFormField
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      }

                      _selectFile(ContentType.image);
                      isVisible = true;
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

              //Right now hiding once Functionality starts uncomment this VIDEO & Document
              // Visibility(
              //     visible: ((contentTypeSelected == ContentType.video.name) ||
              //             (contentTypeSelected == ''))
              //         ? true
              //         : false,
              //     child: TextButton.icon(
              //       onPressed: () {
              //         // isVisible = false;
              //         // _selectFile(ContentType.video);
              //         // Unfocus keyboard when tapping outside of TextFormField
              //         FocusScopeNode currentFocus = FocusScope.of(context);
              //         if (!currentFocus.hasPrimaryFocus &&
              //             currentFocus.focusedChild != null) {
              //           FocusManager.instance.primaryFocus!.unfocus();
              //         }

              //         _showToast(context);
              //       },
              //       icon: Image.asset(
              //         'assets/images/Vector.png',
              //         width: 20,
              //         height: 20,
              //       ),
              //       label: Text(
              //         'Video',
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 12.0,
              //           fontFamily: GoogleFonts.inter().fontFamily,
              //           fontWeight: FontWeight.normal,
              //         ),
              //       ),
              //       style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all(Colors.grey.shade100)),
              //     )),
              // const SizedBox(
              //   width: 5,
              // ),

              // //DOCUMENT
              // Visibility(
              //     visible:
              //         ((contentTypeSelected == ContentType.document.name) ||
              //                 (contentTypeSelected == ''))
              //             ? true
              //             : false,
              //     child: TextButton.icon(
              //       // <-- TextButton
              //       onPressed: () {
              //         // isVisible = true;
              //         // _selectFile(ContentType.document);
              //         // Unfocus keyboard when tapping outside of TextFormField
              //         FocusScopeNode currentFocus = FocusScope.of(context);
              //         if (!currentFocus.hasPrimaryFocus &&
              //             currentFocus.focusedChild != null) {
              //           FocusManager.instance.primaryFocus!.unfocus();
              //         }

              //         _showToast(context);
              //       },
              //       icon: Image.asset(
              //         'assets/images/Vector-1.png',
              //         width: 20,
              //         height: 20,
              //       ),
              //       label: Text(
              //         'Document',
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 12.0,
              //           fontFamily: GoogleFonts.inter().fontFamily,
              //           fontWeight: FontWeight.normal,
              //         ),
              //       ),
              //       style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all(Colors.grey.shade100)),
              //     )),
            ],
          ),
        ],
      ),
    );
  }

  // IMAGE Content
  Widget imagePickerContent(Size size) {
    final feedId = widget.isEditFeed == true
        ? widget.feedItem?.feedId ?? const Uuid().v4()
        : const Uuid().v4();

    if (widget.isEditFeed == true &&
        !replaceImageTriggered &&
        widget.feedItem?.imagePath != null) {
      fileList.add(widget.feedItem!.imagePath.toString());
    }

    if (widget.isEditFeed == true && !replaceImageTriggered) {
      if (widget.feedItem?.hasImage == true) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              FeedMediaView(item: widget.feedItem!),
              Positioned(
                top: -10,
                right: 1,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              const Text('Would you like to delete the image?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                  // fileList.remove(data);
                              },
                              child: const Text('OK --(In Progress)'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: AppColors.blueTextColour,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    } else {
      return fileList.isNotEmpty
          ? SizedBox(
              height: size.height - 600,
              // height: 90,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child:

                      // GridView.builder(
                      //   itemCount: fileList.length,
                      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 1,
                      //   ),
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return
                      Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        returnFileContainer(0),
                        Positioned(
                          top: -10,
                          right: 1,
                          child: IconButton(
                            onPressed: () {
                              dltImages(fileList[0]);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: AppColors.blueTextColour,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  // },
                  // ),
                  ),
            )
          : Container(); // Return an empty container if fileList is empty
    }
  }

  Widget imagePickerContent_old(Size size) {
    final feedId = widget.isEditFeed == true
        ? widget.feedItem?.feedId ?? const Uuid().v4()
        : const Uuid().v4();

    // Add widget.feedItem!.imagePath to fileList if it's not null
    if (widget.isEditFeed == true &&
        !replaceImageTriggered &&
        widget.feedItem?.imagePath != null) {
      fileList.add(widget.feedItem!.imagePath.toString());
    }

    if (widget.isEditFeed == true && !replaceImageTriggered) {
      if (widget.feedItem?.hasImage == true) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              FeedMediaView(item: widget.feedItem!),
              Positioned(
                top: -10,
                right: 1,
                child: IconButton(
                  onPressed: () {
                    // dltImages(widget.feedItem);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // title: const Text(''),
                            content: const Text(
                                'Would you like to delete the image?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // setState(() {
                                  //                         _showToast(context);

                                  // });
                                },
                                child: const Text('OK --(In Progress)'),
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
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: AppColors.blueTextColour,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    } else {
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                      }))
          // ),
          );
    }
  }

  // VIDEO Content
  Widget videoPickerContent(Size size) {
    return Container(
      padding: const EdgeInsets.all(2),
      // color: Colors.red,
      // height: 200,
      // width: 200,
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

                        // SizedBox(
                        //   //  height: size.height - 600,
                        //   // height: 200,
                        //   // width: 200,
                        //   child: AspectRatio(
                        //     aspectRatio:
                        //         _videoPlayerController!.value.aspectRatio,
                        //     child: VideoPlayer(_videoPlayerController!),
                        //   ),
                        // ),
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

//   Widget videoPickerContent_new(Size size) {
//   return Container(
//     padding: const EdgeInsets.all(10.0),
//     // color: Colors.red,
//     height: 200,
//     width: 200,
//     child: (_videoPlayerController != null &&
//             _videoPlayerController!.value.isInitialized)
//         ? Stack(
//             children: <Widget>[
//               AspectRatio(
//                 aspectRatio: _videoPlayerController!.value.aspectRatio,
//                 child: VideoPlayer(_videoPlayerController!),
//               ),
//               Positioned(
//                 top: -15,
//                 right: -15,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(6.0),
//                   child: IconButton(
//                     hoverColor: Colors.red,
//                     icon: const Icon(
//                       Icons.delete,
//                       color: Colors.red,
//                       size: 23,
//                     ),
//                     onPressed: () => _removeVideo(),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         : Container(),
//   );
// }

//IMAGE ATTACHMENT
  imageAttachment() async {
    final feedId = const Uuid().v4();

    Map<String, dynamic>? resultFileName =
        await feedService.uploadMedia(feedId, 'Image');
    if (resultFileName != null) {
      setState(() {
        isMediaSelect = true;
        isImageSelect = true;
        isVideoSelect = false;
        uploadedFilePath = resultFileName["platformFilePath"];
        uploadedFileName = resultFileName["mediaPath"];
      });
      fileList.add(uploadedFilePath.toString());
    }
  }

  videoAttachment() async {
    final feedId = const Uuid().v4();
    Map<String, dynamic>? resultFileName =
        await feedService.uploadMedia(feedId, 'Video');
    if (resultFileName != null) {
      setState(() {
        isMediaSelect = true;
        isImageSelect = false;
        isVideoSelect = true;
        uploadedFilePath = resultFileName["platformFilePath"];
        uploadedFileName = resultFileName["mediaPath"];
      });
      initializeVideo(uploadedFilePath.toString());
    } else {
      _showFileSizeExceedDialog();
    }
  }

  void _showFileSizeExceedDialog() {
    showDialog(
      context: context, // Make sure to have a reference to the BuildContext
      builder: (context) {
        return AlertDialog(
          title: const Text('File Size Exceeded'),
          content:
              const Text('Please select a video file that is 5MB or smaller.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.file(File(url))
      ..initialize().then((_) {
        _videoPlayerController!.setVolume(0);
        _videoPlayerController!.play();
        setState(() {});
      });
  }

// Future<void> initializeVideo(String url) async {
//     print("Video URL: $url");

//     if (!File(url).existsSync()) {
//       print("Video file does not exist at $url");
//       return;
//     }

//     // Create a directory to store the video file in a more permanent location
//     final appDirectory = await getApplicationDocumentsDirectory();
//     final newFilePath = '${appDirectory.path}/video.mp4';

//     // Copy the video file to the new location
//     final File newFile = await File(url).copy(newFilePath);
//     print("Copied video file to: ${newFile.path}");

//     // Initialize the VideoPlayer with the new file path
//     _videoPlayerController = VideoPlayerController.file(newFile);

//     // Listen for when the initialization is complete
//     await _videoPlayerController!.initialize();

//     // Set up a listener to rebuild the UI when the playback state changes
//     _videoPlayerController!.addListener(() {
//       setState(() {});
//     });

//     // Start playing the video
//     _videoPlayerController!.play();
//   }

  Widget returnFileContainer(int index) {
    if (!fileList[index].contains('mp4')) {
      return Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Image.file(File(uploadedFilePath ?? ""), fit: BoxFit.cover));
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
      uploadedFileName = path;
    });
  }

  void _resetValues() {
    setState(() {
      uploadedFilePath = null;
      uploadedFileName = null;
      feedController.clear();
      hashTagController.clear();
      mediaCaptionController.clear();
      _videoPlayerController!.dispose();
      // dropdownValue = 'General Feed';

      // if (fileList.isNotEmpty){
      //  fileList.remove(data);
      // }
    });
  }

  void _resetImageDeleteValues(data) {
    setState(() {
      if (fileList.isNotEmpty) {
        fileList.remove(data);
      }
      // uploadedFilePath = null;
      //       uploadedFileName = null;
      feedController.clear();
      hashTagController.clear();
      mediaCaptionController.clear();
      _videoPlayerController!.dispose();
    });
  }

  // void _handleSubmit(PostFeedParams params, WidgetRef ref) async {
  //   if (widget.isEditFeed == true) {
  //     await ref.read(editFeedProvider(params).future);
  //   } else {
  //     await ref.read(postFeedProvider(params).future);
  //   }
  //   // Navigator.pop(context);
  //   _resetValues();
  //   showMessage('Feed posted successfully.');

  // }

  void _handleSubmit(PostFeedParams params, WidgetRef ref) async {
    try {
      if (widget.isEditFeed == true) {
        await ref.read(editFeedProvider(params).future);
      } else {
        await ref.read(postFeedProvider(params).future);
      }
      Navigator.pop(context);
      _resetValues();
    } catch (e) {
      // showMessage('Failed to post feed. Please try again.');
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
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
                  if (text == 'Feed posted successfully.') {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

// POST BUTTON

  Widget btnPost(Size size) {
    return Stack(
      children: [
        Container(
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
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }

              if (feedController.value.text.isEmpty) {
                showMessage('Please share your thoughts');
              }
              // else if (hashTagController == null ||
              //     hashTagController.value.text.isEmpty) {
              //   showMessage('Please add hashtag');
              // }
              else {
                if (isMediaSelect == false) {
                  setState(() {
                    _isLoading = true; // Show loader
                  });
                  createPostWithoutAttachment();
                } else {
                  setState(() {
                    _isLoading = true; // Show loader
                  });
                  createPostAttachments();
                }
              }
            },
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        if (_isLoading) // Show loader if _isLoading is true
          const Positioned.fill(
            child: Center(
              child: SizedBox(
                width:
                    50, // Set the size of the SizedBox to control the size of the CircularProgressIndicator
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth:
                      3, // Increase the strokeWidth to make the CircularProgressIndicator larger
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget btnPost_OLD(Size size) {
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
          // Unfocus keyboard when tapping outside of TextFormField
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }

          if (feedController.value.text.isEmpty) {
            showMessage('Please share your thoughts');
          }
          // else if (hashTagController == null ||
          //     hashTagController.value.text.isEmpty) {
          //   showMessage('Please add hashtag');
          // }
          else {
            if (isMediaSelect == false) {
              createPostWithoutAttachment();
            } else {
              createPostAttachments();
            }
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

  createPostWithoutAttachment() async {
    final feedId = const Uuid().v4();
    final params = PostFeedParams(
        userId: widget.user!.userId,
        feedId: widget.isEditFeed == true
            ? widget.feedItem?.feedId ?? feedId
            : feedId,
        content: feedController
            .text, //widget.isEditFeed == true ? widget.feedItem?.content :
        category: (widget.isEditFeed == true && updateEditCategories == true)
            ? (selectedIndex != null)
                ? checkListItems[selectedIndex ?? 0]
                : widget.feedItem?.name ?? "General Feed"
            : (widget.isEditFeed == true && updateEditCategories == false)
                ? widget.feedItem?.name ?? "General Feed"
                : (selectedIndex != null)
                    ? checkListItems[selectedIndex ?? 0]
                    : "General Feed",
        media: false,
        hasImage: false,
        hasVideo: false);
    _handleSubmit(params, ref);
  }

  createPostAttachments() async {
    final feedId = const Uuid().v4();
    final params = PostFeedParams(
      userId: widget.user!.userId,
      feedId: widget.isEditFeed == true
          ? widget.feedItem?.feedId ?? feedId
          : feedId,
      content: feedController.text,
      media: isMediaSelect,
      hasImage: isImageSelect,
      imagePath: uploadedFileName ?? "",
      mediaCaption: mediaCaptionController.text,
      // hashTag: hashTagController.text,
      hasVideo: isVideoSelect,
      category: (widget.isEditFeed == true && updateEditCategories == true)
          ? (selectedIndex != null)
              ? checkListItems[selectedIndex ?? 0]
              : widget.feedItem?.name ?? "General Feed"
          : (widget.isEditFeed == true && updateEditCategories == false)
              ? widget.feedItem?.name ?? "General Feed"
              : (selectedIndex != null)
                  ? checkListItems[selectedIndex ?? 0]
                  : "General Feed",
    );
    _handleSubmit(params, ref);
    //_resetValues();
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
                  // _resetValues();
                  // _resetImageDeleteValues(data);
                  setState(() {
                    fileList.remove(data);
                    //     if (data is String) {
                    //   // If data is a file path (from fileList)
                    //   fileList.remove(data);
                    // } else if (data is Feed) {
                    //   // If data is a Feed object (from widget.feedItem)
                    //   // Assuming you have a way to uniquely identify feed items
                    //   // and you want to delete the item matching the feedId
                    //   // widget.feedItem?.removeWhere((item) => item.feedId == data.feedId);
                    //   fileList.remove(data);
                    // }
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

  void _handleCategorySelected(int? categoryIndex) {
    if (categoryIndex != null) {
      // Handle the selected category here
      print('Selected category: $categoryIndex');
      selectedIndex = categoryIndex;

      setState(() {
        selectedIndex = categoryIndex;
        selectedIndex = categoryIndex;
        if (widget.isEditFeed == true) {
          updateEditCategories = true;
        }
        // selectedCategories.add(categories[index]);
        // selectedIndex = categoryIndex;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GenericBottomSheet(
          content: categoryListView(),
          title: 'Select Post Category',
          index: selectedIndex,
          onCategoriesSelected: (selectedIndex) {
            _handleCategorySelected(selectedIndex);
          },
        );
      },
    );
  }

  // LIST VIEW
  Widget categoryListView() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: checkListItems.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                checkListItems[index],
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              // value: selectedIndex == index,
              value: selectedIndex == index ||
                  (selectedIndex == null &&
                      index ==
                          0), // Select "General Feed" by default if no category is selected
              onChanged: (value) {
                setState(() {
                  selectedIndex = index;
                  _handleCategorySelected(selectedIndex);

                  Navigator.of(context).pop();
                });
              },
            );
          },
        ));
  }

//WITHOUT ARROW
  Widget categoryHearViewWidget_OLD() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Wrap(
        spacing: 5,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const CircleAvatar(
            radius: 3,
            backgroundColor: Color(0xffB54242),
          ),
          Text(
            (widget.isEditFeed == true && updateEditCategories == true)
                ? (selectedIndex != null)
                    ? checkListItems[selectedIndex ?? 0]
                    : widget.feedItem?.name ?? "General Feed"
                : (widget.isEditFeed == true && updateEditCategories == false)
                    ? widget.feedItem?.name ?? "General Feed"
                    : (selectedIndex != null)
                        ? checkListItems[selectedIndex ?? 0]
                        : "General Feed",
            style: TextStyle(
              color: const Color(0xffB54242),
              fontSize: 12.0,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryHearViewWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      child: Wrap(
        spacing: 5,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const CircleAvatar(
            radius: 3,
            backgroundColor: Color(0xffB54242),
          ),
          GestureDetector(
            onTap: () {
              _showBottomSheet(context);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (widget.isEditFeed == true && updateEditCategories == true)
                      ? (selectedIndex != null)
                          ? checkListItems[selectedIndex ?? 0]
                          : widget.feedItem?.name ?? "General Feed"
                      : (widget.isEditFeed == true &&
                              updateEditCategories == false)
                          ? widget.feedItem?.name ?? "General Feed"
                          : (selectedIndex != null)
                              ? checkListItems[selectedIndex ?? 0]
                              : "General Feed",
                  style: TextStyle(
                    color: const Color(0xffB54242),
                    fontSize: 14.0,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: const Color(0xffB54242),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: Color(0xffEAEAEA),
            height: 10,
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const SizedBox(
          height: 70,
          child: Text('In Progress'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
