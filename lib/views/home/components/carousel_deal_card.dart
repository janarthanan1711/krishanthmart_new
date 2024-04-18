import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/utils/common_btn_options.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import '../../../controllers/product_controller.dart';
import '../../../helpers/main_helpers.dart';
import '../../../models/product_response_model.dart';
import '../../../utils/colors.dart';
import '../../product_details/components/product_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarouselDealCard extends StatelessWidget {
  CarouselDealCard({super.key, required this.product});

  Product product;
  ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290.h,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: MyTheme.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(
                    () => ProductDetails(
                      id: product.id,
                    ),
                  );
                },
                child: Image.network(
                  product.thumbnail_image!,
                  height: 170.h,
                  width: 300.h,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      product.name!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 31.h,
                          width: 65.w,
                          color: MyTheme.shimmer_highlighted,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.ourPrice,
                                style: TextStyle(
                                  color: MyTheme.medium_grey_50,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                convertPrice(product.main_price!),
                                style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (product.has_discount!)
                          Container(
                            height: 31.h,
                            width: 65.w,
                            color: MyTheme.shimmer_highlighted,
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.mrp,
                                  style: TextStyle(
                                    color: MyTheme.medium_grey_50,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  convertPrice(product.stroked_price!),
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: MyTheme.medium_grey,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Text(
                        //   convertPrice(product.main_price!),
                        //   style: TextStyle(
                        //     color: MyTheme.accent_color,
                        //     fontSize: 14.sp,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        // if (product.has_discount!)
                        //   Text(
                        //     convertPrice(product.stroked_price!),
                        //     style: TextStyle(
                        //       decoration: TextDecoration.lineThrough,
                        //       color: MyTheme.medium_grey,
                        //       fontSize: 12.sp,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        ChooseOptionButton(
                          bgColor: MyTheme.green_light,
                          iconColor: MyTheme.black,
                          onTap: () {
                            variantBottomSheet();
                          },
                          width: 130.sp,
                          height: 30.sp,
                          textColor: MyTheme.black,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          product.has_discount!
              ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: const BoxDecoration(
                        color: MyTheme.accent_color2,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14000000),
                            offset: Offset(-1, 1),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      height: 30,
                      width: 60,
                      child: Center(
                        child: Text(
                          product.discount ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                            height: 1.8,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
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
