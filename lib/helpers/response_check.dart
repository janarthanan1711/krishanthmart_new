import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:krishanthmart_new/views/mainpage/main_page.dart';
import 'package:one_context/one_context.dart';
import 'auth_helpers.dart';

class ResponseCheck{

  static bool apply(response){

    // print("ResponseCheck ${response}");
    try {
      var responseData  = jsonDecode(response);

      if(responseData is Map && responseData.containsKey("result") && !responseData['result'])
      {
        if(responseData.containsKey("result_key") && responseData['result_key'] == "banned"){
          AuthHelper().clearUserData();
          Navigator.pushAndRemoveUntil(OneContext().context!, MaterialPageRoute(builder: (context)=>MainPage()), (route) => false);
        }
        return false;
      }
    } on Exception catch (e) {
      // TODO
    }
    return true;

  }

}