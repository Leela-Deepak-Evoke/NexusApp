import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReviewMediaView extends ConsumerStatefulWidget {
  final Feed item;

  const ReviewMediaView({super.key, required this.item});
  @override
  ConsumerState<ReviewMediaView> createState() => _FeedMediaViewState();
}

class _FeedMediaViewState extends ConsumerState<ReviewMediaView> {
  VideoPlayerController? _controller;
  late String? mediaURL;

@override
  void initState() {
    super.initState();
    updateMedia();
  }

  @override
  void didUpdateWidget(ReviewMediaView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      updateMedia();
    }
  }

  void updateMedia() {
   
    if (widget.item.hasImage && widget.item.imagePath != null) {
      mediaURL = widget.item.imagePath;
      _controller?.dispose();
      _controller = null;
    } else if (widget.item.hasVideo && widget.item.videoPath != null) {
      mediaURL = widget.item.videoPath;
      _controller = VideoPlayerController.networkUrl(Uri.parse(mediaURL!))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        }).catchError((error) {
          print("video error");
          print(error);
        });
    } else {
      mediaURL = null;
      _controller?.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    if(mediaURL == null)
    {
        // return Image.asset('assets/images/placeholder.png',);
        return Container(
        height: 210,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15.0),
        color: Color(0xffBCADE9),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/icons8-add-image-64.png',
            ),
          ],
        ),
      );

    }

    final mediaURLAsyncValue = ref.watch(mediaUrlProvider(mediaURL!));

    return mediaURLAsyncValue.when(
      data: (mediaPath) {
        if (mediaPath != null && mediaPath.isNotEmpty) {
          if (widget.item.hasImage) {
              return GestureDetector(
              onTap: () {
                print('Image tapped!');
                showImageViewer(context, CachedNetworkImageProvider(mediaPath),
                    doubleTapZoomable: true);
              },
              child: CachedNetworkImage(
                imageUrl: mediaPath,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          } else if (widget.item.hasVideo) {
            if (_controller!.value.isInitialized) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  IconButton(
                    icon: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
        } else {
          return const SizedBox(height: 5.0);
        }
        return const SizedBox.shrink();
      },
      loading: () => const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) =>
          Text('An error occurred: $error'), // Handle error state appropriately
    );
  }
}
