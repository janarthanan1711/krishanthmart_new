import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/device_info.dart';

class BannersHomeList extends StatelessWidget {
  String imageUrl;
   BannersHomeList({super.key,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 100.h,
      width:  DeviceInfo(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
            image: NetworkImage(imageUrl), fit: BoxFit.fill),
      ),
    );
  }
}
