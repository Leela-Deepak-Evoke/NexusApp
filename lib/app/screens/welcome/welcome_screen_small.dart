import 'package:evoke_nexus_app/app/screens/home/home_screen.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreenSmall extends ConsumerStatefulWidget {
  const WelcomeScreenSmall({super.key});
  @override
  ConsumerState<WelcomeScreenSmall> createState() => _WelcomeScreenSmallState();
}

class _WelcomeScreenSmallState extends ConsumerState<WelcomeScreenSmall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Onboarding.png"),
                fit: BoxFit.cover),
          ),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/your_gif_image.gif"), // Replace 'your_gif_image.gif' with the actual path to your .gif image
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                              text: 'Welcome to Nexus App!\n',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              )),
                          WidgetSpan(
                            child: SizedBox(height: 30.0),
                          ),
                          TextSpan(
                              text:
                                  'Your gateway to interactive technology designed to streamline the creation, sharing, and exchange of information, ideas, referrals, technology interests, and various forms of expression across both Web and Mobile platforms (iOS/Android). Explore the seamless connectivity and possibilities that Nexus App brings to enhance your digital experience.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xffE9AD64)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        // Navigate to the next screen
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        // );
//                     Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const HomeScreen()),
//                   )
// //DONT REMOVE THIS CODE
                        GoRouter.of(context)
                            .goNamed('${AppRoute.rootNavigation.name}')
                      },
                      label: Text('About Me',
                          style: TextStyle(
                            color: Color(0xFF292F69),
                            fontSize: 16.0,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
