import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishanthmart_new/models/brand_model.dart';
import 'package:flutter/material.dart';

class BrandCategoryCard extends StatelessWidget {
  final Brands brands;

  const BrandCategoryCard({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipOval(
            child: Container(
              width: 95,
              height: 87,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(brands.logo!),
                ),
              ),
            ),
          ),
        ),
         const SizedBox(height: 5),
        Text(
          brands.name!,
          style:TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
