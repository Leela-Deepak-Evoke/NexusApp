import 'package:evoke_nexus_app/app/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionScreenSmall extends ConsumerStatefulWidget {
  const TermsConditionScreenSmall({super.key});
  @override
  ConsumerState<TermsConditionScreenSmall> createState() =>
      _TermsConditionScreenSmallState();
}

class _TermsConditionScreenSmallState
    extends ConsumerState<TermsConditionScreenSmall> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/Onboarding.png"),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Terms of Service',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
                Text(
                    "This privacy policy governs your use of the software applications (“Applications”) for mobile devices that was hosted at NIC e-Gov Mobile App Store in Google Play. The Applications mainly provide eGovernance Services delivery and intends to provide better citizen services by the government. The contents published on these Applications were provided by the concerned Ministries/Departments of Government of India or the allied government establishment. This information provided through these applications may not have any legal sanctity and are for general reference only, unless otherwise specified. However, every effort has been made to provide accurate and reliable information through these applications. Users are advised to verify the correctness of the facts published here from the concerned authorities. Neither National Informatics Centre nor Government of India and its allied establishments will not be responsible for the accuracy and correctness of the contents available in these applications.\n\nUser Provided Information:\n\nThe Applications may obtain the information you provide when you download and register the Application. Registration is optional. However, please keep in mind that you may not be able to use some of the features offered by an Application unless you register.\n\nWhen you register and use the Application, you generally provide (a) your name, email address, age, user name, password and other registration information; (b) download or use applications from us; (c) information you provide when you contact us for help; (d) credit card information for use of the service, and; (e) information you enter into our system when using the Application, such as contact information and other details.\n\nThe information you provided may be used to contact you from time to time to provide you with important information and required notices.\n\nAutomatically Collected Information :\n\nIn addition, the Application may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browsers you use, and information about the way you use the Application.\n\nWhen you visit the mobile application, it may use GPS technology (or other similar technology) to determine your current location in order to determine the city you are located within and display a location map. The location information may be sent to authorities for taking necessary actions and making policy decisions.\n\nIf you do not want the app to use your location for the purposes set forth above, you should turn off the location services for the mobile application located in your account settings or in your mobile phone settings and/or within the mobile application. However, if the service provided by the Application requires the location services using GPS technology, such services offered by the application will not be available for you.\n\nWe may disclose User provided and Automatically Collected Information:\n\nas required by law, such as to comply with a subpoena, or similar legal process;\nwhen we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;\nwith our trusted services providers who work on our behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n\nYou can stop all collection of information by the Application easily by uninstalling the Application. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\nData Retention Policy, Managing Your Information\n\nWe will retain User provided data for as long as you use the Application and for a reasonable time thereafter. We will retain Automatically Collected information also for a reasonable period of time depending on the nature of application and thereafter may store it in aggregate. Please note that some or all of the User Provided Data may be required in order for the Application to function properly.\n\nMisuse by Non Targeted Users\n\nAll mobile apps are meant for use by the targeted audience only. Misuse by non-targeted users should be prevented by owner of the mobile.\n\nSecurity\n\nWe are concerned about safeguarding the confidentiality of your information. We provide physical, electronic, and procedural safeguards to protect information we process and maintain. For example, we limit access to this information to authorized employees and contractors who need to know that information in order to operate, develop or improve our Application. Please be aware that, although we endeavour to provide reasonable security for information we process and maintain, no security system can prevent all potential security breaches.\n\nChanges\n\nThis Privacy Policy may be updated from time to time for any reason. We will notify you of any changes to our Privacy Policy by posting the new Privacy Policy here. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes. You can check the history of this policy by clicking here.\n\nYour Consent\n\nBy using the Application, you are consenting to our processing of your information as set forth in this Privacy Policy now and as amended by us.\n\nContact us\n\nIf you have any questions regarding privacy while using the Application, or have questions about our practices, please contact us via email at abc[at]xyz[dot]com",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: GoogleFonts.notoSans().fontFamily,
                      fontWeight: FontWeight.w500,
                    )),
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            Colors.white, // Change checkbox color to white
                      ),
                      child: Transform.scale(
                  scale: 1.3,
                  child:
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                     ) ),
                    ),
                    Text('I accept the Terms and Conditions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontFamily: GoogleFonts.notoSans().fontFamily,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ])),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Border color
                    borderRadius: BorderRadius.circular(8.0), // Corner radius
                  ),
                  child: TextButton(
                    // onPressed: () {
                    //   Navigator.pop(context, false); // Cancel button pressed
                    // },
                    onPressed: () {
              // Show dialog when button is pressed
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Nexus APP"),
                    content: Text("Do you want to navigate back?"),
                    actions: [
                      // "Cancel" button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Dismiss dialog
                        },
                        child: Text("Cancel"),
                      ),
                      // "Ok" button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Dismiss dialog
                          Navigator.of(context).pop(true); // Navigate back
                        },
                        child: Text("Ok"),
                      ),
                    ],
                  );
                },
              );
            },
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: _isChecked
                        ? null // No border when enabled
                        : Border.all(
                            color: Colors.grey), // Border color when disabled
                    borderRadius: BorderRadius.circular(8.0), // Corner radius
                    color: _isChecked
                        ? Color(0xffE9AD64)
                        : Colors.transparent, // Button color
                  ),
                  child: TextButton(
                    onPressed: _isChecked
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen()),
                            );
                          }
                        : null,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // Disabled text color
                          }
                          return Colors.white; // Enabled text color
                        },
                      ),
                    ),
                    // Disable accept button if checkbox not checked
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
 const SizedBox(
              height: 50,
            ),

          ],
        ),
      ),
    ));
  }
}
