import 'dart:ui';

import 'package:get/get.dart';

import '../utils/shared_value.dart';

class LanguageController extends GetxController{
  Locale? _locale;
  Locale get locale {
    //print("app_mobile_language.isEmpty${app_mobile_language.$.isEmpty}");
    return _locale = Locale(app_mobile_language.$==''?"en":app_mobile_language.$!,'');
  }


  void setLocale(String code){
    _locale = Locale(code,'');
    update();
  }
}