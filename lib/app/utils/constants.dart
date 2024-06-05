import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class AppConstants {
  static const loginTitle = 'Welcome to\nEvoke Professional\nNetwork';
  static const loginSubTitle =
      'Learn something new, find inspiration and join your colleagues on the Evoke’s professional network.';
        static const TermsConditionTitle = 'Terms of Service';
    static const TermsConditionSubTitle = "This privacy policy governs your use of the software applications (“Applications”) for mobile devices that was hosted at NIC e-Gov Mobile App Store in Google Play. The Applications mainly provide eGovernance Services delivery and intends to provide better citizen services by the government. The contents published on these Applications were provided by the concerned Ministries/Departments of Government of India or the allied government establishment. This information provided through these applications may not have any legal sanctity and are for general reference only, unless otherwise specified. However, every effort has been made to provide accurate and reliable information through these applications. Users are advised to verify the correctness of the facts published here from the concerned authorities. Neither National Informatics Centre nor Government of India and its allied establishments will not be responsible for the accuracy and correctness of the contents available in these applications.\n\nUser Provided Information:\n\nThe Applications may obtain the information you provide when you download and register the Application. Registration is optional. However, please keep in mind that you may not be able to use some of the features offered by an Application unless you register.\n\nWhen you register and use the Application, you generally provide (a) your name, email address, age, user name, password and other registration information; (b) download or use applications from us; (c) information you provide when you contact us for help; (d) credit card information for use of the service, and; (e) information you enter into our system when using the Application, such as contact information and other details.\n\nThe information you provided may be used to contact you from time to time to provide you with important information and required notices.\n\nAutomatically Collected Information :\n\nIn addition, the Application may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browsers you use, and information about the way you use the Application.\n\nWhen you visit the mobile application, it may use GPS technology (or other similar technology) to determine your current location in order to determine the city you are located within and display a location map. The location information may be sent to authorities for taking necessary actions and making policy decisions.\n\nIf you do not want the app to use your location for the purposes set forth above, you should turn off the location services for the mobile application located in your account settings or in your mobile phone settings and/or within the mobile application. However, if the service provided by the Application requires the location services using GPS technology, such services offered by the application will not be available for you.\n\nWe may disclose User provided and Automatically Collected Information:\n\nas required by law, such as to comply with a subpoena, or similar legal process;\nwhen we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;\nwith our trusted services providers who work on our behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n\nYou can stop all collection of information by the Application easily by uninstalling the Application. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\nData Retention Policy, Managing Your Information\n\nWe will retain User provided data for as long as you use the Application and for a reasonable time thereafter. We will retain Automatically Collected information also for a reasonable period of time depending on the nature of application and thereafter may store it in aggregate. Please note that some or all of the User Provided Data may be required in order for the Application to function properly.\n\nMisuse by Non Targeted Users\n\nAll mobile apps are meant for use by the targeted audience only. Misuse by non-targeted users should be prevented by owner of the mobile.\n\nSecurity\n\nWe are concerned about safeguarding the confidentiality of your information. We provide physical, electronic, and procedural safeguards to protect information we process and maintain. For example, we limit access to this information to authorized employees and contractors who need to know that information in order to operate, develop or improve our Application. Please be aware that, although we endeavour to provide reasonable security for information we process and maintain, no security system can prevent all potential security breaches.\n\nChanges\n\nThis Privacy Policy may be updated from time to time for any reason. We will notify you of any changes to our Privacy Policy by posting the new Privacy Policy here. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes. You can check the history of this policy by clicking here.\n\nYour Consent\n\nBy using the Application, you are consenting to our processing of your information as set forth in this Privacy Policy now and as amended by us.\n\nContact us\n\nIf you have any questions regarding privacy while using the Application, or have questions about our practices, please contact us via email at abc[at]xyz[dot]com";


      static const btnLogin = 'LOGIN WITH EVOKE ID';
      static const btnCancel = 'Cancel';
      static const btnApplyFilter = 'Apply Filter';
      static const lblFilterPost = 'Filter post';
      static const btnPost = '+POST';
      static const btnAsk = 'ASK';
      static const search = 'Search';
      static const socialFeed = 'Social Feed';
      static const questionAnswers = 'Question Answers';
      static const postFeed = 'Post Feed';
      static const postOrgUpdates = 'Post Updates';

      static const postReferral = 'Post Referral';

      static const postIdea = 'Post Idea';
      static const postAnswers = 'Post Answer';
      static const updates = 'Updates';
      static const referrals = 'Referrals';
      static const ideas = 'Ideas';


}
abstract class ImagePathConstants {
  static const filter = 'assets/images/filter.svg';
}
abstract class ColorConstants {
  static const commentBGColor  =  0xFFF2F1FA;
  static const tabbg = 0xFF4776E6;
  static const topbarbg = 0xFF8E54E9;
}


enum VideoCategory{
    mp4,
    mov,
    wav,
  flv,
  avi
}
enum ImageCategory{
  jpeg,
  jpg,
  png,

}

class AppColors {
//Dark blue text colour 
static const Color blueTextColour = Color(0xff1B154C);

}

abstract class Global {


  static String calculateTimeDifferenceBetween_OLD(
       DateTime startDate) {
    int seconds = DateTime.now().difference(startDate).inSeconds;
    if (seconds < 60) {
      return '$seconds seconds ago';
    } else if (seconds >= 60 && seconds < 3600) {
      return '${DateTime.now().difference(startDate).inMinutes.abs()} minutes ago';
    } else {
      if (seconds >= 3600 && seconds < 86400) {
        return '${DateTime.now().difference(startDate).inHours} hours ago';
      } else {
        return '${DateTime.now().difference(startDate).inDays} days ago';
      }
    }
  }

  static String calculateTimeDifferenceBetween(DateTime startDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(startDate);
    int seconds = difference.inSeconds;

    if (seconds < 60) {
      return '$seconds seconds ago';
    } else if (seconds < 3600) {
      int minutes = difference.inMinutes;
      return '$minutes minutes ago';
    } else if (seconds < 86400) {
      int hours = difference.inHours;
      return '$hours hours ago';
    } else {
      // If more than 2 days ago, format as "day month hour:minute am/pm"
      if (now.year == startDate.year) {
        // If within the same year, display without the year
        return DateFormat('d MMM').format(startDate); //h:mm a
      } else {
        // If across different years, display with the year
        return DateFormat('d MMM yyyy').format(startDate); //h:mm a
      }
    }
  }


  static DateTime getDateTimeFromString(String date) {
    DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(date, true);
    return tempDate;

  }

  static DateTime getDateTimeFromStringForPosts(String date) {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(date, true);
    return tempDate;

  }
}