import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishanthmart_new/models/brand_model.dart';
import 'package:flutter/material.dart';

class BrandCategoryCard extends StatelessWidget {
  final Brands brands;

  const BrandCategoryCard({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 85.w,
              child: Text(
                brands.name!,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 75.h,
              width: 70.w,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                image: DecorationImage(
                    image: NetworkImage(brands.logo!), fit: BoxFit.fill),
              ),
            )
          ],
        ),
      ),
    );
    // return Column(
    //   children: [
    //     Card(
    //       elevation: 15,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(15),
    //       ),
    //       child: ClipOval(
    //         child: Container(
    //           width: 95,
    //           height: 87,
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             image: DecorationImage(
    //               fit: BoxFit.fill,
    //               image: NetworkImage(brands.logo!),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //      const SizedBox(height: 5),
    //     Text(
    //       brands.name!,
    //       style:TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
    //     ),
    //   ],
    // );
  }
}
