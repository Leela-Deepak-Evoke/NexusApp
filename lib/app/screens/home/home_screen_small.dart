import 'dart:async';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/userhome.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_home_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/home/home_latestupdate_mediaview.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/edit_profile.dart';
import 'package:evoke_nexus_app/app/screens/profile/widgets/profile_mobile_view.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/edit_delete_button.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evoke_nexus_app/app/widgets/common/mobile_custom_appbar.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/org_updates_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreenSmall extends ConsumerStatefulWidget {
  const HomeScreenSmall({Key? key}) : super(key: key);
  @override
  HomeScreenSmallState createState() => HomeScreenSmallState();
}

class HomeScreenSmallState extends ConsumerState<HomeScreenSmall> {
  User? user; // Nullable User
  AsyncValue<UserHome> userHomeAsyncValue = const AsyncValue.loading();

  void refreshScreen() {
    setState(() {});
  }

//REFRESH OF BOTH LISTS
  void retry() {
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    ref.read(refresUserProvider(""));
    ref.watch(refresUserHomeProvider(""));
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
        return const CircularProgressIndicator();
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
          _buildHeader(
              offset: headerNegativeOffset,
              size: size,
              userHomeAsyncValue: userHomeAsyncValue),
          _buildBody(
            userHomeAsyncValue: userHomeAsyncValue,
            size: size,
            bodyContentRatioMin: bodyContentRatioMin,
            bodyContentRatioMax: bodyContentRatioMax,
          ),
          const MobileCustomAppbar(),

          // Floating action button
          // Positioned(
          //   bottom: 100.0, // Adjust the position as needed
          //   right: 16.0, // Adjust the position as needed
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       _showToast(context);
          //     },
          //     backgroundColor: const Color(0XFF0707b5),
          //     child: Image.asset(
          //       'assets/images/evita.png',
          //       width: 50,
          //       height: 50,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      {required ValueNotifier<double> offset,
      required Size size,
      required AsyncValue userHomeAsyncValue}) {
    // final UserDetails? userDetails = userHomeAsyncValue.value?.userDetails; // Use null-aware operator ?. to access userDetails

    UserDetails? userDetails;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double spaceTopHeader = 115.0;

    if (Platform.isAndroid) {
      spaceTopHeader = screenWidth * 0.25; // For Android devices
    } else {
      // Check for iPhone SE based on logical screen dimensions
      bool isIPhoneSE = screenWidth == 375 &&
          screenHeight ==
              667; // iPhone SE 3rd generation has a logical size of 375x667 points

      if (isIPhoneSE) {
        spaceTopHeader = screenWidth * 0.2; // For iPhone SE
      } else {
        spaceTopHeader = screenWidth *
            0.3; // For other resolutions -- need to change for 8 plus
      }
    }

    if (userHomeAsyncValue is AsyncValue<UserHome>) {
      // Check if userHomeAsyncValue is of type AsyncValue<UserHome>
      final userHome =
          userHomeAsyncValue.value; // Access data property directly

      if (userHome != null) {
        userDetails = userHome.userDetails;
      } else {
        safePrint('userDetails -- : $userDetails'); //userDetails -- : null
      }
    } else {
      safePrint('UserHomeAsyncValue is not of type AsyncValue<UserHome>');
    }
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
                child: const Image(
                  image: AssetImage('assets/images/navBarRect.png'),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        if (userDetails !=
            null) // Check if userDetails is not null before accessing its properties

          Container(
            padding: EdgeInsets.only(left: 16, right: 0, top: spaceTopHeader),
            child: Wrap(direction: Axis.horizontal, spacing: 2, children: [
              _userProfilePic(userHomeAsyncValue as AsyncValue<UserHome>, ref),
              const SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userDetails != null ? "Hi, ${userDetails.name}!" : "Hi!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Welcome to Evoke Network!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
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
                    top: 0.0), // 10, 50 Add padding above the Container
                child: Container(
                  // color: Colors.amber,
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            // ExpandCollapseDemo(),
                            buttonComponentsSetupLayout(size),

                            Container(
                              width: size.width,
                              color: const Color(0xffF2F2F2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // lblChannelsJoin(),
                                  // cardForGridViewChannels(
                                  // context,
                                  // size,
                                  // userHomeAsyncValue
                                  //     as AsyncValue<UserHome>),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  lblLatestUpdates(),
                                  _latestUpdatesListView(
                                      context,
                                      userHomeAsyncValue
                                          as AsyncValue<UserHome>,
                                      size),
                                  const SizedBox(
                                    height: 20,
                                  ),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    // color: Colors.white,
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

  Widget _latestQuestionsListView(BuildContext context,
      AsyncValue<UserHome>? userHomeAsyncValue, Size size) {
    return Container(
      width: size.width,
      // height: calculateContainerHeight(userHomeAsyncValue,
      //     userHomeAsyncValue?.value?.latestQuestions ?? [], 140),
      alignment: AlignmentDirectional.topStart,
      child: userHomeAsyncValue!.when(
        data: (userHome) {
          final latestQuestion = userHome.latestQuestions;
          if (latestQuestion.isEmpty) {
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
                    SizedBox(
                      //  margin: const EdgeInsets.symmetric(vertical: 20),
                      height:
                          150, //180 -working if footerVIewWidget  More is there
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemExtent: 320,
                        itemCount: latestQuestion.length,
                        itemBuilder: (context, index) {
                          final item = latestQuestion[index];
                          final formattedDate = DateFormat('MMM d HH:mm')
                              .format(DateTime.parse(
                                      item.question.postedAt.toString())
                                  .toLocal());

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForumScreen(isFromHomePage: true)));
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
                                      // footerVIewWidget(formattedDate, item)
                                    ],
                                  )),
                            ),
                          );
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
            ErrorScreen(showErrorMessage: false, onRetryPressed: retry),
      ),
    );
  }

  Widget _latestUpdatesListView(BuildContext context,
      AsyncValue<UserHome>? userHomeAsyncValue, Size size) {
    return Container(
      width: size.width,
      // height: calculateContainerHeight(userHomeAsyncValue,
      //     userHomeAsyncValue?.value?.latestUpdates ?? [], 395), //455
      alignment: AlignmentDirectional.topStart,
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
                  const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 0, bottom: 0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: latestUpdates.length,
                  itemBuilder: (context, index) {
                    final item = latestUpdates[index];
                    final author = item.user.name;
                    bool isCurrentUser = item.user.identityId == user!.userId;
                    final formattedDate = DateFormat('MMM d HH:mm').format(
                      DateTime.parse(item.orgUpdate.postedAt.toString())
                          .toLocal(),
                    );

                    return InkWell(
                      onTap: () {
                        // Navigate to the detail screen here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrgUpdatesScreen(isFromHomePage: true)));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              ListTile(
                                leading:
                                    _profilePicWidget(item.user, false, ref),
                                minLeadingWidth: 0,
                                minVerticalPadding: 15,
                                title: Text(
                                  author,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MobileLayout(
                                              title: 'User Profile',
                                              user: user!,
                                              hasBackAction: true,
                                              hasRightAction:
                                                  item.user.userId ==
                                                          user!.userId
                                                      ? true
                                                      : false,
                                              topBarButtonAction: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserForm(
                                                                user: user!,
                                                                isFromWelcomeScreen:
                                                                    false)));
                                              },
                                              backButtonAction: () {
                                                Navigator.pop(context);
                                              },
                                              child: ProfileMobileView(
                                                user: user!,
                                                context: context,
                                                otherUser: item,
                                                isFromOtherUser: true,
                                                onPostClicked: () {},
                                              ),
                                            )),
                                  );
                                },
                                subtitle: Text(
                                  "${item.user.title} | $formattedDate",
                                  style: TextStyle(
                                    color: const Color(0xff676A79),
                                    fontSize: 12.0,
                                    fontFamily:
                                        GoogleFonts.notoSans().fontFamily,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                trailing: isCurrentUser &&
                                        (user!.role != 'Group' ||
                                            user!.role != 'Leader')
                                    ? SizedBox(
                                        width: 30,
                                        child: PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (String choice) {
                                            if (choice == 'Edit') {
                                              _editItem(item);
                                            } else if (choice == 'Delete') {
                                              _deleteItem(
                                                item,
                                                'OrgUpdate',
                                                item.orgUpdate.orgUpdateId,
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
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
                                                          .orgUpdateId,
                                                    );
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
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 0),
                                    child: contentViewWidget(item),
                                  ),
                                  const SizedBox(height: 12.0),

                                  item.orgUpdate.media
                                      ? HomeLatestUpdateMediaView(
                                          item: item.orgUpdate,
                                        )
                                      : const SizedBox(height: 2.0),
                                  // const SizedBox(height: 30.0),

                                  getInfoOFViewsComments(
                                      context, ref, index, item),
                                  // const Divider(
                                  //   thickness: 1.0,
                                  //   height: 1.0,
                                  // ),
                                  // btnSharingInfoLayout(
                                  //     context, index, item, ref),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  // separatorBuilder: (BuildContext context, int index) {
                  //   return const Divider();
                  // },
                ),
              ),
            );
          }
        },
        loading: () => const Center(
            // child: SizedBox(
            //   height: 50.0,
            //   width: 50.0,
            //   child: CircularProgressIndicator(),
            // ),
            ),
        error: (_, __) =>
            ErrorScreen(showErrorMessage: false, onRetryPressed: retry),
      ),
    );
  }

// HEIGHT OF BOTH LISTS
  double calculateContainerHeight(AsyncValue<UserHome>? userHomeAsyncValue,
      List<dynamic> data, double itemHeight) {
    if (userHomeAsyncValue is AsyncData<UserHome>) {
      return data.length * itemHeight;
    } else {
      return 50;
    }
  }

  Widget lblChannelsJoin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Text('Channels you like to join',
          style: TextStyle(
            color: const Color(0xff8E54E9),
            fontSize: 16.0,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          )),
    );
  }

// TOP HEADER 3 Labels
  Widget viewUsersInformation(
      AsyncValue<UserHome>? userHomeAsyncValue, Size size) {
    double fontSize = 12.0; // Default font size

    if (Platform.isAndroid) {
      fontSize = MediaQuery.of(context).size.width * 0.028;
    } else if (Platform.isIOS) {
      fontSize = 12;
    }

    return userHomeAsyncValue!.when(
      data: (userHome) {
        DateTime startDate = DateTime.parse(userHome.userDetails.createdAt);
        DateTime currentDate = DateTime.now();
        int differenceInDays = currentDate.difference(startDate).inDays;
        final lastLoginDate = DateFormat('MMM d').format(
          DateTime.parse(userHome.userDetails.lastLoginAt.toString()).toLocal(),
        );
        final horizontalPadding =
            size.width*0.01; // Adjust the percentage as needed
        return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 0),
            child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.start, //spaceEvenly
                children: [
                  //Calender
                  TextButton.icon(
                    onPressed: null, // Disable user interaction
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/icons8-calendar-plus-48.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                            width: 0), // Adjust spacing between icon and text
                      ],
                    ),
                    label: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        //"User Created At: ${user!.createdAt}",
                        Text(
                          Global.calculateTimeDifferenceBetween(
                              Global.getDateTimeFromStringForPosts(userHome
                                  .userDetails.createdAt
                                  .toString())), // Show the difference in days
                          style: TextStyle(
                            color: const Color(0xff292929),
                            fontSize: fontSize,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Active Time',
                          style: TextStyle(
                            color: const Color(0xff292929),
                            fontSize: fontSize,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Last Login

                  TextButton.icon(
                    onPressed: null, // Disable user interaction
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/last-login-48.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                            width: 0), // Adjust spacing between icon and text
                      ],
                    ),
                    label: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        Text(lastLoginDate, // Show the difference in days
                            style: TextStyle(
                              color: const Color(0xff292929),
                              fontSize: fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(
                          'Last Login',
                          style: TextStyle(
                            color: const Color(0xff292929),
                            fontSize: fontSize,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status
                  TextButton.icon(
                    onPressed: null, // Disable user interaction
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/status-48.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                            width: 0), // Adjust spacing between icon and text
                      ],
                    ),
                    label: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        Text(userHome.userDetails.status,
                            style: TextStyle(
                              color: const Color(0xff292929),
                              fontSize: fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(
                          'Status',
                          style: TextStyle(
                            color: const Color(0xff292929),
                            fontSize: fontSize,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]));
      },
      loading: () {
        return const Center();
        //  CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        return Text('Error: $error');
      },
    );
  }

  Widget viewPostInformation(AsyncValue<UserHome>? userHomeAsyncValue) {
    return userHomeAsyncValue!.when(
      data: (userHome) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Feed
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
                    const SizedBox(
                        width: 4), // Adjust spacing between icon and text
                  ],
                ),
                label: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the start
                  children: [
                    //"User Created At: ${user!.createdAt}",
                    Text(
                      '${userHome.postsCount.feeds}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Feed',
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

              // Feed Like Count

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
                    const SizedBox(
                        width: 4), // Adjust spacing between icon and text
                  ],
                ),
                label: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Text(
                      '${userHome.postsCount.feedLikeCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'FeedLike Count',
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

              // Status
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
                    const SizedBox(
                        width: 4), // Adjust spacing between icon and text
                  ],
                ),
                label: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Text(
                      '${userHome.postsCount.feedCommentCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'FeedComment Count',
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
      },
      loading: () {
        return const Center();
        //  CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        return Text('Error: $error');
      },
    );
  }

  Widget buttonComponentsSetupLayout(Size size) {
    double fontSize = 12.0;

    if (Platform.isAndroid) {
      fontSize = MediaQuery.of(context).size.width * 0.028;
    } else if (Platform.isIOS) {
      fontSize = 12;
    }
    return userHomeAsyncValue.when(
      data: (userHome) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4, // the size of the shadow
            shadowColor: Colors.black,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Activites',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
                viewUsersInformation(userHomeAsyncValue, size),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width / 25, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/feed.png',
                                width: 18,
                                height: 14,
                              ),
                              const SizedBox(
                                  width:
                                      8), // Add some space between the image and text
                              Text(
                                'Feed',
                                style: TextStyle(
                                  color: const Color(0xff292929),
                                  fontSize: fontSize,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/forum.png',
                                width: 18,
                                height: 14,
                              ),
                              const SizedBox(
                                  width:
                                      8), // Add some space between the image and text
                              Text(
                                'Forum',
                                style: TextStyle(
                                  color: const Color(0xff292929),
                                  fontSize: fontSize,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/updates.png',
                                width: 18,
                                height: 14,
                              ),
                              const SizedBox(
                                  width:
                                      8), // Add some space between the image and text
                              Text(
                                'Answer',
                                style: TextStyle(
                                  color: const Color(0xff292929),
                                  fontSize: fontSize,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width / 95, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userHome.postsCount.feeds} ${userHome.postsCount.feeds == 1 ? 'Post' : 'Posts'}',
                            style: TextStyle(
                              color: const Color(0xff292929),
                              fontSize: fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Forum Count
                          Text(
                            '${userHome.postsCount.questions} ${userHome.postsCount.questions == 1 ? 'Post' : 'Posts'}', // Conditional expression to display 'Post' or 'Posts'
                            style: TextStyle(
                              color: const Color(0xff292929),
                              fontSize: fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Answer Count
                          Text(
                            '${userHome.postsCount.answers} ${userHome.postsCount.answers == 1 ? 'Post' : 'Posts '}',
                            style: TextStyle(
                              color: const Color(0xff292929),
                              fontSize: fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width / 55, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${userHome.postsCount.feedLikeCount} ${userHome.postsCount.feedLikeCount == 1 ? 'Like' : 'Likes'}',
                                style: TextStyle(
                                  color: const Color(0xff292929),
                                  fontSize: fontSize,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Forum Like Count
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Set mainAxisAlignment to start
                            children: [
                              Text(
                                '-----',
                                style: TextStyle(
                                  color: const Color(0xff292929),
                                  fontSize: fontSize,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Answer Like Count
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Set mainAxisAlignment to start
                            children: [
                              Text(
                                '${userHome.postsCount.answerLikeCount} ${userHome.postsCount.answerLikeCount == 1 ? 'Like' : 'Likes'}',
                                style: TextStyle(
                                  color: const Color(0xff292929),
                                  fontSize: fontSize,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width / 45, vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${userHome.postsCount.feedCommentCount} ${userHome.postsCount.feedCommentCount == 1 ? 'Comment' : 'Comments'}',
                                  style: TextStyle(
                                    color: const Color(0xff292929),
                                    fontSize: fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Forum Comment Count
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // Set mainAxisAlignment to start
                              children: [
                                Text(
                                  '${userHome.postsCount.questionAnswerCount} ${userHome.postsCount.questionAnswerCount == 1 ? 'Comment' : 'Comments'}',
                                  style: TextStyle(
                                    color: const Color(0xff292929),
                                    fontSize: fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Answer Comment Count
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // Set mainAxisAlignment to start
                              children: [
                                Text(
                                  '${userHome.postsCount.answerCommentCount} ${userHome.postsCount.answerCommentCount == 1 ? 'Comment' : 'Comments'}',
                                  style: TextStyle(
                                    color: const Color(0xff292929),
                                    fontSize: fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        return const Center();
        // return CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        return Text('Error: $error');
      },
    );
  }

//GRID OF CHANNELS
  Widget viewHorizontalGridView() {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        // mainAxisSpacing: 0,
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
        margin: const EdgeInsets.only(right: 0),
        // color: Colors.red[300],
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80, //100
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Background color for icon
                  borderRadius: BorderRadius.circular(12),
                ),
                // child: Center(
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
                // ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2, // Set max lines to 2
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff676A79),
                    fontSize: 13.0,
                    fontFamily: GoogleFonts.notoSans().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ));
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
                ? const Icon(Icons.thumb_up)
                : Image.asset(
                    'assets/images/thumb_up.png',
                    width: 20,
                    height: 20,
                  )),
            label: Text(
              'Like',
              style: TextStyle(
                color: const Color(0xff393E41),
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
                color: const Color(0xff393E41),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ]);
  }

  // UPDATES NUMBER OF VIEWS AND COMMENTS
  Widget getInfoOFViewsComments(
      BuildContext context, WidgetRef ref, int index, LatestUpdate item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Align items to the end
        children: [
          // const Spacer(), // Add a spacer to push the button to the right
          Column(
            children: [
              // TextButton.icon(
              //   onPressed: null, // Disable user interaction
              //   icon: const SizedBox(
              //     // height: 15,
              //     // width: 15,
              //     child: Center(
              //       child: Icon(
              //         Icons.more_horiz,
              //         color: Color(0XFF0707b5),
              //       ),
              //     ),
              //   ),
              //   label: Text(
              //     'More',
              //     style: TextStyle(
              //       color: const Color(0XFF0707b5),
              //       fontSize: 12.0,
              //       fontFamily: GoogleFonts.notoSans().fontFamily,
              //       fontWeight: FontWeight.normal,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget contentViewWidget(LatestUpdate item) {
    if (item.orgUpdate.content != null) {
      return Text(item.orgUpdate.content, style: const TextStyle(fontSize: 14));
    }
    //  else if (item.orgUpdate.mediaCaption != null) {
    //   return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
    // }

    else {
      return const SizedBox(height: 5.0);
    }
  }

// Widget contentViewWidget(LatestUpdate item) {
//   if (item.orgUpdate.content != null) {
//     return Column(
//       children: [
//         Text(
//           item.orgUpdate.content,
//           style: const TextStyle(fontSize: 14),
//         ),
//         const SizedBox(height: 5.0), // Adding a bit of space after the text
//       ],
//     );
//   }
//   //  else if (item.orgUpdate.mediaCaption != null) {
//   //   return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
//   // }

//   else {
//     return const SizedBox(height: 5.0);
//   }
// }

//EDIT AND DELETE OF Updates
  void _editItem(LatestUpdate item) async {}

  void _onCommentsPressed(LatestUpdate item) {}

//COMMON PROFILE PIC METHODS
  Widget _profilePicWidget(UserList item, bool isQuestion, WidgetRef ref) {
    // final avatarText = getAvatarText(item.name);

    final String? authorName = item.name;
    if (authorName == null || authorName.isEmpty) {
      return CircleAvatar(radius: 20.0, child: Text('NO'));
    }
    final avatarText = getAvatarText(authorName);

    final double radius = isQuestion ? 12.0 : 20.0;

    final profilePicAsyncValue =
        ref.watch(authorThumbnailProvider(item.profilePicture!));

    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              image: new AssetImage("assets/images/user_pic_s3_new.png"),
              fit: BoxFit.fill,
            )),
        child: profilePicAsyncValue.when(
          data: (imageUrl) {
            if (imageUrl != null && imageUrl.isNotEmpty) {
              // Check if imageUrl is proper or not
              if (_isProperImageUrl(imageUrl)) {
                return CircleAvatar(
                  backgroundColor: Colors.transparent,
                  //backgroundImage: NetworkImage(imageUrl),
                  backgroundImage: CachedNetworkImageProvider(imageUrl),
                  radius: radius,
                );
              } else {
                return CircleAvatar(
                  radius: radius,
                  child: Text(
                    avatarText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                );
              }
            } else {
              return CircleAvatar(
                radius: radius,
                child: Text(
                  avatarText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              );
            }
          },
          loading: () => CircleAvatar(
            radius: radius,
            child:
                const CircularProgressIndicator(), // Placeholder for loading state
          ),
          error: (error, stackTrace) {
            // Render initials with a fallback text in case of error
            return CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: radius,
              child: Text(
                avatarText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            );
          },
        ));
  }

  bool _isProperImageUrl(String imageUrl) {
    // Check if the image URL contains spaces in the filename
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

  Widget _userProfilePic(
      AsyncValue<UserHome>? userHomeAsyncValue, WidgetRef ref) {
    final UserDetails? userDetails = userHomeAsyncValue?.value?.userDetails;
    final String avatarText =
        userDetails != null ? getAvatarText(userDetails.name) : "";

    if (userDetails != null) {
      final String? authorName = userDetails!.name;
      if (authorName == null || authorName.isEmpty) {
        return CircleAvatar(radius: 20.0, child: Text('NO'));
      }
      final avatarText = getAvatarText(authorName);
    } else {
      final String avatarText =
          userDetails != null ? getAvatarText(userDetails.name) : ""; //
    }

    if (userHomeAsyncValue?.value?.userDetails.profilePicture == null) {
      return CircleAvatar(radius: 20.0, child: Text(avatarText));
    } else {
      final profilePicAsyncValue = ref.watch(authorThumbnailProvider(
          userHomeAsyncValue?.value?.userDetails.profilePicture ?? ""));
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: Container(
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
                        // backgroundImage: NetworkImage(imageUrl),
                        backgroundImage: CachedNetworkImageProvider(imageUrl),
                        radius: 20,
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
                    // child: SizedBox(
                    //   height: 20.0,
                    //   width: 20.0,
                    //   child: CircularProgressIndicator(),
                    // ),
                    ),
                error: (error, stackTrace) => CircleAvatar(
                    radius: 20.0,
                    child:
                        Text(avatarText)), // Handle error state appropriately
              )));
    }
  }

//HEADER AND FOOTER OF LATEST QUESTIONS
  Wrap askedbyViewHeader(LatestQuestion item, WidgetRef ref) {
    bool isCurrentUser = item.user.userId == user!.userId;

    return Wrap(
      direction: Axis.horizontal,
      spacing: 2,
      children: [
        _profilePicWidget(item.user, true, ref),
        const SizedBox(
          width: 5,
        ),
        Text("Asked by",
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            )),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MobileLayout(
                        title: 'User Profile',
                        user: user!,
                        hasBackAction: true,
                        hasRightAction:
                            item.user.userId == user!.userId ? true : false,
                        topBarButtonAction: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserForm(
                                      user: user!,
                                      isFromWelcomeScreen: false)));
                        },
                        backButtonAction: () {
                          Navigator.pop(context);
                        },
                        child: ProfileMobileView(
                          user: user!,
                          context: context,
                          otherUser: item,
                          isFromOtherUser: true,
                          onPostClicked: () {},
                        ),
                      )),
            );
          },
          child: Text(
            isCurrentUser ? "me" : item.user.name ?? "",
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Wrap askedbyViewHeader_OLD(LatestQuestion item, WidgetRef ref) {
    bool isCurrentUser = item.user.userId == user!.userId;

    return Wrap(
      direction: Axis.horizontal,
      spacing: 2,
      children: [
        _profilePicWidget(item.user, true, ref),
        const SizedBox(
          width: 5,
        ),
        Text("Asked by",
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            )),
        Text(isCurrentUser ? "me" : item.user.name ?? "",
            style: TextStyle(
              color: const Color(0xff676A79),
              fontSize: 12.0,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.normal,
            )),
      ],
    );
  }

  Widget footerVIewWidget(String formattedDate, LatestQuestion item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Align items to the end
        children: [
          const Spacer(), // Add a spacer to push the button to the right
          Column(
            children: [
              TextButton.icon(
                onPressed: null, // Disable user interaction
                icon: const SizedBox(
                  // height: 15,
                  // width: 15,
                  child: Center(
                    child: Icon(
                      Icons.more_horiz,
                      color: Color(0XFF0707b5),
                    ),
                  ),
                ),
                label: Text(
                  'More',
                  style: TextStyle(
                    color: const Color(0XFF0707b5),
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
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Text(
    //       Global.calculateTimeDifferenceBetween(
    //           Global.getDateTimeFromStringForPosts(
    //               item.question.postedAt.toString())),
    //       style: TextStyle(
    //         color: Color(0xff676A79),
    //         fontSize: 12.0,
    //         fontFamily: GoogleFonts.notoSans().fontFamily,
    //         fontWeight: FontWeight.normal,
    //       ),
    //     ),
    //     TextButton.icon(
    //         onPressed: null, // Disable user interaction

    //         icon: Image.asset('assets/images/response.png'),
    //         label: Text(
    //           '${item.answers}',
    //           style: TextStyle(
    //             color: Color(0xff676A79),
    //             fontSize: 12.0,
    //             fontFamily: GoogleFonts.inter().fontFamily,
    //             fontWeight: FontWeight.normal,
    //           ),
    //         )),
    //     TextButton.icon(
    //       onPressed: () {
    //         _showToast(context);
    //       },
    //       icon: Image.asset(
    //         'assets/images/Vector-2.png',
    //         width: 20,
    //         height: 20,
    //       ),
    //       label: Text(
    //         'Report',
    //         style: TextStyle(
    //           color: Color(0xff393E41),
    //           fontFamily: GoogleFonts.inter().fontFamily,
    //           fontWeight: FontWeight.normal,
    //           fontSize: 14,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

//CATEGORIES AND CONTENT OF QUESTION LIST

  Widget contentViewWidgetQuestion(LatestQuestion item) {
    if (item.question.content != null) {
      var content = '';
      if (item.question.content.length > 30) {
        content = '${item.question.content.substring(0, 30)}...';
      } else {
        content = item.question.content;
      }
      return Text(content,
          maxLines: 1, // Limiting to 3 lines, adjust as needed
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
                  color: const Color(0xffB54242),
                  fontSize: 12.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(), // Add a Spacer widget to push the PopupMenuButton to the right.
          if (isCurrentUser)
            SizedBox(
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

  // TITLE $ BUTTON - LATEST UPDATES AND QUESTIONS,VIEWALL
  Widget lblLatestUpdates() {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Latest Updates',
              style: TextStyle(
                color: const Color(0xff8E54E9),
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
                backgroundColor: const Color(0xffF2722B),
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
                color: const Color(0xff8E54E9),
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
                backgroundColor: const Color(0xffF2722B),
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

// EDIT AND DELETE METHODS
  void _editItemQuestion(LatestQuestion item) {}

// Delete an item
  void _deleteItem(dynamic item, String label, String idPropValue) async {}

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

//PREVIOUS CODE FOR ALL SCREEN NAVIGATIONS - DONT DELETE BELOW CODE FOR NOW

// Card - BUTTONS CREATE PRODUCTS
// Widget buttonComponentsSetupLayout(Size size) {
//   return Padding(
//     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//     child: Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 4, // the size of the shadow
//       shadowColor: Colors.black,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: size.width / 25, vertical: 0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/feed.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 FeedsScreen(isFromHomePage: true)));
//                   },
//                 ),
//                 Text('Feed',
//                     style: TextStyle(
//                       color: Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/events.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     _showToast(context);
//                   },
//                 ),
//                 Text('Events',
//                     style: TextStyle(
//                       color: Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/forum.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 ForumScreen(isFromHomePage: true)));
//                   },
//                 ),
//                 Text('Forum',
//                     style: TextStyle(
//                       color: Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/ideas.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     _showToast(context);
//                   },
//                 ),
//                 Text('Ideas',
//                     style: TextStyle(
//                       color: Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/carpool2.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     _showToast(context);
//                   },
//                 ),
//                 Text('Car Pool',
//                     style: TextStyle(
//                       color: const Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/classifields.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     _showToast(context);
//                   },
//                 ),
//                 Text('Classifields',
//                     style: TextStyle(
//                       color: Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/updates.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => OrgUpdatesScreen()));
//                   },
//                 ),
//                 Text('Updates',
//                     style: TextStyle(
//                       color: Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 IconButton(
//                   icon: Image.asset(
//                     'assets/images/referrals.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     _showToast(context);
//                     //  Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) =>
//                     //             Referrals()));
//                   },
//                 ),
//                 Text('Referrals',
//                     style: TextStyle(
//                       color: Color(0xff292929),
//                       fontSize: 12.0,
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontWeight: FontWeight.w500,
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//         ],
//       ),
//     ),
//   );
// }

class ExpandCollapseDemo extends StatefulWidget {
  const ExpandCollapseDemo({super.key});

  @override
  _ExpandCollapseDemoState createState() => _ExpandCollapseDemoState();
}

class _ExpandCollapseDemoState extends State<ExpandCollapseDemo> {
  final List<Item> _data = generateItems(2);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = !isExpanded;
          });
        },
        children: _data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
                trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      item.isExpanded = !item.isExpanded;
                    });
                  },
                  child: Icon(
                    item.isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ),
              );
            },
            body: ListTile(
              title: Text(item.expandedValue),
              subtitle: const Text('Details about this item'),
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}









//   Widget _buildHeader_OLD(
//       {required ValueNotifier<double> offset,
//       required Size size,
//       required AsyncValue userHomeAsyncValue}) {
//     // final UserDetails? userDetails = userHomeAsyncValue!.value?.userDetails;
// final UserDetails? userDetails = userHomeAsyncValue.value?.userDetails;

//     return Stack(
//       children: [
//         ValueListenableBuilder<double>(
//           valueListenable: offset,
//           builder: (context, offset, child) {
//             return Transform.translate(
//               offset: Offset(0, offset * -1),
//               child: SizedBox(
//                 height: 250 + 50,
//                 width: size.width,
//                 child: Image(
//                   image: AssetImage('assets/images/navBarRect.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         ),
//         Container(
//           padding: const EdgeInsets.only(left: 16, right: 0, top: 115),
//           child: Wrap(direction: Axis.horizontal, spacing: 2, children: [
//             _userProfilePic(userHomeAsyncValue as AsyncValue<UserHome>, ref),
//             const SizedBox(
//               width: 5,
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
//                 child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start, // Align text to the start
//                     children: [
//                       Text(
//                         "Hi, ${userDetails!.name}!",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14.0,
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                       Text(
//                         "Welcome to Evoke Network!",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14.0,
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ])),
//             const SizedBox(height: 16),
//             // viewUsersInformation(userHomeAsyncValue),
//           ]),
//         )

//         // Container(
//         //   padding: EdgeInsets.only(left: 0, right: 0, top: 115),
//         //   child: Column(
//         //     crossAxisAlignment: CrossAxisAlignment.start,
//         //     children: [

//         //       Padding(
//         //         padding: const EdgeInsets.only(
//         //             left: 16), // Add padding only to the left
//         //         child: Text(
//         //           "Welcome to Evoke Network!",
//         //           style: TextStyle(
//         //             color: Colors.white,
//         //             fontSize: 14.0,
//         //             fontFamily: GoogleFonts.poppins().fontFamily,
//         //             fontWeight: FontWeight.w500,
//         //           ),
//         //           textAlign: TextAlign.left,
//         //         ),
//         //       ),
//         //       const SizedBox(
//         //           height:
//         //               16), // Add some space between the text and viewUsersInformation
//         //       // viewUsersInformation(userHomeAsyncValue),
//         //       //     viewPostInformation(userHomeAsyncValue)
//         //     ],
//         //   ),
//         // )
//       ],
//     );
//   }
