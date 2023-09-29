




import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRetryPressed; // Change the type to VoidCallback
  final String?  strErrorMessage;
  ErrorScreen({this.strErrorMessage, required this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
               Color(ColorConstants.topbarbg),
               Color(ColorConstants.tabbg),
              ],
            )
          ),
          child:  Center(
            child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: TextButton.icon(
                onPressed: () {
                  onRetryPressed();
                },
                icon: Image.asset('assets/images/response.png'),
                label: Text(
                  'Retry',
                  style: TextStyle(
                    color: Color(0xff676A79),
                    fontSize: 12.0,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.normal,
                  ),
                )),   //onRetryPressed   -- > https://www.google.com/search?q=error+screen+UI&sca_esv=569475139&rlz=1C5GCEM_enIN1069IN1069&tbm=isch&source=lnms&sa=X&ved=2ahUKEwjO0e7Eo9CBAxUDcWwGHVA9DrwQ_AUoAXoECAEQAw&biw=1440&bih=673&dpr=2#imgrc=GjXuw55q_hCVjM
        ),
          ),
      );
  }
}







  