// import 'dart:io';

// import 'package:evoke_nexus_app/app/models/feed.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';
// import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';

// class FeedMediaView extends ConsumerStatefulWidget {
//   final Feed item;

//   const FeedMediaView({super.key, required this.item});
//   @override
//   ConsumerState<FeedMediaView> createState() => _FeedMediaViewState();
// }

// class _FeedMediaViewState extends ConsumerState<FeedMediaView> {
//   VideoPlayerController? _controller;
//   late String? mediaURL;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.item.hasImage) {
//       if (mediaURL != null) {
//               mediaURL = widget.item.imagePath;
//       }
//       // mediaURL = widget.item.imagePath;
//     } else if (widget.item.hasVideo) {
//       mediaURL = widget.item.videoPath;

//       if (mediaURL != null) {
//         initializeVideo(mediaURL.toString());
//       }
//     }
//   }

//   void initializeVideo(String url) {
//     _controller = VideoPlayerController.file(File(url))
//       ..initialize().then((_) {
//         // _controller!.setVolume(0);
//         // _controller!.play();
//         setState(() {});
//       }).catchError((error) {
//         print("video error");
//         print(error);
//       });
//     ;
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaURLAsyncValue = ref.watch(mediaUrlProvider(mediaURL!));

//     return mediaURLAsyncValue.when(
//       data: (mediaPath) {
//         if (mediaPath != null && mediaPath.isNotEmpty) {
//           if (widget.item.hasImage) {
//             return Image.network(
//               mediaPath,
//               fit: BoxFit.contain,
//             );
//           } else if (widget.item.hasVideo) {
//             if (_controller!.value.isInitialized) {
//               return Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   AspectRatio(
//                     aspectRatio: _controller!.value.aspectRatio,
//                     child: VideoPlayer(_controller!),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       _controller!.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _controller!.value.isPlaying
//                             ? _controller!.pause()
//                             : _controller!.play();
//                       });
//                     },
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(
//                 child: SizedBox(
//                   height: 50.0,
//                   width: 50.0,
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }
//           }
//         } else {
//           return const SizedBox(height: 5.0);
//         }
//         return const SizedBox.shrink();
//       },
//       loading: () => const Center(
//         child: SizedBox(
//           height: 50.0,
//           width: 50.0,
//           child: CircularProgressIndicator(),
//         ),
//       ),
//       error: (error, stackTrace) =>
//           Text('An error occurred: $error'), // Handle error state appropriately
//     );
//   }
// }















import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';

class FeedMediaView extends ConsumerStatefulWidget {
  final Feed item;

  const FeedMediaView({super.key, required this.item});
  @override
  ConsumerState<FeedMediaView> createState() => _FeedMediaViewState();
}

class _FeedMediaViewState extends ConsumerState<FeedMediaView> {
  VideoPlayerController? _controller;
  late String? mediaURL;

  @override
  void initState() {
    super.initState();
    if (widget.item.hasImage && widget.item.imagePath != null ) {
      mediaURL = widget.item.imagePath;
    } else if (widget.item.hasVideo && widget.item.videoPath != null) {
      mediaURL = widget.item.videoPath;
      _controller = VideoPlayerController.networkUrl(Uri.parse(mediaURL!))
        ..initialize().then((_) {
          setState(() {});
        }).catchError((error) {
          print("video error");
          print(error);
        });
    }
    else
    {
      mediaURL = null;
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
        return Image.asset('assets/images/placeholder.png',);
    }

    final mediaURLAsyncValue = ref.watch(mediaUrlProvider(mediaURL!));

    return mediaURLAsyncValue.when(
      data: (mediaPath) {
        if (mediaPath != null && mediaPath.isNotEmpty) {
          if (widget.item.hasImage) {
            return Image.network(
              mediaPath,
              fit: BoxFit.contain,
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
