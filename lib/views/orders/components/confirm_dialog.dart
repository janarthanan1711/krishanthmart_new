import 'package:flutter/material.dart';

import '../../../utils/btn_elements.dart';
import '../../../utils/colors.dart';
import '../../../utils/device_info.dart';

class ConfirmDialog{

  static show(BuildContext context,{String? title,required String message,String? yesText,String? noText,required OnPress pressYes}){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: const Text("Please ensure us."),
          content: Row(
            children: [
              SizedBox(
                width: DeviceInfo(context).width! * 0.6,
                child: Text(message,style: const TextStyle(fontSize: 14,color: MyTheme.font_grey),),)
            ],
          ),
          actions: [
            Btn.basic(
              color: MyTheme.font_grey,
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(noText??"",style: const TextStyle(fontSize: 14,color: MyTheme.white),),
            ),
            Btn.basic(
              color: MyTheme.golden,
              onPressed: () {
                Navigator.pop(context);
                pressYes();
              },
              child: const Text("Yes",style: TextStyle(fontSize: 14,color: MyTheme.white),),
            ),
          ],
        );
      },);
  }
}

typedef OnPress= void Function();