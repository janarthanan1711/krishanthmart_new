import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import 'package:krishanthmart_new/views/brand_products/brand_products.dart';
import 'package:krishanthmart_new/views/brands/all_brands.dart';
import 'package:krishanthmart_new/views/mainpage/components/brand_category_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/colors.dart';

class BrandCategoryView extends StatelessWidget {
  const BrandCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.top_brands_ucf,
                style: TextStyle(
                    color: MyTheme.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold)),
            InkWell(
              child: Text(
                AppLocalizations.of(context)!.view_more_ucf,
                style: TextStyle(color: MyTheme.black, fontSize: 14.sp),
              ),
              onTap: () {
                Get.to(() => const AllBrands());
              },
            ),
          ],
        ),
      ),
      SizedBox(
        height: 252.h,
        child: GetBuilder<HomeController>(
          builder: (homeController) {
            return GridView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 1.0,
                  mainAxisExtent: 82.h),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => BrandProducts(
                            brand_name:
                                homeController.topBrandsList[index].name,
                            id: homeController.topBrandsList[index].id,
                          ),
                        );
                      },
                      child: BrandCategoryCard(
                          brands: homeController.topBrandsList[index]),
                    ),
                  ],
                );
              },
            );
            // return GridView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 3,
            //     crossAxisSpacing: 22.0,
            //     mainAxisSpacing: 22.0,
            //   ),
            //   itemCount: homeController.topBrandsList.length,
            //   itemBuilder: (context, index) {
            //     return InkWell(
            //         onTap: () {
            //           Get.to(
            //             () => BrandProducts(
            //               brand_name:
            //                   homeController.topBrandsList[index].name,
            //               id: homeController.topBrandsList[index].id,
            //             ),
            //           );
            //         },
            //         child: BrandCategoryCard(
            //             brands: homeController.topBrandsList[index]));
            //   },
            // );
          },
        ),
      )
    ]);
  }
}
