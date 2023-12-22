import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishanthmart_new/utils/colors.dart';

class ProfileCommonWidgets {
  static listTileWidget({required heading, required onTap, required icons}) {
    return ListTile(
      title: heading,
      onTap: onTap,
      textColor: MyTheme.black,
      leading: icons,
      selectedColor: MyTheme.green,
      trailing: Icon(Icons.arrow_forward_ios, size: 20, color: MyTheme.black),
    );
  }
  static boxContainer({required text1,required text2,required onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 120,
        decoration: BoxDecoration(
            color: MyTheme.green_light,
          borderRadius: BorderRadius.circular(10)
        ),
        child:  Column(
          children: [
            Text(text1),
            const SizedBox(height: 10,),
            Text(text2,style: const TextStyle(fontSize: 12),)
          ],
        ),
      ),
    );
  }

  static usefulIconElements({required imgUrl,required text,required onTap}){
    return InkWell(
      onTap: onTap,
      child:  Column(
        children: [
          Image(
            image: AssetImage(imgUrl),
            height: 30,
            width: 30,
          ),
          Text(text)
        ],
      ),
    );
  }

}
