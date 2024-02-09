import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import '../../../utils/device_info.dart';

class BannersHomeList extends StatelessWidget {
  String imageUrl;
  String productId;

  BannersHomeList({super.key, required this.imageUrl, required this.productId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ProductDetails(
            id: int.parse(productId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.5.h),
        // height: 100.h,
        height: 200.h,
        width: DeviceInfo(context).width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image:
              DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
