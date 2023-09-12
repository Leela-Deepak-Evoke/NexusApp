import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evoke_nexus_app/app/screens/feeds/feeds_screen.dart';
import 'package:evoke_nexus_app/app/widgets/common/mobile_custom_appbar.dart';


class HomeScreenSmall extends StatefulWidget {
  const HomeScreenSmall({Key? key}) : super(key: key);

  @override
  State<HomeScreenSmall> createState() => _HomeScreenSmallState();
}

class _HomeScreenSmallState extends State<HomeScreenSmall> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> headerNegativeOffset = ValueNotifier<double>(0);

    const double maxHeaderHeight = 250.0;
    const double bodyContentRatioMin = .8;
    const double bodyContentRatioMax = 1.0;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: <Widget>[
            Stack(children: [
              ValueListenableBuilder<double>(
                  valueListenable: headerNegativeOffset,
                  builder: (context, offset, child) {
                    return Transform.translate(
                      offset: Offset(0, offset * -1),
                      child: SizedBox(
                        height: maxHeaderHeight + 50,
                        width: size.width,
                        child: Image(
                          image: AssetImage('assets/images/navBarRect.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 115),
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
              NotificationListener<DraggableScrollableNotification>(
                child: Stack(
                  children: <Widget>[
                    DraggableScrollableSheet(
                      initialChildSize: bodyContentRatioMin,
                      minChildSize: bodyContentRatioMin,
                      maxChildSize: bodyContentRatioMax,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              alignment: AlignmentDirectional.center,
                              padding:
                                  const EdgeInsets.only(left: 0, right: 0, top: 0),
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                children: [
                                  buttonComponentsSetupLayout(size),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  lblLatestAndViewAll(),
                                  const SizedBox(
                                    height: 25,
                                  ),

                                  // LISTVIEW WITH API DATA
                                ],
                              ),
                              //endregion
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )
            ]),
            const MobileCustomAppbar()
          ],
        ) //drawer: Drawer(),
        );
  }

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
                              builder: (context) => const FeedsScreen()));
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
                    onPressed: () {},
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ForumScreen()));
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
                        //  Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           Ideas()));
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             OrgUpdates()));
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
  Widget lblLatestAndViewAll() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
            padding: const EdgeInsets.symmetric(
                horizontal: 5.0, vertical: 0.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(30.0),
                ),
                backgroundColor: Color(0xffF2722B),
                side: const BorderSide(
                    width: 1,
                    color: Color(0xffF2722B)),
              ),
          onPressed: () {
            //  Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => FeedsScreen()));
          },
          child: Text('View All',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,

                fontFamily:
                GoogleFonts.poppins()
                    .fontFamily,
                fontWeight: FontWeight.normal,
              )),
            ),
          ),
        ],
      ),
    );
  }

 

}
