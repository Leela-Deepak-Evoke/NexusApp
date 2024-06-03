import 'dart:io';

import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:evoke_nexus_app/app/models/post_org_update_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/get_categories_provider.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_media_view.dart';
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
import 'package:evoke_nexus_app/app/widgets/common/image_picker.dart';
import 'package:image_picker/image_picker.dart';

enum ContentType {
  image,
  video,
  document,
}

class OrgUpdatesMobileView extends ConsumerStatefulWidget {
  final User user;
  final String slectedCategory;
  final OrgUpdate? orgUpdateItem;
  final bool? isEditOrgUpdate;

  const OrgUpdatesMobileView(
      {super.key,
      required this.user,
      required this.slectedCategory,
      this.orgUpdateItem,
      this.isEditOrgUpdate});

  @override
  OrgUpdatesMobileViewMobileViewState createState() =>
      OrgUpdatesMobileViewMobileViewState();
}

class OrgUpdatesMobileViewMobileViewState
    extends ConsumerState<OrgUpdatesMobileView> {
  String? uploadedFilePath;
  String? uploadedFileName;

  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController mediaCaptionController = TextEditingController();
  final TextEditingController feedController = TextEditingController();
  final feedService = FeedService();
  bool isMediaSelect = false;
  bool isImageSelect = false;
  bool isVideoSelect = false;
  bool replaceImageTriggered = false; // Add this line

  String? selectedCategory;
  final ImagePicker imagePicker = ImagePicker();
  List<String> fileList = [];
  int? selectedIndex;
  List<XFile>? imageFileList = [];
  List<File>? _selectedPostImages;
  List<File>? get selectedPostImages => _selectedPostImages;
  String contentTypeSelected = "";
  bool isVisible = true; // Set this boolean based on your condition
  final FocusNode orgUpdateFocusNode = FocusNode();
  bool updateEditCategories = false;
  bool _isLoading = false;
  File? _imageFile;
  bool isLoadingImage = false;
  bool isEditngImage = false;
  bool isImageChange = false;

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
    if (widget.isEditOrgUpdate == true) {
      feedController.text =
          widget.orgUpdateItem?.content ?? feedController.text;
      isMediaSelect = widget.orgUpdateItem?.hasImage ?? false;
      isImageSelect = widget.orgUpdateItem?.hasImage ?? false;

      if (widget.isEditOrgUpdate == true &&
          !replaceImageTriggered &&
          widget.orgUpdateItem?.hasImage == true) {
        fileList.add(widget.orgUpdateItem!.imagePath.toString());
      }
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
        // replaceImageTriggered = true;
        imageAttachment(context);
        break;
      case ContentType.video:
        replaceImageTriggered = true;
        videoAttachment();
        break;
      case ContentType.document:
      // _selectDocuments();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          isLoadingImage = true;
          isImageChange = true;
        });

        _imageFile = File(pickedFile.path);
        if (widget.isEditOrgUpdate == true &&
            !replaceImageTriggered &&
            widget.orgUpdateItem?.imagePath != null) {
          fileList.remove(widget.orgUpdateItem!.imagePath.toString());
        }
        if (fileList.isNotEmpty) {
          fileList.remove(fileList[0]);
        }
        if (_imageFile != null) {
          fileList.add(_imageFile!.path);
        }

        final feedId = const Uuid().v4();
        Map<String, dynamic>? resultFileName = await feedService
            .uploadImageImagePickerNew(feedId, 'Image', source, _imageFile!);

        if (resultFileName != null) {
          setState(() {
                    replaceImageTriggered = true;
            isMediaSelect = true;
            isImageSelect = true;
            isVideoSelect = false;
            uploadedFilePath = resultFileName["platformFilePath"];
            uploadedFileName = resultFileName["mediaPath"];
          });
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print("Error while picking the image: $e");
    } finally {
      setState(() {
        isLoadingImage = false;
        isImageChange = false;
      });
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
    final categoryAsyncValue = ref.watch(categoriesProviderorgUpdates);
    if (categoryAsyncValue is AsyncData<List<String>>) {
      final orgUpdatesCategoryList = categoryAsyncValue;
      checkListItems = orgUpdatesCategoryList.value;
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
                        //Share your thoughts
                        // feedsDescriptionUI(context),
                        videoPickerContent(size),
                        if (isVisible) imagePickerContent(size),
                        const SizedBox(
                          height: 20,
                        ),
                        feedsDescriptionUI(context),

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

  //CARD - Feeds Descriotion
  Widget feedsDescriptionUI(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Focus on TextFormField when Container is tapped
        FocusScope.of(context).requestFocus(orgUpdateFocusNode);
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
                      focusNode: orgUpdateFocusNode,
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

              // //VIDEO
              // Visibility(
              //     visible: ((contentTypeSelected == ContentType.video.name) ||
              //             (contentTypeSelected == ''))
              //         ? true
              //         : false,
              //     child: TextButton.icon(
              //       onPressed: () {
              //         // isVisible = false;
              //         // _selectFile(ContentType.video);
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
    final orgUpdateID = widget.isEditOrgUpdate == true
        ? widget.orgUpdateItem?.orgUpdateId ?? const Uuid().v4()
        : const Uuid().v4();

    // if (widget.isEditOrgUpdate == true && !replaceImageTriggered && widget.orgUpdateItem?.imagePath != null) {
    //   fileList.add(widget.orgUpdateItem!.imagePath.toString());
    // }

    if (widget.isEditOrgUpdate == true && !replaceImageTriggered) {
      // if (widget.orgUpdateItem?.hasImage == true) {
      return fileList.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  OrgUpdateMediaView(item: widget.orgUpdateItem!),
                  Positioned(
                    top: -10,
                    right: 1,
                    child: IconButton(
                      onPressed: () {
                        dltImages(fileList[0]);
                        isMediaSelect = false;
                        isImageSelect = false;
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: AppColors.blueTextColour,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                _selectFile(ContentType.image);
              },
              child:Container(
              height: 210,
              width: size.width,
              padding: const EdgeInsets.all(15.0),
              color: Color(0xffBCADE9),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/icons8-add-image-64.png',
                    // width: 150,
                    // height: 150,
                  ),
                ],
              ),
            ));
      // }
      // return Container();
    } else {
      return fileList.isNotEmpty
          ? SizedBox(
              // height: size.height - 600,
              // height: 90,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child:

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
                                isMediaSelect = false;
                        isImageSelect = false;
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
          : GestureDetector(
              onTap: () {
                _selectFile(ContentType.image);
              },
              child:Container(
              height: 210,
              width: size.width,
              padding: const EdgeInsets.all(15.0),
              color: Color(0xffBCADE9),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/icons8-add-image-64.png',
                    // width: 150,
                    // height: 150,
                  ),
                ],
              ),
            )); // Return an empty container if fileList is empty
    }
  }

  // VIDEO Content
  Widget videoPickerContent(Size size) {
    return Container(
      padding: const EdgeInsets.all(10.0),
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
                          //  height: size.height - 600,
                          // height: 200,
                          // width: 200,
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
  void imageAttachment(BuildContext context) {
    isEditngImage = true;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0), // Adjusted SizedBox position
                    const Center(
                      child: Text(
                        'Image Picker',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Take Photo'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Choose from Gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(height: 150.0), // Adjusted SizedBox position
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      isEditngImage = false;
      isLoadingImage = false;
      setState(() {});
    });
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
      return FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.only(top: 0, right: 0),
            child: _imageFile == null
                ? GestureDetector(
              onTap: () {
                _selectFile(ContentType.image);
              },
              child:Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15.0),
                    color: Color(0xffBCADE9),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icons8-add-image-64.png',
                          // width: 150,
                          // height: 150,
                        ),
                      ],
                    ),
                ))
                : Image.file(_imageFile!),
           
          ));
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
  void _handleSubmit(PostOrgUpdateParams params, WidgetRef ref) async {
    try {
      if (widget.isEditOrgUpdate == true) {
        await ref.read(editOrgUpdateProvider(params).future);
      } else {
        await ref.read(postOrgUpdateProvider(params).future);
      }
      Navigator.pop(context);
      _resetValues();
    } catch (e) {
      // showMessage('Failed to post feed. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// POST BUTTON
  Widget btnPost(Size size) {
    return Stack(children: [
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
          // <-- OutlinedButton
 onPressed: _isLoading ? null : _handlePostButtonPress,
          // onPressed: () {
          //   //   FocusScopeNode currentFocus = FocusScope.of(context);
          //   // if (!currentFocus.hasPrimaryFocus &&
          //   //     currentFocus.focusedChild != null) {
          //   //   FocusManager.instance.primaryFocus!.unfocus();
          //   // }

          //   if (feedController.value.text.isEmpty) {
          //     showMessage('Please share your thoughts');
          //   }
          //   // else if (hashTagController == null ||
          //   //     hashTagController.value.text.isEmpty) {
          //   //   showMessage('Please add hashtag');
          //   // }
          //   else {
          //     if (isMediaSelect == false) {
          //       setState(() {
          //         _isLoading = true; // Show loader
          //       });
          //       createPostWithoutAttachment();
          //     } else {
          //       setState(() {
          //         _isLoading = true; // Show loader
          //       });
          //       createPostAttachments();
          //     }
          //   }
          // },
          //POSt Feed
          child: Text('Post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.normal,
              )),
        ),
      )
    ]);
  }

  void _handlePostButtonPress() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }

    if (feedController.value.text.isEmpty) {
      showMessage('Please share your thoughts');
    } else {
      setState(() {
        _isLoading = true;
      });
          if (isMediaSelect == false) {
      createPostWithoutAttachment();
          }else {
            createPostAttachments();
          }
    }
  }
  createPostWithoutAttachment() async {
    final orgId = const Uuid().v4();

    final params = PostOrgUpdateParams(
        userId: widget.user.userId,
        orgUpdateId: widget.isEditOrgUpdate == true
            ? widget.orgUpdateItem?.orgUpdateId ?? orgId
            : orgId,
        content: feedController.text,
        // category: "All Evoke",
        category: (widget.isEditOrgUpdate == true &&
                updateEditCategories == true)
            ? (selectedIndex != null)
                ? checkListItems[selectedIndex ?? 0]
                : widget.orgUpdateItem?.name ?? "All Evoke"
            : (widget.isEditOrgUpdate == true && updateEditCategories == false)
                ? widget.orgUpdateItem?.name ?? "All Evoke"
                : (selectedIndex != null)
                    ? checkListItems[selectedIndex ?? 0]
                    : "All Evoke",

        // category: (selectedIndex != null)
        //     ? checkListItems[selectedIndex ?? 0]
        //     : "General",
        media: false,
        hasImage: false,
        hasVideo: false);
    _handleSubmit(params, ref);
  }

  createPostAttachments() async {
    final orgId = const Uuid().v4();
    final params = PostOrgUpdateParams(
      userId: widget.user.userId,
      orgUpdateId: widget.isEditOrgUpdate == true
          ? widget.orgUpdateItem?.orgUpdateId ?? orgId
          : orgId,
      content: feedController.text,
      media: isMediaSelect,
      hasImage: isImageSelect,
      imagePath: uploadedFileName ?? "",
      mediaCaption: mediaCaptionController.text,
      hashTag: hashTagController.text,
      hasVideo: isVideoSelect,
      // category: "All Evoke",
      category: (widget.isEditOrgUpdate == true && updateEditCategories == true)
          ? (selectedIndex != null)
              ? checkListItems[selectedIndex ?? 0]
              : widget.orgUpdateItem?.name ?? "All Evoke"
          : (widget.isEditOrgUpdate == true && updateEditCategories == false)
              ? widget.orgUpdateItem?.name ?? "All Evoke"
              : (selectedIndex != null)
                  ? checkListItems[selectedIndex ?? 0]
                  : "All Evoke",

      // category: (selectedIndex != null)
      //     ? checkListItems[selectedIndex ?? 0]
      //     : "General",
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
                  // _resetValues();
                  if (text == 'OrgUpdate posted successfully') {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'),
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
        if (widget.isEditOrgUpdate == true) {
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
                // Text(
                //   (selectedIndex != null)
                //       ? checkListItems[selectedIndex ?? 0]
                //       : "All Evoke",
                //   style: TextStyle(
                //     color: const Color(0xffB54242),
                //     fontSize: 15.0,
                //     fontFamily: GoogleFonts.poppins().fontFamily,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                Text(
                  (widget.isEditOrgUpdate == true &&
                          updateEditCategories == true)
                      ? (selectedIndex != null)
                          ? checkListItems[selectedIndex ?? 0]
                          : widget.orgUpdateItem?.name ?? "All Evoke"
                      : (widget.isEditOrgUpdate == true &&
                              updateEditCategories == false)
                          ? widget.orgUpdateItem?.name ?? "All Evoke"
                          : (selectedIndex != null)
                              ? checkListItems[selectedIndex ?? 0]
                              : "All Evoke",
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
