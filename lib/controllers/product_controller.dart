import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_details_model.dart';
import '../models/product_response_model.dart';
import '../repositories/product_repository.dart';
import '../views/product_details/product_details.dart';

class ProductController extends GetxController {
  var isAddedToCart = true;
  var colorList = [];
  var selectedColorIndex = 0;
  DetailedProduct? productDetails;
  String? variant = "";
  int? quantity = 1;
  String? totalPrice = "";
  var stock_txt;
  final selectedChoices = [];
  var productImageList = [];
  var _choiceString = "";
  int? stock = 0;
  var productNewColorList = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // ProductDetails productDetailz = ProductDetails();

  setProductDetailValues() async {
    print("productDetailsCalled");
    if (productDetails != null) {
      // fetchVariantPrice();
      stock = productDetails!.current_stock;
       selectedChoices.clear();
      productDetails!.choice_options!.forEach((choiceOpiton) {
        selectedChoices.add(choiceOpiton.options![0]);
        print("choice Options ${choiceOpiton.options![0]}");
      });
      print("product Choices ${productDetails!.choice_options!}");
      // productDetails!.choice_options!.forEach((choiceOption) {
      //   if (choiceOption.options != null) {
      //     for (var option in choiceOption.options!) {
      //       selectedChoices.add(option);
      //     }
      //   }
      //   // _selectedChoices.add(choiceOpiton.options![0]);
      // });
      print("iiiiiiiiiiiiiiiiiiii=======> ${selectedChoices}");
      setChoiceString();
      update();
    }
  }

  setChoiceString() {
    _choiceString = selectedChoices.join(",").toString();
    print("ChoiceString=========> ${_choiceString}");
    update();
  }

  fetchProductDetailsMain(id) async {
    print("fetched Successfully");
    var productDetailsResponse =
        await ProductRepository().getProductDetails(id: id);
    // if (productDetailsResponse.detailed_products!.isNotEmpty) {
    productDetails = productDetailsResponse.detailed_products![0];
    print("products Colors---- ${productDetails!.colors}");
    // for (var color in productNewColorList) {
    //   colorList.add(color);
    //   print("colorssssssssss=====> ${colorList}");
    // }
    // }
    print("object");
    setProductDetailValues();
    getVariantData(id);
    update();
  }

  getVariantData(id) async {
    var colorString = productNewColorList.isNotEmpty
        ? productNewColorList[selectedColorIndex].toString().replaceAll("#", "")
        : "";
    print("varianrt id ${id}");
    print("varianrt choiceString ${_choiceString}");
    print("varianrt colorString ${colorString}");
    print("varianrt qty ${quantity}");

    // await ProductRepository().getVariantWiseInfo(id: id, color: colorString, variants: _choiceString, qty: quantity);

    var variantResponse = await ProductRepository().getVariantWiseInfo(
        id: id, color: colorString, variants: _choiceString, qty: quantity);
    print("varianrt stock ${variantResponse.variantData!.price}");
    print("Variant Response=============>${variantResponse.variantData}");
    if (variantResponse.variantData != null) {
      stock = variantResponse.variantData!.stock;
      stock_txt = variantResponse.variantData!.stockTxt;
      if (quantity! > stock!) {
        quantity = stock;
      }
      variant = variantResponse.variantData!.variant;
      totalPrice = variantResponse.variantData!.price;
      print("variant price ${totalPrice}");
      update();
    } else {
      // Handle null or unexpected response
      print("Error fetching Variants");
    }
  }

}
