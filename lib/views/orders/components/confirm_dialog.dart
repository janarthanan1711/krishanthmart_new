import 'package:flutter/material.dart';

import '../../../utils/btn_elements.dart';
import '../../../utils/colors.dart';
import '../../../utils/device_info.dart';

class ConfirmDialog{

  static show(BuildContext context,{String? title,required String message,String? yesText,String? noText,required OnPress pressYes,required TextEditingController controller}){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: const Text("Please ensure us."),
          content: SizedBox(
            height: 90,
            child: Column(
              children: [
                SizedBox(
                  width: DeviceInfo(context).width! * 0.6,
                  child: Text(message,style: const TextStyle(fontSize: 14,color: MyTheme.font_grey),),),
                SizedBox(height: 5,),
                SizedBox(
                  // height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'eg. Wrong Order',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    // onChanged: (value) {
                    //   orderCancelController.otherText.text = value;
                    // },
                  ),
                ),
              ],
            ),
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