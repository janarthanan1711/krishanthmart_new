import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/product_controller.dart';
import 'package:social_share/social_share.dart';
import '../../../helpers/main_helpers.dart';
import '../../../models/product_response_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/shared_value.dart';
import '../../cart/cart_page.dart';
import '../../mainpage/components/box_decorations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductVariantBottomSheet extends StatelessWidget {
  final ProductController productController;
  final Product product;

  const ProductVariantBottomSheet(
      {super.key, required this.productController, required this.product});

  @override
  Widget build(BuildContext context) {
    SnackBar _addedToCartSnackbar = SnackBar(
      content: Text(
        AppLocalizations.of(context)!.added_to_cart,
        style: TextStyle(
            color: MyTheme.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      // backgroundColor: MyTheme.soft_accent_color,
      backgroundColor: MyTheme.accent_color2,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.show_cart_all_capital,
        onPressed: () {
          Get.to(() => CartPage(
                has_bottomnav: false,
              ));
        },
        textColor: MyTheme.black,
        disabledTextColor: Colors.grey,
      ),
    );
    SnackBar removeFromWislist = SnackBar(
      content: Text(
        "Remove From Wishlist",
        style: TextStyle(
            color: MyTheme.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      backgroundColor: MyTheme.soft_accent_color,
      // backgroundColor: MyTheme.green_light,
      duration: const Duration(seconds: 3),
    );
    SnackBar addToWishList = SnackBar(
      content: Text(
        "Added to Wishlist",
        style: TextStyle(
            color: MyTheme.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      // backgroundColor: MyTheme.soft_accent_color,
      backgroundColor: MyTheme.green_light,
      duration: const Duration(seconds: 3),
    );

    SnackBar noStocksMessage = SnackBar(
      content: Text(
        "No Stocks Available",
        style: TextStyle(
            color: MyTheme.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      // backgroundColor: MyTheme.soft_accent_color,
      backgroundColor: MyTheme.cinnabar,
      duration: const Duration(seconds: 3),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(6), right: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: product.thumbnail_image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10, left: 12, right: 12, bottom: 14),
                        //width: 240,
                        height: 100.h,
                        //color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.font_grey,
                                  fontSize: 14.sp,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 38.h,
                                  width: 85.w,
                                  color: MyTheme.green.withOpacity(0.300),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.ourPrice,
                                        style: TextStyle(
                                          color: MyTheme.medium_grey_50,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        convertPrice(
                                            productController.totalPrice!),
                                        style: TextStyle(
                                          color: MyTheme.accent_color,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (product.has_discount!)
                                  Container(
                                    height: 38.h,
                                    width: 85.w,
                                    color: MyTheme.shimmer_highlighted,
                                    child: Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.mrp,
                                          style: TextStyle(
                                            color: MyTheme.medium_grey_50,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          convertPrice(productController.mrpPrice!),
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: MyTheme.medium_grey,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // SizedBox(
                                //   width: 10.w,
                                // ),
                                product.has_discount!
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 6),
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
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
                                          "${productController.discountVariant}%" ?? "",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w700,
                                            height: 1.8,
                                          ),
                                          textHeightBehavior:
                                              const TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          softWrap: false,
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  child: const Icon(Icons.close, size: 25),
                  onTap: () {
                    productController.clearAll();
                    Get.back();
                  },
                ),
              ),
            ],
          ),
         Column(
           children: [
             Padding(
               padding: const EdgeInsets.fromLTRB(
                 0.0,
                 10.0,
                 0.0,
                 10.0,
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Padding(
                     padding: app_language_rtl.$!
                         ? const EdgeInsets.only(left: 8.0)
                         : const EdgeInsets.only(right: 8.0),
                     child: SizedBox(
                       // width: 80.w,
                       child: Text(
                         AppLocalizations.of(context)!.quantity,
                         style: const TextStyle(
                             color: Color.fromRGBO(153, 153, 153, 1),
                             fontWeight: FontWeight.bold),
                       ),
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 6.w),
                     child: buildQuantityButton(
                         onTapIncrement: () {
                           productController.incrementQuantityCart(product.id,
                               snackbar: noStocksMessage, context: context);
                         },
                         onTapDecrement: () {
                           productController.decrementQuantityCart(product.id,
                               snackbar: noStocksMessage, context: context);
                         },
                         quantityText: productController.quantityText.value),
                   )
                 ],
               ),
             ),
             Divider(
               height: 2.5.h,
               color: MyTheme.green,
               thickness: 1,
               indent: 0.5,
               endIndent: 0.5,
             ),
             buildChoiceOptionList(_addedToCartSnackbar),
             Divider(
               height: 2.5.h,
               color: MyTheme.green,
               thickness: 1,
               indent: 0.5,
               endIndent: 0.5,
             ),
             Padding(
               padding: const EdgeInsets.only(top: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   iconButton(
                     onTap: () {
                       productController.onWishTap(
                           context,
                           product.id!,
                           productController.isInWishList == true
                               ? removeFromWislist
                               : addToWishList);
                     },
                     height: 35.h,
                     width: 100.w,
                     icon: Icons.favorite,
                    color: productController.isInWishList.value
                         ? const Color.fromRGBO(230, 46, 4, 1)
                         : MyTheme.white,
                   ),
                   iconButton(
                     onTap: () {
                       SocialShare.shareOptions(
                           productController.productDetails!.link!);
                     },
                     height: 35.h,
                     width: 100.w,
                     icon: Icons.share,
                     color: MyTheme.white
                   ),
                   iconButton(
                     onTap: () {
                       productController.addToCart(
                           id: product.id,
                           mode: "add_to_cart",
                           context: context,
                           snackbar: _addedToCartSnackbar);
                     },
                     height: 35.h,
                     width: 100.w,
                     icon: Icons.shopping_cart_rounded,
                     color: MyTheme.white
                   ),
                 ],
               ),
             )
           ],
         )
        ],
      ),
    );
  }

  static iconButton(
      {required onTap, required height, required width, required icon,required color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: MyTheme.green, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Icon(
          icon,
          color:color,
          // color: MyTheme.white,
        )),
      ),
    );
  }

  buildChoiceOptionList(_addedToCartSnackbar) {
    return ListView.builder(
      itemCount: productController.productDetails!.choice_options!.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: buildChoiceOpiton(
              productController.productDetails!.choice_options,
              index,
              productController.productDetails!.brand!.name),
        );
      },
    );
  }

  // buildChoiceOpiton(choiceOptions, choiceOptionsIndex, mainPrice,context,_addedToCartSnackbar) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(
  //       0.0,
  //       10.0,
  //       0.0,
  //       0.0,
  //     ),
  //     child: Column(
  //       // mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Padding(
  //           padding: app_language_rtl.$!
  //               ? const EdgeInsets.only(left: 8.0)
  //               : const EdgeInsets.only(right: 8.0),
  //           child: SizedBox(
  //             // width: 60.w,
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
  //           child: Scrollbar(
  //             thumbVisibility: false,
  //             child: SizedBox(
  //               width: 300.w,
  //               child: Column(
  //                 children: List.generate(
  //                   choiceOptions[choiceOptionsIndex].options.length,
  //                       (index) => Padding(
  //                     padding: const EdgeInsets.only(bottom: 8.0),
  //                     child: buildChoiceItem(
  //                         choiceOptions[choiceOptionsIndex].options[index],
  //                         choiceOptionsIndex,
  //                         index,
  //                         mainPrice,
  //                         context,
  //                         _addedToCartSnackbar,
  //                     ),
  //                   ),
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

  buildChoiceOpiton(choiceOptions, choiceOptionsIndex, mainPrice) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        10.0,
        0.0,
        0.0,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: app_language_rtl.$!
                ? const EdgeInsets.only(left: 8.0)
                : const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              // width: 60.w,
              child: Text(
                choiceOptions[choiceOptionsIndex].title,
                style: const TextStyle(
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: Scrollbar(
              thumbVisibility: false,
              child: SizedBox(
                width: 300.w,
                child: Wrap(
                  children: List.generate(
                    choiceOptions[choiceOptionsIndex].options.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: buildChoiceItem(
                          choiceOptions[choiceOptionsIndex].options[index],
                          choiceOptionsIndex,
                          index,
                          mainPrice),
                    ),
                  ),
                ),
              ),

              /*ListView.builder(
                itemCount: choice_options[choice_options_index].options.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return
                },
              ),*/
            ),
          )
        ],
      ),
    );
  }

  _onVariantChange(_choice_options_index, value) {
    productController.selectedChoices[_choice_options_index] = value;
    productController.setChoiceString();
    productController.getVariantData(product.id);
  }

  // buildChoiceItem(option, choiceOptionsIndex, index, mainPrice,context,_addedToCartSnackbar) {
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
  //           height: 90.h,
  //           width: 300.w,
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //                 color:
  //                 productController.selectedChoices[choiceOptionsIndex] ==
  //                     option
  //                     ? MyTheme.accent_color2
  //                     : MyTheme.noColor,
  //                 width: 2),
  //             borderRadius: BorderRadius.circular(3.0),
  //             color: MyTheme.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.12),
  //                 blurRadius: 6,
  //                 spreadRadius: 1,
  //                 offset:
  //                 const Offset(0.0, 3.0), // shadow direction: bottom right
  //               )
  //             ],
  //           ),
  //           child: Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   option,
  //                   style: TextStyle(
  //                       color:
  //                       productController.selectedChoices[choiceOptionsIndex] ==
  //                           option
  //                           ? MyTheme.accent_color2
  //                           : const Color.fromRGBO(224, 224, 225, 1),
  //                       fontSize: 10.sp,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 Text(
  //                   "Discount",
  //                   style: TextStyle(
  //                       color:
  //                       productController.selectedChoices[choiceOptionsIndex] ==
  //                           option
  //                           ? MyTheme.accent_color2
  //                           : const Color.fromRGBO(224, 224, 225, 1),
  //                       fontSize: 10.sp,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Text(
  //                       convertPrice(productController.totalPrice!),
  //                       style: TextStyle(
  //                           color:
  //                           productController.selectedChoices[choiceOptionsIndex] ==
  //                               option
  //                               ? MyTheme.accent_color2
  //                               : const Color.fromRGBO(224, 224, 225, 1),
  //                           fontSize: 10.sp,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     Text(
  //                       convertPrice(productController.mrpPrice!),
  //                       style: TextStyle(
  //                           color:
  //                           productController.selectedChoices[choiceOptionsIndex] ==
  //                               option
  //                               ? MyTheme.accent_color2
  //                               : const Color.fromRGBO(224, 224, 225, 1),
  //                           fontSize: 10.sp,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     InkWell(
  //                       onTap: (){
  //                         productController.addToCart(
  //                           id: product.id,
  //                           mode: "add_to_cart",
  //                             context: context,
  //                             snackbar: _addedToCartSnackbar
  //                         );
  //                       },
  //                       child: Container(
  //                         height: 30.h,
  //                         width: 100.w,
  //                         decoration: BoxDecoration(
  //                             color: MyTheme.green),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text("Add",style: TextStyle(color: MyTheme.white,fontSize: 14.sp),),
  //                             SizedBox(width: 5,),
  //                             Icon(Icons.shopping_cart_outlined,color: MyTheme.white,size: 14.sp,),
  //                           ],
  //                         )
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  buildChoiceItem(option, choiceOptionsIndex, index, mainPrice) {
    return Padding(
      padding: app_language_rtl.$!
          ? const EdgeInsets.only(left: 8.0)
          : const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          _onVariantChange(choiceOptionsIndex, option);
        },
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(10),
          child: Container(
            height: 30.h,
            width: 75.w,
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      productController.selectedChoices[choiceOptionsIndex] ==
                              option
                          ? MyTheme.accent_color2
                          : MyTheme.black,
                  width: 2),
              borderRadius: BorderRadius.circular(3.0),
              color: MyTheme.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset:
                      const Offset(0.0, 3.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                    color:
                        productController.selectedChoices[choiceOptionsIndex] ==
                                option
                            ? MyTheme.accent_color2
                         : MyTheme.black,
                            // : const Color.fromRGBO(224, 224, 225, 1),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static buildQuantityButton(
      {required onTapIncrement,
      required onTapDecrement,
      required quantityText}) {
    return Container(
      decoration: BoxDecoration(
          color: MyTheme.green, borderRadius: BorderRadius.circular(5)),
      height: 25.h,
      width: 150.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: onTapDecrement,
            child: Container(
              height: 25.h,
              width: 25.w,
              color: MyTheme.green,
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 100,
            color: MyTheme.white,
            child: Center(
              child: Text(
                quantityText,
                style: TextStyle(
                    color: MyTheme.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
              onTap: onTapIncrement,
              child: Container(
                height: 25.h,
                width: 25.w,
                color: MyTheme.green,
                child: Center(
                  child: Text(
                    "+",
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
