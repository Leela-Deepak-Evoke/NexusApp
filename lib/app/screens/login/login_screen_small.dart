// ignore_for_file: use_build_context_synchronously

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/welcome/welcome_screen.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/authentication_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evoke_nexus_app/app/screens/terms_condition/terms_condition_screen.dart';

class LoginScreenSmall extends ConsumerStatefulWidget {
  const LoginScreenSmall({super.key});

  @override
  ConsumerState<LoginScreenSmall> createState() => _LoginScreenSmallState();
}

class _LoginScreenSmallState extends ConsumerState<LoginScreenSmall>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  double _opacity = 0.0;
  bool _loading = false;

  //Slider Page
  final int _index = 0;
  final PageController _pageController = PageController(viewportFraction: 1);
  final int _activePage = 0;
  // late User user;

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
    safePrint(authService);
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
          //          width: size.width,
          // height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Onboarding.png"),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          // padding: EdgeInsets.zero,
          child: const Padding(
            padding: EdgeInsets.only(top: 120),
            child: MyPageView(),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: _loading // Conditionally show CircularProgressIndicator
              ? const Center(
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 75),
                  child: SizedBox(
                    height: 52,
                    width: 250,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffE9AD64)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26.0),
                                      side: const BorderSide(
                                        color: Color(0xffE9AD64),
                                      )))),
                      icon: Image.asset(
                        'assets/images/evoke-icon.png',
                        width: 24,
                        height: 24,
                      ),
                      // onPressed: () => {
                      //   authService.login((isSucess) {
                      //     if (isSucess) {
                      //       // GoRouter.of(context).goNamed('${AppRoute.rootNavigation.name}');
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => const WelcomeScreen()));
                      //     }
                      //   }, context)
                      // },
                      onPressed: () => _performLogin(context),

                      label: Text('Login with Evoke ID',
                          style: TextStyle(
                            color: const Color(0xFF292F69),
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

  Future<void> _performLogin(BuildContext context) async {
    setState(() {
      _loading = true; // Set loading to true when login starts
    });

    final authService = ref.read(authenticationServiceProvider);
    final userService = ref.read(userServiceProvider);
          // final fetcUserService =  ref.watch(fetchUserProvider); //calling FETCH USER

 try {
    await authService.login((isSuccess) async {
      if (isSuccess) {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsConditionScreen()),
                );
//        Call the second API
        // final user1 = await userService.checkUser();
        //   final user = await userService.fetchUser(); //calling FETCH USER instead of CheckUser

        // // Update currentUserProvider with the result
        // ref.read(currentUserProvider.notifier).state = user;

        // if (user != null) {
        //   if (user.status == "NEW" || user.termsAccepted == false || user.termsAccepted == null) {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => TermsConditionScreen()),
        //     );
        //   } else {
        //     GoRouter.of(context).goNamed(AppRoute.rootNavigation.name);
        //   }
        // } else {
        //    GoRouter.of(context).goNamed(AppRoute.rootNavigation.name);
        // }
      }
      setState(() {
        _loading = false; // Set loading to false when login completes
      });
    }, context);
     } catch (e) {
      print("Authentication canceled or failed: $e");
      setState(() {
        _loading =
            false; // Set loading to false if authentication is canceled or fails
      });
    }
  }

  Future<void> _performLogin_WORKING(BuildContext context) async {
    setState(() {
      _loading = true; // Set loading to true when login starts
    });

    final authService = ref.read(authenticationServiceProvider);

    try {
      await authService.login((isSuccess) async {
        if (isSuccess) {
          final userAsyncValue = ref.watch(checkUserProvider);
          final user = await userAsyncValue; // Await for user data
          safePrint("---------- USER DATA ----------- $user");

          userAsyncValue.when(
            data: (data) {
              safePrint(
                  "---------- USER DTATA 123456y ----------- $userAsyncValue");
              if (data.status == "NEW") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsConditionScreen()),
                );
              } else {
                GoRouter.of(context).goNamed(AppRoute.rootNavigation.name);
              }
            },
            loading: () => const Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) {
              // return Text('An error occurred: $error');
            },
          );
        }
        setState(() {
          _loading = false; // Set loading to false when login completes
        });
      }, context);
    } catch (e) {
      print("Authentication canceled or failed: $e");
      setState(() {
        _loading =
            false; // Set loading to false if authentication is canceled or fails
      });
    }
  }

  Future<void> _performLogin_OLD(BuildContext context) async {
    setState(() {
      _loading = true; // Set loading to true when login starts
    });

    final authService = ref.read(authenticationServiceProvider);
    await authService.login((isSuccess) {
      if (isSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
      setState(() {
        _loading = false; // Set loading to false when login completes
      });
    }, context);
  }
}

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final PageController _pageController = PageController();
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
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  child: SizedBox(
                    width: 15,
                    height: 3,
                    child: Container(
                      color: _activePage == index
                          ? Colors.white
                          : const Color.fromRGBO(255, 255, 255, 0.25),
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
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Expanded(
          child: Image.asset(imageAsset),
        ),
      ],
    );
  }
}




