import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import '../../../controllers/product_controller.dart';
import '../../../models/product_details_model.dart';
import '../../../models/product_response_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/shared_value.dart';
import '../../mainpage/components/box_decorations.dart';

class ProductCard extends StatelessWidget {
  ProductCard({super.key, required this.product, required this.onTap});

  Product product;
  final VoidCallback onTap;
  final ProductController productController = Get.put(ProductController());

  // final VariantController variantController = Get.put(VariantController());

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
                        id: product.id,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 120,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: product.thumbnail_image!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.main_price!,
                          style: const TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (product.has_discount!)
                          Text(
                            product.stroked_price!,
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
                      product.name!,
                      style: const TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap: () {
                        // Future.delayed(
                        //   const Duration(seconds: 1),
                        //   () => productController.getVariantData(product.id),
                        // );
                        print("Data Fetched");
                        variantBottomSheet();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyTheme.medium_grey,
                            borderRadius: BorderRadius.circular(5)),
                        height: 25,
                        width: 150,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Choose Option"),
                            Icon(Icons.arrow_drop_down_outlined)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyTheme.green,
                            borderRadius: BorderRadius.circular(5)),
                        height: 25,
                        width: 150,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add",
                              style: TextStyle(color: MyTheme.white),
                            ),
                            Icon(
                              Icons.add,
                              color: MyTheme.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
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
                if (product.has_discount!)
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
                      product.discount ?? "",
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
                  child: product.isWholesale != null && product.isWholesale!
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
    productController.fetchProductDetailsMain(product.id);
    print("Some Data");
    await Get.bottomSheet(
      GetBuilder<ProductController>(builder: (productController) {
        return Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Close'),
              ),
            ),
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
                          ))),
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
                              Text(
                                productController.totalPrice!,
                                // SystemConfig.systemCurrency!.code!=null?
                                // widget.main_price!.replaceAll(SystemConfig.systemCurrency!.code!, SystemConfig.systemCurrency!.symbol!)
                                //     :widget.main_price!,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              product.has_discount!
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 6),
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
                                        product.discount ?? "",
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
            Expanded(
              child: buildChoiceOptionList(),
            ),
          ],
        );
      }),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  DetailedProduct? _productDetails;

  buildChoiceOptionList() {
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
              productController.productDetails!.choice_options, index,productController.productDetails!.brand!.name),
        );
      },
    );
  }

  buildChoiceOpiton(choiceOptions, choiceOptionsIndex,mainPrice) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        14.0,
        0.0,
        0.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: app_language_rtl.$!
                ? const EdgeInsets.only(left: 8.0)
                : const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              // width: 80.w,
              child: Text(
                choiceOptions[choiceOptionsIndex].title,
                style: const TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
              ),
            ),
          ),
          SizedBox(
            // width: 250.w,
            child: Scrollbar(
              // controller: _variantScrollController,
              isAlwaysShown: false,
              child: Wrap(
                children: List.generate(
                    choiceOptions[choiceOptionsIndex].options.length,
                    (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: buildChoiceItem(
                            choiceOptions[choiceOptionsIndex].options[index],
                            choiceOptionsIndex,
                            index,mainPrice),),),
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
            height: 90.h,
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      productController.selectedChoices[choiceOptionsIndex] ==
                              option
                          ? MyTheme.accent_color
                          : MyTheme.noColor,
                  width: 1.5),
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
            child: Row(
              children: [
                Text(
                  option,
                  style: TextStyle(
                      color: productController
                                  .selectedChoices[choiceOptionsIndex] ==
                              option
                          ? MyTheme.accent_color
                          : const Color.fromRGBO(224, 224, 225, 1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  mainPrice,
                  style: TextStyle(
                      color: productController
                          .selectedChoices[choiceOptionsIndex] ==
                          option
                          ? MyTheme.accent_color
                          : const Color.fromRGBO(224, 224, 225, 1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
