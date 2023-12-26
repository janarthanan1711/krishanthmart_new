import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/category_model.dart';

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
          style:TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
    // return Card(
    //   elevation: 3.0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(8.0),
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       ClipRRect(
    //         borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
    //         child: Image.network(
    //           category.banner!,
    //           height: 70.0,
    //           fit: BoxFit.fill,
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
    //         child: Text(
    //           category.name!,
    //           style: const TextStyle(
    //             fontSize: 10.0,
    //             fontWeight: FontWeight.bold,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}