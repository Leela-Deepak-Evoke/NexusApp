import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class AppConstants {
  static const loginTitle = 'Welcome to\nEvoke Professional\nNetwork';
  static const loginSubTitle =
      'Learn something new, find inspiration and join your colleagues on the Evoke’s professional network.';
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

  static String calculateTimeDifferenceBetween(
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

  static DateTime getDateTimeFromStringForPosts(String date) {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(date, true);
    return tempDate;

  }
}