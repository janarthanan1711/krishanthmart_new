import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/cart_controller.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import '../../../controllers/product_controller.dart';
import '../../../helpers/main_helpers.dart';
import '../../../models/product_details_model.dart';
import '../../../models/product_response_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_btn_options.dart';
import '../../../utils/shared_value.dart';
import '../../mainpage/components/box_decorations.dart';
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
            width: 160,
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
                          Text(
                            convertPrice(widget.product.main_price!),
                            style: const TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.product.has_discount!)
                            Text(
                              convertPrice(widget.product.stroked_price!),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: MyTheme.medium_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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

  // static chooseOptionButton(BuildContext context,
  //     {required onTap, required height, required width}) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: MyTheme.white,
  //         borderRadius: BorderRadius.circular(5),
  //         border: Border.all(color: MyTheme.green),
  //       ),
  //       height: height,
  //       width: width,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             AppLocalizations.of(context)!.choose_option,
  //             style: const TextStyle(color: MyTheme.grey_153),
  //           ),
  //           Icon(
  //             Icons.arrow_drop_down_outlined,
  //             color: MyTheme.green,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // static iconButton({required onTap,required height,required width,required icon}){
  //   return InkWell(
  //     onTap:onTap,
  //     child: Container(
  //       height: height,
  //       width: width,
  //       decoration: BoxDecoration(
  //           color: MyTheme.green,
  //           borderRadius: BorderRadius.circular(10)),
  //       child:  Center(
  //           child: Icon(
  //             icon,
  //             color: MyTheme.white,
  //           )),
  //     ),
  //   );
  // }
  //
  // buildChoiceOptionList() {
  //   return ListView.builder(
  //     itemCount: productController.productDetails!.choice_options!.length,
  //     scrollDirection: Axis.vertical,
  //     shrinkWrap: true,
  //     padding: EdgeInsets.zero,
  //     physics: const BouncingScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 8.0),
  //         child: buildChoiceOpiton(
  //             productController.productDetails!.choice_options,
  //             index,
  //             productController.productDetails!.brand!.name),
  //       );
  //     },
  //   );
  // }
  //
  // buildChoiceOpiton(choiceOptions, choiceOptionsIndex, mainPrice) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(
  //       0.0,
  //       10.0,
  //       0.0,
  //       0.0,
  //     ),
  //     child: Row(
  //       // mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: app_language_rtl.$!
  //               ? const EdgeInsets.only(left: 8.0)
  //               : const EdgeInsets.only(right: 8.0),
  //           child: SizedBox(
  //             // width: 80.w,
  //             child: Text(
  //               choiceOptions[choiceOptionsIndex].title,
  //               style: const TextStyle(
  //                   color: Color.fromRGBO(153, 153, 153, 1),
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 6.w),
  //           // width: 250.w,
  //           child: Scrollbar(
  //             thumbVisibility: false,
  //             child: Wrap(
  //               children: List.generate(
  //                 choiceOptions[choiceOptionsIndex].options.length,
  //                 (index) => Padding(
  //                   padding: const EdgeInsets.only(bottom: 8.0),
  //                   child: buildChoiceItem(
  //                       choiceOptions[choiceOptionsIndex].options[index],
  //                       choiceOptionsIndex,
  //                       index,
  //                       mainPrice),
  //                 ),
  //               ),
  //             ),
  //
  //             /*ListView.builder(
  //               itemCount: choice_options[choice_options_index].options.length,
  //               scrollDirection: Axis.horizontal,
  //               shrinkWrap: true,
  //               itemBuilder: (context, index) {
  //                 return
  //               },
  //             ),*/
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // _onVariantChange(_choice_options_index, value) {
  //   productController.selectedChoices[_choice_options_index] = value;
  //   productController.setChoiceString();
  //   productController.getVariantData(widget.product.id);
  // }
  //
  // buildChoiceItem(option, choiceOptionsIndex, index, mainPrice) {
  //   return Padding(
  //     padding: app_language_rtl.$!
  //         ? const EdgeInsets.only(left: 8.0)
  //         : const EdgeInsets.only(right: 8.0),
  //     child: InkWell(
  //       onTap: () {
  //         _onVariantChange(choiceOptionsIndex, option);
  //       },
  //       child: Card(
  //         elevation: 10,
  //         margin: const EdgeInsets.all(10),
  //         child: Container(
  //           height: 30.h,
  //           width: 75.w,
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //                 color:
  //                     productController.selectedChoices[choiceOptionsIndex] ==
  //                             option
  //                         ? MyTheme.accent_color2
  //                         : MyTheme.noColor,
  //                 width: 1.5),
  //             borderRadius: BorderRadius.circular(3.0),
  //             color: MyTheme.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.12),
  //                 blurRadius: 6,
  //                 spreadRadius: 1,
  //                 offset:
  //                     const Offset(0.0, 3.0), // shadow direction: bottom right
  //               )
  //             ],
  //           ),
  //           child: Center(
  //             child: Text(
  //               option,
  //               style: TextStyle(
  //                   color:
  //                       productController.selectedChoices[choiceOptionsIndex] ==
  //                               option
  //                           ? MyTheme.accent_color2
  //                           : const Color.fromRGBO(224, 224, 225, 1),
  //                   fontSize: 12.sp,
  //                   fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static buildAddToCartButton(int id) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: MyTheme.green, borderRadius: BorderRadius.circular(5)),
  //     height: 25,
  //     width: 150,
  //     child: const Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           "Add",
  //           style: TextStyle(color: MyTheme.white),
  //         ),
  //         Icon(
  //           Icons.add,
  //           color: MyTheme.white,
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // static buildQuantityButton(
  //     {required onTapIncrement,
  //     required onTapDecrement,
  //     required quantityText}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: MyTheme.green, borderRadius: BorderRadius.circular(5)),
  //     height: 25.h,
  //     width: 150.w,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         InkWell(
  //           onTap: onTapDecrement,
  //           child: Container(
  //             height: 25.h,
  //             width: 25.w,
  //             color: MyTheme.green,
  //             child: Center(
  //               child: Text(
  //                 "-",
  //                 style: TextStyle(
  //                     color: MyTheme.white,
  //                     fontSize: 15.sp,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           height: 25,
  //           width: 100,
  //           color: MyTheme.white,
  //           child: Center(
  //             child: Text(
  //               quantityText,
  //               style: TextStyle(
  //                   color: MyTheme.black, fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //         InkWell(
  //             onTap: onTapIncrement,
  //             child: Container(
  //               height: 25.h,
  //               width: 25.w,
  //               color: MyTheme.green,
  //               child: Center(
  //                 child: Text(
  //                   "+",
  //                   style: TextStyle(
  //                       color: MyTheme.white,
  //                       fontSize: 15.sp,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             )),
  //       ],
  //     ),
  //   );
  // }
}
