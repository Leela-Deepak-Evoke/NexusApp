import 'package:evoke_nexus_app/app/screens/welcome/welcome_screen.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/authentication_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreenSmall extends ConsumerStatefulWidget {
  const LoginScreenSmall({super.key});

  @override
  ConsumerState<LoginScreenSmall> createState() => _LoginScreenSmallState();
}

class _LoginScreenSmallState extends ConsumerState<LoginScreenSmall>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  double _opacity = 0.0;

  //Slider Page
  int _index = 0;
  final PageController _pageController = PageController(viewportFraction: 1);
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
        setState(() {
          _opacity = _animationController!.value;
        });
      });

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authenticationServiceProvider);
    print(authService);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
        ),
        Container(
          // height: 200,
          // width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Onboarding.png"),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          // padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(top: 120),
            child: MyPageView(),
          ),

          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     Expanded(
          //       flex: 6,
          //       child: Center(
          //         child: Column(
          //           children: [
          //             Expanded(
          //               child:
          //                Container(
          //                 child: PageView.builder(
          //                   itemCount: 2,
          //                   controller: PageController(viewportFraction: 0.7),
          //                   onPageChanged: (int index) => setState(() {
          //                     _index = index;
          //                     _activePage = index;
          //                   }),
          //                   itemBuilder: (_, i) {
          //                     return Transform.scale(
          //                         scale: i == _index ? 1 : 0.7,
          //                         child: Wrap(
          //                             spacing: 20,
          //                             alignment: WrapAlignment.center,
          //                             crossAxisAlignment:
          //                                 WrapCrossAlignment.center,
          //                             runAlignment: WrapAlignment.center,
          //                             children: [
          //                               Expanded(
          //                                   child: Column(
          //                                 children: <Widget>[
          //                                   if (i != 1) ...[
          //                                     Text(
          //                                         'Share your Knowledge, Ask queries',
          //                                         textAlign: TextAlign.center,
          //                                         style: TextStyle(
          //                                           color: Colors.white,
          //                                           fontSize: 26.0,
          //                                           fontFamily:
          //                                               GoogleFonts.poppins()
          //                                                   .fontFamily,
          //                                           fontWeight: FontWeight.w600,
          //                                         )),
          //                                     SizedBox(
          //                                       height: 50,
          //                                     ),
          //                                     Image.asset(
          //                                         'assets/images/peopleTech.png'),
          //                                   ] else ...[
          //                                     Text(
          //                                         'Share your ride with Evoke buddies',
          //                                         textAlign: TextAlign.center,
          //                                         style: TextStyle(
          //                                           color: Colors.white,
          //                                           fontSize: 26.0,
          //                                           fontFamily:
          //                                               GoogleFonts.poppins()
          //                                                   .fontFamily,
          //                                           fontWeight: FontWeight.w600,
          //                                         )),
          //                                     SizedBox(
          //                                       height: 50,
          //                                     ),
          //                                     Image.asset(
          //                                         'assets/images/carPool.png'),
          //                                   ]
          //                                 ],
          //                               )),
          //                               SizedBox(
          //                                 height: 70,
          //                               ),
          //                               Container(
          //                                 height: 100,
          //                                 child: Container(
          //                                   child: Row(
          //                                     mainAxisAlignment:
          //                                         MainAxisAlignment.center,
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: List<Widget>.generate(
          //                                         2,
          //                                         (index) => Padding(
          //                                               padding:
          //                                                   const EdgeInsets
          //                                                           .symmetric(
          //                                                       horizontal: 5),
          //                                               child: InkWell(
          //                                                 onTap: () {
          //                                                   _pageController.animateToPage(
          //                                                       index,
          //                                                       duration:
          //                                                           const Duration(
          //                                                               milliseconds:
          //                                                                   300),
          //                                                       curve: Curves
          //                                                           .easeIn);
          //                                                 },
          //                                                 child: SizedBox(
          //                                                     width: 15,
          //                                                     height: 3,
          //                                                     // check if a dot is connected to the current page
          //                                                     // if true, give it a different color
          //                                                     child: Container(
          //                                                       color: _activePage ==
          //                                                               index
          //                                                           ? Colors
          //                                                               .white
          //                                                           : Color
          //                                                               .fromRGBO(
          //                                                                   255,
          //                                                                   255,
          //                                                                   255,
          //                                                                   0.25),
          //                                                     )),
          //                                               ),
          //                                             )),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ])
          //                         );
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 75),
            child: Container(
              height: 52,
              width: 250,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xffE9AD64)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26.0),
                            side: BorderSide(
                              color: Color(0xffE9AD64),
                            )))),
                icon: Image.asset(
                  'assets/images/evoke-icon.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () => {
                  authService.login((isSucess) {
                    if (isSucess) {
                      // GoRouter.of(context).goNamed('${AppRoute.rootNavigation.name}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()));
                    }
                  }, context)
                },
                label: Text('Login with Evoke ID',
                    style: TextStyle(
                      color: Color(0xFF292F69),
                      fontSize: 16.0,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  PageController _pageController = PageController();
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: PageView.builder(
              itemCount: 2,
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _activePage = index;
                });
              },
              itemBuilder: (_, i) {
                return buildPage(i);
              },
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(
              2,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    _pageController.animateToPage(index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  child: SizedBox(
                    width: 15,
                    height: 3,
                    child: Container(
                      color: _activePage == index
                          ? Colors.white
                          : Color.fromRGBO(255, 255, 255, 0.25),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPage(int i) {
    if (i == 0) {
      return buildPageContent(
        'Share your Knowledge, Ask queries',
        'assets/images/peopleTech.png',
      );
    } else {
      return buildPageContent(
        'Share your ride with Evoke buddies',
        'assets/images/carPool.png',
      );
    }
  }

  Widget buildPageContent(String text, String imageAsset) {
    return Column(
      children: <Widget>[
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Image.asset(imageAsset),
      ],
    );
  }
}
