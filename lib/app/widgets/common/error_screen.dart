import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// class ErrorScreen extends StatelessWidget {

//  final VoidCallback onRetryPressed; // Change the type to VoidCallback
//   final String?  strErrorMessage;
//    final bool? showErrorMessage; // Add a boolean flag to control visibility

//   ErrorScreen({this.strErrorMessage, this.showErrorMessage, required this.onRetryPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(
//             "assets/images/something_wrong.png",
//             fit: BoxFit.cover,
//           ),
//           Positioned(
//             bottom: MediaQuery.of(context).size.height * 0.15,
//             left: MediaQuery.of(context).size.width * 0.3,
//             right: MediaQuery.of(context).size.width * 0.3,
//             child: ElevatedButton(
//               onPressed: () {onRetryPressed;},
//              style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red[700],
//                           ),
//               child: Text(
//                 "Try Again".toUpperCase(),
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           )
//         ],
//       );
//   }
// }

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRetryPressed;
  final String? strErrorMessage;
  final bool? showErrorMessage;

  ErrorScreen(
      {this.strErrorMessage,
      this.showErrorMessage,
      required this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Visibility(
          visible: showErrorMessage == true,
          child: Image.asset(
            "assets/images/somethingwrong.png",
            fit: BoxFit.cover,
          ),
        ),
        Visibility(
          visible: showErrorMessage == false,
          child: Image.asset(
            "assets/images/articlenotFound.png",
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          bottom: showErrorMessage ?? false
              ? MediaQuery.of(context).size.height * 0.12
              : MediaQuery.of(context).size.height * 0.10,

right: 70,
left: 70,
              // width: double.infinity, //MediaQuery.of(context).size.width - 230,
              height: 50,
          // left: MediaQuery.of(context).size.width * 0.3,
          // right: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton(
            onPressed: onRetryPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: Text(
              "Try Again",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
