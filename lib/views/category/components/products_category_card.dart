import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/models/product_response_model.dart';
import 'package:krishanthmart_new/utils/common_btn_options.dart';
import '../../../controllers/product_controller.dart';
import '../../../helpers/main_helpers.dart';
import '../../../utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../product_details/components/product_bottom_sheet.dart';

class ProductCategoryCardLarge extends StatelessWidget {
  ProductCategoryCardLarge({super.key, required this.product});

  Product product;
  ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122.h,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 110.h,
              width: 105.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(product.thumbnail_image!),
                ),
              ),
            ),
            // Image.network(
            //   product.thumbnail_image!,
            //   height: 110.h,
            //   width: 105.w,
            //   fit: BoxFit.fill,
            // ),
            Container(
              height: 142.h,
              width: 1.h,
              color: MyTheme.medium_grey,
            ),
            SizedBox(
              width: 2.5.w,
            ),
            Container(
              width: 232.w,
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              decoration: const BoxDecoration(
                color: MyTheme.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                // border: Border(left: BorderSide(color: MyTheme.medium_grey))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 250.h,
                    child: Text(
                      product.name!,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      RatingBar(
                        itemSize: 15.0,
                        ignoreGestures: true,
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color: MyTheme.green),
                          half: Icon(Icons.star_half, color: MyTheme.green),
                          empty: const Icon(Icons.star,
                              color: Color.fromRGBO(224, 224, 225, 1)),
                        ),
                        itemPadding: const EdgeInsets.only(right: 1.0),
                        onRatingUpdate: (rating) {
                          //print(rating);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          product.rating.toString(),
                          style: TextStyle(
                              color: const Color.fromRGBO(152, 152, 153, 1),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 26.h,
                        width: 65.w,
                        color: MyTheme.shimmer_highlighted,
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.ourPrice,
                              style: TextStyle(
                                color: MyTheme.medium_grey_50,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              convertPrice(product.main_price!),
                              style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      if (product.has_discount!)
                        Container(
                          height: 26.h,
                          width: 65.w,
                          color: MyTheme.shimmer_highlighted,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.mrp,
                                style: TextStyle(
                                  color: MyTheme.medium_grey_50,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                convertPrice(product.stroked_price!),
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: MyTheme.medium_grey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: 10.w,
                      ),
                      product.has_discount!
                          ? Container(
                              decoration: const BoxDecoration(
                                color: MyTheme.accent_color2,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0),
                                  topLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    offset: Offset(-1, 1),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              height: 25.h,
                              width: 60.w,
                              child: Center(
                                child: Text(
                                  product.discount ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    height: 1.8,
                                  ),
                                  textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  softWrap: false,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  ChooseOptionButton(
                    height: 20.h,
                    width: 250.w,
                    onTap: () async {
                      await variantBottomSheet();
                    },
                    iconColor: MyTheme.black,
                    bgColor: MyTheme.green_light,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future variantBottomSheet() async {
    await productController.fetchProductDetailsMain(product.id);
    await Get.bottomSheet(
      isDismissible: false,
      GetBuilder<ProductController>(builder: (productController) {
        return ProductVariantBottomSheet(
          product: product,
          productController: productController,
        );
      }),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
