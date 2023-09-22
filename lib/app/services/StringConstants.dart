

import 'package:flutter/material.dart';

// all urls
const String BASE_URL = "http://172.16.20.16:8088/api/";
const String LOGIN_URL = "${BASE_URL}User/Login";
const String REGISTER_URL = "${BASE_URL}User";
const String SAVEGSTDETAILS_URL = "${BASE_URL}E_Invoice/SaveGstDetails";
const String GETGSTDETAILS_URL = "${BASE_URL}gstdetails";


//SharedPre keys
const String TOKEN_ID = "token";
const String USER_EMAIL = "email";
const String USER_ID = "user_id";


// all colors
Color appGreen  =  const Color(0xFF58B8A4);
Color appBlackGrey  =  const Color(0xFF4E5E66);
Color dashBoardHeaderTextColor  =  const Color(0xFFeef8f6);
Color GSTLogbgColor  =  const Color(0xFFd4ede8);
Color backGroundColor  =  const Color(0xFFF8FAFC);
Color separatorColor = const Color(0xFFEAEAEA);
Color themeColor  = const Color(0xFF6C65E8);


enum LeftMenuTag  {
   Feeds,
  Forum,
  CarPool,
  Updates,
  Events,
  Ideas,
  Classifieds,
  Referrals
}

class AppColors {

//Dark blue text colour 
static const Color blueTextColour = Color(0xff1B154C);

}