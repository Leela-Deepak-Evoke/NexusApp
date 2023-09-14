import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileCustomAppbar extends StatelessWidget {
  const MobileCustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> appbarShadow = ValueNotifier<bool>(false);
    return Positioned(
      left: 0.0,
      right: 16.0,
      top: 0.0,
      child: ValueListenableBuilder<bool>(
          valueListenable: appbarShadow,
          builder: (context, value, child) {
            return AppBar(
              backgroundColor: Colors.transparent,
              leading: Image.asset(
                'assets/images/evoke-icon.png',
              ),
              titleSpacing: 0,
              centerTitle: false,
              title: Text(
                "EVOKE NEXUS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              actions: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/notifications.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {},
                ),
                InkWell(
                  onTap: () {
          
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xffF2722B),
                      child: Text('SM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                )
              ],
              elevation: value ? 2.0 : 0.0,
            );
          }),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  final String title;
  final bool hasBackAction;
  final bool hasRightAction;
  Function() topBarButtonAction;
   CustomAppbar(
    {
    super.key, 
    required this.title,
    required this.hasBackAction,
    required this.hasRightAction,
    required this.topBarButtonAction
    });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> appbarShadow = ValueNotifier<bool>(false);
    return Positioned(
      left: 0.0,
      right: 16.0,
      top: 0.0,
      child: ValueListenableBuilder<bool>(
          valueListenable: appbarShadow,
          builder: (context, value, child) {
            return AppBar(
              backgroundColor: Colors.transparent,
              leading:
               hasBackAction ? 
               IconButton(
                icon: Image.asset(
                  'assets/images/back.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ) : 
              IconButton(
                icon: Image.asset(
                  'assets/images/Nexus.png',
                  width: 35,
                  height: 35,
                ),
                onPressed: () {
                  
                },
              ),

              titleSpacing: 0,
              centerTitle: false,
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              actions: [

                hasRightAction ? IconButton(
                icon: Image.asset(
                  'assets/images/create-post.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  topBarButtonAction();
                },
              ) : SizedBox()
              ],
              elevation: value ? 2.0 : 0.0,
            );
          }),
    );
  }
}
