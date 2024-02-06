import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/cart_controller.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import '../../../controllers/product_controller.dart';
import '../../../helpers/main_helpers.dart';
import '../../../models/product_response_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_btn_options.dart';
import '../../../utils/shared_value.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../product_details/components/product_bottom_sheet.dart';

class ProductCard extends StatefulWidget {
  ProductCard(
      {super.key,
      required this.product,
      required this.onTap,
      required this.itemIndex});

  Product product;
  final VoidCallback onTap;
  int itemIndex;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  // final VariantController variantController = Get.put(VariantController());
  @override
  void initState() {
    // TODO: implement initState
    productController.fetchProductDetailsMain(widget.product.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 250,
            width: 160.w,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => ProductDetails(
                        id: widget.product.id,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 120,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: widget.product.thumbnail_image!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 31.h,
                            width: 68.w,
                            color: MyTheme.green.withOpacity(0.300),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.ourPrice,
                                  style:  TextStyle(
                                    color: MyTheme.medium_grey_50,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  convertPrice(widget.product.main_price!),
                                  style:  TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.product.has_discount!)
                            Container(
                              height: 31.h,
                              width: 65.w,
                              color: MyTheme.shimmer_highlighted,
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.mrp,
                                    style:  TextStyle(
                                      color: MyTheme.medium_grey_50,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    convertPrice(widget.product.stroked_price!),
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: MyTheme.medium_grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                      Text(
                        widget.product.name!,
                        style: const TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ChooseOptionButton(
                        onTap: () async {
                         await variantBottomSheet();
                        },
                        height: 25.h,
                        width: 150.w,
                        bgColor: MyTheme.green_light,
                        iconColor: MyTheme.black,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.product.has_discount!)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 5),
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
                    child: Text(
                      widget.product.discount ?? "",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                        height: 1.8,
                      ),
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false),
                      softWrap: false,
                    ),
                  ),
                Visibility(
                  visible: whole_sale_addon_installed.$,
                  child: widget.product.isWholesale != null &&
                          widget.product.isWholesale!
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Colors.blueGrey,
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
                          child: const Text(
                            "Wholesale",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              height: 1.8,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

 Future variantBottomSheet() async {
    await productController.fetchProductDetailsMain(widget.product.id);
    await Get.bottomSheet(
      isDismissible: false,
      GetBuilder<ProductController>(builder: (productController) {
        return ProductVariantBottomSheet(product: widget.product,productController: productController,);
      }),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
