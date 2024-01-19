import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import 'package:krishanthmart_new/utils/shimmer_utils.dart';

import '../../../models/category_model.dart';
import 'package:flutter/material.dart';

import '../category_page.dart';
import 'category_card.dart';

class CategoryGridView extends StatelessWidget {
  final List<Category> categoryList;
  final void Function()? onTap;

  const CategoryGridView(this.categoryList, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return GridView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          if (categoryList.isEmpty) {
            return ShimmerHelper().buildProductGridShimmer();
          } else {
            return InkWell(
              onTap: () {
                Get.to(
                  () => CategoryListPages(),
                );
              },
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
