import 'dart:io';
 
import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/feed_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/edit_profile.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/profile_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/review/widgets/review_media_view.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
 
class ReviewListMobile extends ConsumerStatefulWidget {
  final User user;
  String? searchQuery;
  bool? isFilter;
  String? selectedCategory;
 
  ReviewListMobile({
    super.key,
    required this.user,
    this.searchQuery,
    this.isFilter,
    this.selectedCategory,
  });
 
  @override
  _FeedListMobileViewState createState() => _FeedListMobileViewState();
}
 
class _FeedListMobileViewState extends ConsumerState<ReviewListMobile> {
  late Future<AsyncValue<List<Feed>>> filterFeedsFuture;
  List<Feed> publishedFeed = [];
  List<Feed> rejectedFeed = [];
  String showMode = 'All';
 
  @override
  void initState() {
    super.initState();
    updateShowMode('All');
  }
 
  void updateShowMode(String mode) {
    setState(() {
      showMode = mode;
    });
    print("Showing $showMode Data");
  }
 
  Color getColorForMode(String mode) {
    switch (mode) {
      case 'All':
        return Colors.green;
      case 'Published':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.white;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final feedsAsyncValue = ref.watch(feedsProvider(widget.user));
 
    if (feedsAsyncValue is AsyncData) {
      final items = feedsAsyncValue.value!;
      if (items.isEmpty) {
        // Handle the case where there is no data found
        return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
      } else {
        // Filter the items based on the search query
 
//Case-sensitive
        List<Feed> filteredItems = [];
       
 
        if (widget.searchQuery != "All" && widget.selectedCategory != "All") {
          filteredItems = items.where((item) {
            return (item.author
                        ?.toLowerCase()
                        .contains(widget.searchQuery?.toLowerCase() ?? '') ==
                    true) ||
                (item.name
                        .toLowerCase()
                        .contains(widget.searchQuery?.toLowerCase() ?? '') ==
                    true) ||
                (item.authorTitle
                        ?.toLowerCase()
                        .contains(widget.searchQuery?.toLowerCase() ?? '') ==
                    true) ||
                (item.content
                        ?.toLowerCase()
                        .contains(widget.searchQuery?.toLowerCase() ?? '') ==
                    true) ||
                (item.status
                        .toLowerCase()
                        .contains(widget.searchQuery?.toLowerCase() ?? '') ==
                    true);
          }).toList();
        } else if (widget.selectedCategory == "All" ||
            widget.searchQuery == "All") {
          filteredItems = List.from(items);
        }
 
        if (filteredItems.isEmpty) {
          return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
        } else {
          List getCurrentFeed() {
          switch (showMode) {
            case 'Published':
              return publishedFeed;
            case 'Rejected':
              return rejectedFeed;
            default:
              return filteredItems;
          }
        }
          for (var i = 0; i < filteredItems.length; i++) {
            if (filteredItems[i].status == 'PUBLISHED') {
              publishedFeed.add(filteredItems[i]);
            } else if (filteredItems[i].status == 'REJECTED') {
              rejectedFeed.add(filteredItems[i]);
            }
          }
          return Container(
              // alignment: AlignmentDirectional.topStart,
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Showing $showMode Feeds",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['All', 'Published', 'Rejected'].map((mode) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: showMode == mode
                                ? getColorForMode(mode)
                                : Colors.white,
                          ),
                          onPressed: () => updateShowMode(mode),
                          child: Text(
                            mode,
                            style: TextStyle(
                              color: showMode == mode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: getCurrentFeed().length,
            itemBuilder: (context, index) {
              final item = getCurrentFeed()[index];
              final author = item.author;
 
              return Card(
                margin: const EdgeInsets.all(5),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      leading: _profilePicWidget(item, ref),
                      minLeadingWidth: 0,
                      minVerticalPadding: 15,
                      title: Text(author ?? "", style: const TextStyle(fontSize: 16)),
                      onTap: () => navigateToProfile(item),
                      subtitle: Text(
                        "${item.authorTitle ?? ""} | ${Global.calculateTimeDifferenceBetween(Global.getDateTimeFromStringForPosts(item.postedAt.toString()))}",
                        style: TextStyle(
                          color: const Color(0xff676A79),
                          fontSize: 12.0,
                          fontFamily: GoogleFonts.notoSans().fontFamily,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildContent(item,index),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
                  if (Platform.isAndroid)
                    const SizedBox(
                      height: 60,
                    ),
                  if (Platform.isIOS)
                    const SizedBox(
                      height: 100,
                    ),
                ]),
              ));
        }
      }
    }
    if (feedsAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }
 
    if (feedsAsyncValue is AsyncError) {
      return ErrorScreen(showErrorMessage: true, onRetryPressed: retry);
    }
   
    return const SizedBox.shrink();
  }
 
  Widget buildContent(item,index) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 4.0),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: contentViewWidget(item),
      ),
      const SizedBox(height: 10.0),
      item.media ? ReviewMediaView(item: item) : const SizedBox(height: 2.0),
      const SizedBox(height: 4.0),
      btnSharingInfoLayout(context, index, item, ref),
      const SizedBox(height: 10.0),
    ],
  );
}
 
void navigateToProfile(item) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MobileLayout(
        title: 'User Profile',
        user: widget.user,
        hasBackAction: true,
        hasRightAction: item.authorId == widget.user.userId,
        topBarButtonAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserForm(
                user: widget.user,
                isFromWelcomeScreen: false,
              ),
            ),
          );
        },
        backButtonAction: () => Navigator.pop(context),
        child: ProfileMobileView(
          user: widget.user,
          context: context,
          otherUser: item,
          isFromOtherUser: true,
          onPostClicked: () {},
        ),
      ),
    ),
  );
}
 
  Widget hasTagViewWidget(Feed item) {
    if (item.hashTag != null) {
      return Text(item.hashTag!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }
 
  Widget contentViewWidget(Feed item) {
    if (item.content != null) {
      return Text(item.content!, style: const TextStyle(fontSize: 14));
    } else if (item.mediaCaption != null) {
      return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }
 
  Widget _profilePicWidget(Feed item, WidgetRef ref) {
    final String? authorName = item.author;
    if (authorName == null || authorName.isEmpty) {
      return CircleAvatar(radius: 20.0, child: Text('NO'));
    }
    // final avatarText = getAvatarText(item.author!);
    final avatarText = getAvatarText(authorName);
 
    if (item.authorThumbnail == null || item.authorThumbnail == "") {
      return CircleAvatar(radius: 20.0, child: Text(avatarText));
    } else {
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.authorThumbnail!));
 
      return Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                image: new AssetImage("assets/images/user_pic_s3_new.png"),
                fit: BoxFit.fill,
              )),
          child: profilePicAsyncValue.when(
            data: (imageUrl) {
              if (imageUrl != null && imageUrl.isNotEmpty) {
                if (_isProperImageUrl(imageUrl)) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: CachedNetworkImageProvider(imageUrl),
                    radius: 20.0,
                  );
                } else {
                  // Render text as a fallback when imageUrl is not proper
                  return CircleAvatar(
                    radius: 20,
                    child: Text(
                      avatarText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  );
                }
              } else {
                // Render a placeholder or an error image
                return CircleAvatar(
                  radius: 20,
                  child: Text(
                    avatarText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                );
              }
            },
            loading: () => const Center(
              child: SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => CircleAvatar(
                radius: 20.0,
                child: Text(avatarText)), // Handle error state appropriately
          ));
    }
  }
 
  bool _isProperImageUrl(String imageUrl) {
    if (imageUrl.contains('%20')) {
      return false;
    }
    return true;
  }
 
  String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }
 
// BUTTONS: REACT, COMMENT, SHARE
  Widget btnSharingInfoLayout(
      BuildContext context, int index, Feed item, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            print('Accepted item $index');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Accept',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            print('Rejected item $index');
 
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Reject"),
                  content:
                      const Text("Are you sure you want to reject this item?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Reject',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
 
// NUMBER OF VIEWS AND COMMENTS
  Widget getInfoOFViewsComments(int index, Feed item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () {
              if (item.likes != 0)
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    var params = GetCommentsParams(
                        userId: widget.user.userId,
                        postId: item.feedId,
                        postType: "Feed");
                    return LikesWidget(
                        user: widget.user,
                        spaceName: "Feed",
                        spaceId: item.feedId,
                        params: params);
                  },
                );
            },
            icon: Image.asset(
              'assets/images/reactions.png',
            ),
            label: Text(
              '${item.likes}',
              style: TextStyle(
                color: const Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: SizedBox(
                  height: 15,
                  width: 15,
                  child: Center(
                    child: Image.asset(
                      'assets/images/chat_bubble_outline.png',
                    ),
                  ),
                ),
                onPressed: () {
                  // _onCommentsPressed(item);
                },
                label: Text('${item.comments} comments',
                    style: TextStyle(
                      color: const Color(0xff676A79),
                      fontSize: 12.0,
                      fontFamily: GoogleFonts.notoSans().fontFamily,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
 
  Future<void> _onRefresh() async {
    ref.read(refresUserProvider(""));
    ref.watch(refresFeedsProvider(""));
  }
 
  void retry() {
    _onRefresh();
  }
 
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
 
    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
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