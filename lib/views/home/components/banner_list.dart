import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import '../../../utils/device_info.dart';
import '../../category/sub_category_page.dart';

class BannersHomeList extends StatelessWidget {
  String imageUrl;
  int productId;
  String subCategoryId;
  String productName;

  BannersHomeList(
      {super.key,
      required this.imageUrl,
      required this.productId,
      required this.subCategoryId,
      required this.productName});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("get Product id=======>${productId}");
        print("subcategory id=====>${subCategoryId}");
       await Get.to(
          () => SubCategoryPage(
            categoryId: productId,
            subCategoryId: int.parse(subCategoryId),
            selectedIndexes: int.parse(subCategoryId),
            categoryName: productName,
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
