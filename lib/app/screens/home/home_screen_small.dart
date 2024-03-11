import 'package:evoke_nexus_app/app/models/delete.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/post_likedislike_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/userhome.dart';
import 'package:evoke_nexus_app/app/provider/delete_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/like_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_home_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/home/home_latestupdate_mediaview.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/edit_delete_button.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/view_likes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evoke_nexus_app/app/screens/feeds/feeds_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/mobile_custom_appbar.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/org_updates_screen.dart';
import 'package:intl/intl.dart';

class HomeScreenSmall extends ConsumerStatefulWidget {
  HomeScreenSmall({Key? key}) : super(key: key);

  // @override
  // _HomeScreenSmallState createState() => _HomeScreenSmallState();

  @override
  HomeScreenSmallState createState() => HomeScreenSmallState();
}

// class _HomeScreenSmallState extends ConsumerState<HomeScreenSmall> {

class HomeScreenSmallState extends ConsumerState<HomeScreenSmall> {
  User? user; // Nullable User
  AsyncValue<UserHome> userHomeAsyncValue = AsyncValue.loading();

  void refreshScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> headerNegativeOffset = ValueNotifier<double>(0);
    final userAsyncValue = ref.watch(fetchUserProvider);
    userAsyncValue.when(
      data: (data) {
        user = data;
        userHomeAsyncValue =
            ref.watch(userHomeProvider(user!)); // Update userHomeAsyncValue
      },
      loading: () {
        return CircularProgressIndicator();
      },
      error: (error, stackTrace) {},
    );

    const double maxHeaderHeight = 250.0;
    const double bodyContentRatioMin = .8;
    const double bodyContentRatioMax = 1.0;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: <Widget>[
          _buildHeader(offset: headerNegativeOffset, size: size),
          _buildBody(
            userHomeAsyncValue: userHomeAsyncValue,
            size: size,
            bodyContentRatioMin: bodyContentRatioMin,
            bodyContentRatioMax: bodyContentRatioMax,
          ),
          const MobileCustomAppbar(),

          // Floating action button
          Positioned(
            bottom: 100.0, // Adjust the position as needed
            right: 16.0, // Adjust the position as needed
            child: FloatingActionButton(
              onPressed: () {
                _showToast(context);
              },
              backgroundColor: const Color(0XFF0707b5),
              child: Image.asset(
                'assets/images/evita.png',
                width: 48,
                height: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      {required ValueNotifier<double> offset, required Size size}) {
    return Stack(
      children: [
        ValueListenableBuilder<double>(
          valueListenable: offset,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: Offset(0, offset * -1),
              child: SizedBox(
                height: 250 + 50,
                width: size.width,
                child: Image(
                  image: AssetImage('assets/images/navBarRect.png'),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.only(left: 0, right: 0, top: 115),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16), // Add padding only to the left
                child: Text(
                  "Welcome to Evoke Network!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                  height:
                      16), // Add some space between the text and viewUsersInformation
              viewUsersInformation(), // Place viewUsersInformation here
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBody({
    required AsyncValue userHomeAsyncValue,
    required Size size,
    required double bodyContentRatioMin,
    required double bodyContentRatioMax,
  }) {
    return NotificationListener<DraggableScrollableNotification>(
      child: Stack(
        children: <Widget>[
          DraggableScrollableSheet(
            initialChildSize: bodyContentRatioMin,
            minChildSize: bodyContentRatioMin,
            maxChildSize: bodyContentRatioMax,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 50.0), // Add padding above the Container
                child: Container(
                  // color: Colors.amber,
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: size.width,
                              color: Color(0xffF2F2F2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  lblChannelsJoin(),
                                  cardForGridViewChannels(
                                      context,
                                      size,
                                      userHomeAsyncValue
                                          as AsyncValue<UserHome>),
                                  lblLatestUpdates(),
                                  _latestUpdatesListView(
                                      context, userHomeAsyncValue, size),
                                  lblLatestQuestions(),
                                  _latestQuestionsListView(
                                      context, userHomeAsyncValue, size),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

// Card - BUTTONS CREATE PRODUCTS

  Widget cardForGridViewChannels(BuildContext context, Size size,
      AsyncValue<UserHome> userHomeAsyncValue) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // elevation: 4, // the size of the shadow
        // shadowColor: Colors.black,
        elevation: 2, // the size of the shadow
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    child: viewHorizontalGridView(),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 10, //size.height,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _latestUpdatesListView_OLD(BuildContext context,
      AsyncValue<UserHome>? userHomeAsyncValue, Size size) {
    return Container(
      width: size.width,
      height: calculateContainerHeight(userHomeAsyncValue,
          userHomeAsyncValue?.value?.latestUpdates ?? [], 455),
      alignment: AlignmentDirectional.topStart,
      child: userHomeAsyncValue!.when(
        data: (userHome) {
          final latestUpdates = userHome.latestUpdates;
          if (latestUpdates.isEmpty) {
            // return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Container(
              alignment: AlignmentDirectional.topStart,
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemExtent: 380, // Set horizontal scrolling
                      itemCount: latestUpdates.length,
                      itemBuilder: (context, index) {
                        final item = latestUpdates[index];
                        final author = item.user.name;
                        final formattedDate = DateFormat('MMM d HH:mm').format(
                            DateTime.parse(item.orgUpdate.postedAt.toString())
                                .toLocal());

                        bool isCurrentUser =
                            item.user.identityId == user!.userId;
                        return Card(
                          margin: const EdgeInsets.all(12),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            // padding: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: _profilePicWidget(
                                      item, ref), // Implement this function
                                  title: Text(author,
                                      style: const TextStyle(fontSize: 16)),
                                  subtitle: Text(
                                    "${item.orgUpdate.content} | ${formattedDate}",
                                    style: TextStyle(
                                      color: Color(0xff676A79),
                                      fontSize: 12.0,
                                      fontFamily:
                                          GoogleFonts.notoSans().fontFamily,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  trailing: isCurrentUser &&
                                          (user!.role != 'Group' ||
                                              user!.role != 'Leader')
                                      ? Container(
                                          width:
                                              30, // Adjust the width as needed
                                          child: PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert),
                                            onSelected: (String choice) {
                                              if (choice == 'Edit') {
                                                _editItem(item);
                                              } else if (choice == 'Delete') {
                                                _deleteItem(item, 'OrgUpdate',
                                                    item.orgUpdate.orgUpdateId);
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) {
                                              return <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  value: 'Edit',
                                                  child: EditButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _editItem(item);
                                                    },
                                                  ),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'Delete',
                                                  child: DeleteButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _deleteItem(
                                                          item,
                                                          'OrgUpdate',
                                                          item.orgUpdate
                                                              .orgUpdateId);
                                                    },
                                                  ),
                                                ),
                                              ];
                                            },
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 8.0),
                                contentViewWidget(item),
                                const SizedBox(height: 8.0),
                                item.orgUpdate.media
                                    ? AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: HomeLatestUpdateMediaView(
                                            item: item
                                                .orgUpdate), // Implement this widget
                                      )
                                    : const SizedBox(height: 2.0),
                                const SizedBox(height: 8.0),
                                getInfoOFViewsComments(context, ref, index,
                                    item), // Implement this function
                                const SizedBox(height: 8.0),
                                const Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                btnSharingInfoLayout(context, index, item,
                                    ref), // Implement this function
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ]),
              ),
            );
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) =>
            ErrorScreen(showErrorMessage: true, onRetryPressed: retry),
      ),
    );
  }

  Widget _latestQuestionsListView(BuildContext context,
      AsyncValue<UserHome>? userHomeAsyncValue, Size size) {
    return Container(
      width: size.width,
      height: calculateContainerHeight(userHomeAsyncValue,
          userHomeAsyncValue?.value?.latestQuestions ?? [], 140),
      alignment: AlignmentDirectional.topStart,
      child: userHomeAsyncValue!.when(
        data: (userHome) {
          final latestQuestion = userHome.latestQuestions;
          if (latestQuestion.isEmpty) {
            // return ErrorScreen(showErrorMessage: false, onRetryPressed: retry);
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Container(
                alignment: AlignmentDirectional.topStart,
                padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Column(children: [
                    Expanded(
                      child: ListView.builder(
                        // Set horizontal scrolling
                        scrollDirection: Axis.horizontal,
                        // Set itemExtent to ensure fixed height for each child
                        itemExtent: 320, // Adjust the value as needed
                        itemCount: latestQuestion.length,
                        itemBuilder: (context, index) {
                          final item = latestQuestion[index];
                          final formattedDate = DateFormat('MMM d HH:mm')
                              .format(DateTime.parse(
                                      item.question.postedAt.toString())
                                  .toLocal());

                          return InkWell(
                              onTap: () {
                                // context.goNamed(
                                //   AppRoute.answersforum.name,
                                //   extra: item,
                                // );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(12),
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        categoryHearViewWidget(item),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        contentViewWidgetQuestion(item),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        askedbyViewHeader(item, ref),
                                        footerVIewWidget(formattedDate, item)
                                      ],
                                    )),
                              ));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ]),
                ));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) =>
            ErrorScreen(showErrorMessage: true, onRetryPressed: retry),
      ),
    );
  }

  double calculateContainerHeight(AsyncValue<UserHome>? userHomeAsyncValue,
      List<dynamic> data, double itemHeight) {
    if (userHomeAsyncValue is AsyncData<UserHome>) {
      return data.length * itemHeight;
    } else {
      return 50;
    }
  }

  void retry() {
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    ref.read(refresUserProvider(""));
    ref.watch(refresUserHomeProvider(""));
  }

  Widget lblChannelsJoin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Text('Channels you like to join',
          style: TextStyle(
            color: Color(0xff8E54E9),
            fontSize: 16.0,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          )),
    );
  }

// 3 Labels
  Widget viewUsersInformation() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Calender
          TextButton.icon(
              onPressed: null, // Disable user interaction
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/icons8-calendar-plus-48.png',
                  width: 38,
                  height: 38,
                ),
                SizedBox(width: 4), // Adjust spacing between icon and text
              ],
            ),
            label: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  '4,368',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Days with Evoke',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // UTILIOZ

          TextButton.icon(
              onPressed: null, // Disable user interaction
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/icons8-heart-64.png',
                  width: 38,
                  height: 38,
                ),
                SizedBox(width: 4), // Adjust spacing between icon and text
              ],
            ),
            label: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  '70',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Likes',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // BADGES
          TextButton.icon(
              onPressed: null, // Disable user interaction
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/icons8-hashtag-activity-grid-96.png',
                  width: 38,
                  height: 38,
                ),
                SizedBox(width: 4), // Adjust spacing between icon and text
              ],
            ),
            label: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ]);
  }

  Widget viewHorizontalGridView() {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 0.99,
        crossAxisSpacing: 1,

        // width / height: fixed for *all* items
        childAspectRatio: 0.99,
      ),
      itemBuilder: (context, index) {
        return _buildGridItem(index); // Build individual grid item
      },
    );
  }

  Widget _buildGridItem(int index) {
    String iconAsset;
    String label;

    // Determine icon and label based on the index
    switch (index) {
      case 0:
        iconAsset = 'assets/images/microsoft.png';
        label = 'Microsoft Hub';
        break;
      case 1:
        iconAsset = 'assets/images/python.png';
        label = 'Python Panthers';
        break;
      case 2:
        iconAsset = 'assets/images/CSR.png';
        label = 'CSR';
        break;
      case 3:
        iconAsset = 'assets/images/diversity.png';
        label = 'Diversity & Inclusion';
        break;
      default:
        iconAsset = 'assets/images/default_icon.png';
        label = 'Label $index';
    }

    return Container(
      // width: 200,
      // height: 200,
      // margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80, //100
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Background color for icon
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white, // Background color for icon
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      iconAsset,
                      width: 55, //75// Adjust icon size as needed
                      height: 55,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2, // Set max lines to 2
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xff676A79),
                  fontSize: 13.0,
                  fontFamily: GoogleFonts.notoSans().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//List View Methods of Updates
// BUTTONS: REACT, COMMENT, SHARE
  Widget btnSharingInfoLayout(
      BuildContext context, int index, LatestUpdate item, WidgetRef ref) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
              onPressed: null, // Disable user interaction

            icon: (item.currentUserLiked
                ? Icon(Icons.thumb_up)
                : Image.asset(
                    'assets/images/thumb_up.png',
                    width: 20,
                    height: 20,
                  )),
            label: Text(
              'Like',
              style: TextStyle(
                color: Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          TextButton.icon(
                         onPressed: null, // Disable user interaction

            icon: Image.asset(
              'assets/images/chat_bubble_outline.png',
              width: 20,
              height: 20,
            ),
            label: Text(
              'Comment',
              style: TextStyle(
                color: Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ]);
  }

  // NUMBER OF VIEWS AND COMMENTS
  Widget getInfoOFViewsComments(
      BuildContext context, WidgetRef ref, int index, LatestUpdate item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  var params = GetCommentsParams(
                      userId: user!.userId,
                      postId: item.orgUpdate.orgUpdateId,
                      postType: "OrgUpdate");

                  return LikesWidget(
                      user: user!,
                      spaceName: "OrgUpdate",
                      spaceId: item.orgUpdate.orgUpdateId,
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
                color: Color(0xff676A79),
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
                // <-- TextButton
              onPressed: null, // Disable user interaction
                icon: SizedBox(
                  height: 15,
                  width: 15,
                  child: Center(
                    child: Image.asset(
                      'assets/images/chat_bubble_outline.png',
                    ),
                  ),
                ),
                label: Text(
                  '${item.comments} comments',
                  style: TextStyle(
                    color: Color(0xff676A79),
                    fontSize: 12.0,
                    fontFamily: GoogleFonts.notoSans().fontFamily,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget contentViewWidget(LatestUpdate item) {
    if (item.orgUpdate.content != null) {
      return Text(item.orgUpdate.content!,
          style: const TextStyle(fontSize: 14));
    }
    //  else if (item.orgUpdate.mediaCaption != null) {
    //   return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
    // }

    else {
      return const SizedBox(height: 5.0);
    }
  }

  void _editItem(LatestUpdate item) async {
    // var result = Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     fullscreenDialog: true,
    //     builder: (context) =>
    //         CreatePostFeedScreen(feedItem: item, isEditFeed: true),
    //   ),
    // );
    // await ref.read(feedsProvider(user).future);
    // await _onRefresh();
  }

  void _onCommentsPressed(LatestUpdate item) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         fullscreenDialog: true,
    //         builder: (context) => CommentScreen(
    //               headerCard: FeedHeaderCardView(item: item, ref: ref),
    //               postId: item.feedId,
    //               posttype: "Feed",
    //             )));
  }

  Widget _profilePicWidget(dynamic item, WidgetRef ref) {
    final bool isQuestion = item is LatestQuestion;
    final String name = isQuestion ? item.question.name! : item.orgUpdate.name!;
    final String avatarText = getAvatarText(name);

    final double radius = isQuestion ? 12.0 : 20.0;

    if (item.user.profilePicture == null) {
      return CircleAvatar(radius: radius, child: Text(avatarText));
    } else {
      // Note: We're using `watch` directly on the provider.
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.user.profilePicture!));

      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            return CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: radius,
              child: Text(
                avatarText,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: radius, child: Text(avatarText));
          }
        },
        loading: () => Center(
          child: SizedBox(
            height: isQuestion ? 30.0 : 20.0,
            width: isQuestion ? 30.0 : 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
          radius: radius,
          child: Text(avatarText),
        ), // Handle error state appropriately
      );
    }
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

//QUESTION LIST
  Widget categoryHearViewWidget(LatestQuestion item) {
    bool isCurrentUser = item.question.questionId == user!.userId;

    return Container(
      child: Row(
        children: [
          Wrap(
            spacing: 5,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const CircleAvatar(
                radius: 3,
                backgroundColor: Color(0xffB54242),
              ),
              Text(
                item.question.category ?? "General",
                style: TextStyle(
                  color: Color(0xffB54242),
                  fontSize: 12.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Spacer(), // Add a Spacer widget to push the PopupMenuButton to the right.
          if (isCurrentUser)
            Container(
              width: 30, // Adjust the width as needed
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                ),
                onSelected: (String choice) {
                  // Handle button selection here
                  if (choice == 'Edit') {
                    _editItemQuestion(item); // Call the edit function
                  } else if (choice == 'Delete') {
                    _deleteItem(item, 'Question', item.question.questionId);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: EditButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _editItemQuestion(item); // Call the edit function
                        },
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: DeleteButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteItem(
                              item, 'Question', item.question.questionId);
                        },
                      ),
                    ),
                  ];
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget contentViewWidgetQuestion(LatestQuestion item) {
    if (item.question.content != null) {
      var content = '';
      if (item.question.content!.length > 32) {
        content = '${item.question.content!.substring(0, 32)}...';
      } else {
        content = item.question.content!;
      }
      return Text(content,
          maxLines: 3, // Limiting to 3 lines, adjust as needed
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
          ));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

// Edit an item
  void _editItemQuestion(LatestQuestion item) {
    // Implement your edit logic here, e.g., navigate to the edit screen

    // setState(() {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         fullscreenDialog: true,
    //         builder: (context) => CreatePostForumScreen(
    //             questionItem: item, isEditQuestion: true)),
    //   );
    // });
  }

// Delete an item
  void _deleteItem(dynamic item, String label, String idPropValue) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                try {
                  final deleteParams = Delete(
                    label: label,
                    idPropValue: idPropValue,
                    userId: user!.userId,
                  );
                  await ref.read(deleteProvider(deleteParams).future);
                  await _onRefresh();
                } catch (error) {
                  print("Error deleting item: $error");
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Wrap askedbyViewHeader(LatestQuestion item, WidgetRef ref) {
    bool isCurrentUser = item.user.userId == user!.userId;

    return Wrap(
      direction: Axis.horizontal,
      spacing: 2,
      children: [
        _profilePicWidget(item, ref),
        const SizedBox(
          width: 5,
        ),
        Text("Asked by",
            style: TextStyle(
              color: Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            )),
        Text(isCurrentUser ? "me" : item.user.name ?? "",
            style: TextStyle(
              color: Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            )),
      ],
    );
  }

  Widget footerVIewWidget(String formattedDate, LatestQuestion item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Global.calculateTimeDifferenceBetween(
              Global.getDateTimeFromStringForPosts(
                  item.question.postedAt.toString())),
          style: TextStyle(
            color: Color(0xff676A79),
            fontSize: 12.0,
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontWeight: FontWeight.normal,
          ),
        ),
        TextButton.icon(
                         onPressed: null, // Disable user interaction

            icon: Image.asset('assets/images/response.png'),
            label: Text(
              '${item.answers}',
              style: TextStyle(
                color: Color(0xff676A79),
                fontSize: 12.0,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            )),
        TextButton.icon(
          onPressed: () {
            _showToast(context);
          },
          icon: Image.asset(
            'assets/images/Vector-2.png',
            width: 20,
            height: 20,
          ),
          label: Text(
            'Report',
            style: TextStyle(
              color: Color(0xff393E41),
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  //Previ
  // Card - BUTTONS CREATE PRODUCTS
  Widget buttonComponentsSetupLayout(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4, // the size of the shadow
        shadowColor: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width / 25, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/feed.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FeedsScreen(isFromHomePage: true)));
                    },
                  ),
                  Text('Feed',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/events.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _showToast(context);
                    },
                  ),
                  Text('Events',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/forum.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ForumScreen(isFromHomePage: true)));
                    },
                  ),
                  Text('Forum',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/ideas.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _showToast(context);
                    },
                  ),
                  Text('Ideas',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/carpool2.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _showToast(context);
                    },
                  ),
                  Text('Car Pool',
                      style: TextStyle(
                        color: const Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/classifields.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _showToast(context);
                    },
                  ),
                  Text('Classifields',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/updates.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrgUpdatesScreen()));
                    },
                  ),
                  Text('Updates',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/referrals.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _showToast(context);
                      //  Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             Referrals()));
                    },
                  ),
                  Text('Referrals',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  // TITLE $ BUTTON - LATESTUPDATES,VIEWALL
  Widget lblLatestUpdates() {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Latest Updates',
              style: TextStyle(
                color: Color(0xff8E54E9),
                fontSize: 16.0,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              )),
          Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: Color(0xffF2722B),
                side: const BorderSide(width: 1, color: Color(0xffF2722B)),
              ),
              onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrgUpdatesScreen(isFromHomePage: true)));
              },
              child: Text('View All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.normal,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget lblLatestQuestions() {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Latest Questions',
              style: TextStyle(
                color: Color(0xff8E54E9),
                fontSize: 16.0,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              )),
                Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: Color(0xffF2722B),
                side: const BorderSide(width: 1, color: Color(0xffF2722B)),
              ),
              onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ForumScreen(isFromHomePage: true)));
              },
              child: Text('View All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.normal,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        // content: const Text('Added to favorite'),
        content: const SizedBox(
          height: 70,
          child: Text('In Progress Evita'),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget _latestUpdatesListView(BuildContext context,
      AsyncValue<UserHome>? userHomeAsyncValue, Size size) {
    return Container(
      width: size.width,
      height: calculateContainerHeight(userHomeAsyncValue,
          userHomeAsyncValue?.value?.latestUpdates ?? [], 455), //455
      alignment: AlignmentDirectional.topStart,
      // color: Colors.grey,
      child: userHomeAsyncValue!.when(
        data: (userHome) {
          final latestUpdates = userHome.latestUpdates;
          if (latestUpdates.isEmpty) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Container(
                alignment: AlignmentDirectional.topStart,
                padding:
                    const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Column(children: [
                    Expanded(
                        child: ListView.separated(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: 0),
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Set the physics property

                      //               scrollDirection: Axis.horizontal,
                      // itemExtent: 380, // Set horizontal scrolling

                      itemCount: latestUpdates.length,
                      itemBuilder: (context, index) {
                        final item = latestUpdates[index];
                        final author = item.user.name;

                        final formattedDate = DateFormat('MMM d HH:mm').format(
                            DateTime.parse(item.orgUpdate.postedAt.toString())
                                .toLocal());

                        bool isCurrentUser =
                            item.user.identityId == user!.userId;
                        return Card(
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: _profilePicWidget(item, ref),
                                  title: Text(author!,
                                      style: const TextStyle(fontSize: 16)),
                                  subtitle: Text(
                                    "${item.orgUpdate.content!} | ${formattedDate}",
                                    style: TextStyle(
                                      color: Color(0xff676A79),
                                      fontSize: 12.0,
                                      fontFamily:
                                          GoogleFonts.notoSans().fontFamily,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  trailing: isCurrentUser &&
                                          (user!.role != 'Group' ||
                                              user!.role != 'Leader')
                                      ? Container(
                                          width:
                                              30, // Adjust the width as needed
                                          child: PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert),
                                            onSelected: (String choice) {
                                              if (choice == 'Edit') {
                                                _editItem(item);
                                              } else if (choice == 'Delete') {
                                                _deleteItem(item, 'OrgUpdate',
                                                    item.orgUpdate.orgUpdateId);
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) {
                                              return <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  value: 'Edit',
                                                  child: EditButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _editItem(item);
                                                    },
                                                  ),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'Delete',
                                                  child: DeleteButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _deleteItem(
                                                          item,
                                                          'OrgUpdate',
                                                          item.orgUpdate
                                                              .orgUpdateId);
                                                    },
                                                  ),
                                                ),
                                              ];
                                            },
                                          ),
                                        )
                                      : null,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4.0),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                                        child: contentViewWidget(item)),
                                    // Padding(
                                    //     padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                    //     child: hasTagViewWidget(item)),

                                    //const SizedBox(height: 4.0),
                                    item.orgUpdate.media
                                        ? AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: HomeLatestUpdateMediaView(
                                                item: item
                                                    .orgUpdate), // Implement this widget
                                          )
                                        : const SizedBox(height: 2.0),
                                    const SizedBox(height: 4.0),
                                    // const Divider(
                                    //   thickness: 1.0,
                                    //   height: 1.0,
                                    // ),

                                    //LikesWidget comment
                                    getInfoOFViewsComments(
                                        context, ref, index, item),
                                    const Divider(
                                      thickness: 1.0,
                                      height: 1.0,
                                    ),
                                    btnSharingInfoLayout(
                                        context, index, item, ref)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    )),
                    // const SizedBox(
                    //   height: 100,
                    // )
                  ]),
                ));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) =>
            ErrorScreen(showErrorMessage: true, onRetryPressed: retry),
      ),
    );
  }
}
