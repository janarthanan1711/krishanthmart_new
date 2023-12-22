import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import 'package:krishanthmart_new/utils/shimmer_utils.dart';

import '../../../models/category_model.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoryGridView extends StatelessWidget {
  final List<Category> categoryList;

  const CategoryGridView(this.categoryList, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          if (categoryList.isEmpty) {
            return ShimmerHelper().buildProductGridShimmer();
          } else {
            return InkWell(
              onTap: () {},
              child: ProductCategoryCard(
                category: categoryList[index],
              ),
            );
          }
        },
      );
    });
  }
}
