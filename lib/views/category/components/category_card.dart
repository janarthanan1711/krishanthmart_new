import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/category_model.dart';
import '../../../utils/colors.dart';

class ProductCategoryCard extends StatelessWidget {
  final Category category;
  const ProductCategoryCard({super.key, required this.category});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 86.h,
          decoration: BoxDecoration(
            color: MyTheme.white,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(category.banner!),
            ),
            borderRadius: BorderRadius.circular(10)
          ),
        ),
         SizedBox(height: 5.h),
        Text(
          category.name!,
          style:TextStyle(fontSize: 9.sp,),
        ),
      ],
    );
  }
}