import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/cart_controller.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/product_details_model.dart';
import '../models/product_response_model.dart';
import '../repositories/cart_repositories.dart';
import '../repositories/product_repository.dart';
import '../repositories/wishlist_repositories.dart';
import '../utils/shared_value.dart';
import '../utils/toast_component.dart';
import '../views/auth/login.dart';
import '../views/cart/cart_page.dart';

class ProductController extends GetxController {
  CartController cartController = Get.put(CartController());
  var isAddedToCart = true;
  var colorList = [];
  var selectedColorIndex = 0;
  DetailedProduct? productDetails;
  List<Product>? productList;
  String? variant = "";
  int? quantity = 1;
  String? totalPrice = "";
  var stock_txt;
  final selectedChoices = [];
  var productImageList = [];
  var _choiceString = "";
  int? stock = 0;
  var productNewColorList = [];
  var quantityText = "1".obs;
  var itemsIndex = 0.obs;
  var getProductId = 0.obs;
  bool isInWishList = false;


  @override
  void onClose() {
    clearAll();
    super.onClose();
  }

  // ProductDetails productDetailz = ProductDetails();

  setProductDetailValues() async {
    if (productDetails != null) {
      // fetchVariantPrice();
      stock = productDetails!.current_stock;
      selectedChoices.clear();
      productDetails!.choice_options!.forEach((choiceOption) {
        selectedChoices.add(choiceOption.options![0]);
      });
      setChoiceString();
      update();
    }
  }

  setChoiceString() {
    _choiceString = selectedChoices.join(",").toString();
    update();
  }

  fetchProductDetailsMain(id) async {
    var productDetailsResponse =
        await ProductRepository().getProductDetails(id: id);
    productDetails = productDetailsResponse.detailed_products![0];
    setProductDetailValues();
    getVariantData(id);
    fetchWishListCheckInfo(id);
    update();
  }

  setQuantity(quantity) {
    quantityText.value = "${quantity ?? 0}";
    update();
  }

  getVariantData(id) async {
    var colorString = productNewColorList.isNotEmpty
        ? productNewColorList[selectedColorIndex].toString().replaceAll("#", "")
        : "";

    var variantResponse = await ProductRepository().getVariantWiseInfo(
        id: id, color: colorString, variants: _choiceString, qty: quantity);
    if (variantResponse.variantData != null) {
      stock = variantResponse.variantData!.stock;
      stock_txt = variantResponse.variantData!.stockTxt;
      if (quantity! > stock!) {
        quantity = stock;
      }
      variant = variantResponse.variantData!.variant;
      totalPrice = variantResponse.variantData!.price;
      setQuantity(quantity);
      update();
    } else {
      // Handle null or unexpected response
      print("Error fetching Variants");
    }
  }

  incrementQuantityCart(id, {snackbar, context}) {
    if (quantity! < stock!) {
      quantity = (quantity!) + 1;
      quantityText.value = quantity.toString();
      //fetchVariantPrice();
      getVariantData(id);
      update();
    }else if(quantity! < 1){
      if(snackbar != null && context != null){
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  decrementQuantityCart(id, {snackbar, context}) {
    if (quantity! > 1) {
      quantity = quantity! - 1;
      quantityText.value = quantity.toString();
      // calculateTotalPrice();
      // fetchVariantPrice();
      getVariantData(id);
      update();
    }else if(quantity == 1){
      print("No Stocks Available");
    }
    else{
      if(snackbar != null && context != null){
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  addToCart({mode, context = null, snackbar = null, id}) async {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.you_need_to_log_in,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    var cartAddResponse = await CartRepository()
        .getCartAddResponse(id, variant, user_id.$, quantity);

    if (cartAddResponse.result == false) {
      ToastComponent.showDialog(cartAddResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else {
      // Provider.of<CartCounter>(context, listen: false).getCount();
      cartController.getCount();
      if (mode == "add_to_cart") {
        if (snackbar != null && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        // reset();
        // fetchAll();
      } else if (mode == 'buy_now') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CartPage(has_bottomnav: false);
        })).then((value) {
          // onPopped(value);
        });
      }
    }
  }
  fetchWishListCheckInfo(id) async {
    var wishListCheckResponse =
    await WishListRepository().isProductInUserWishList(
      product_id: id,
    );
    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    isInWishList = wishListCheckResponse.is_in_wishlist;
    update();
  }

  addToWishList(id,{context = null}) async {
    var wishListCheckResponse =
    await WishListRepository().add(product_id: id);
    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    isInWishList = wishListCheckResponse.is_in_wishlist;
    update();
  }

  removeFromWishList(id,{context = null}) async {
    var wishListCheckResponse =
    await WishListRepository().remove(product_id: id);
    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    isInWishList = wishListCheckResponse.is_in_wishlist;
    update();
  }

  onWishTap(context,id,snackbar) {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.you_need_to_log_in,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (isInWishList) {
      isInWishList = false;
      if(snackbar != null && context != null){
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      removeFromWishList(id);
      update();
    } else {
      isInWishList = true;
      if(snackbar != null && context != null){
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      addToWishList(id);
      update();
    }
  }
  clearAll(){
    // restProductDetailValues();
    // _currentImage = 0;
    productImageList.clear();
    colorList.clear();
    selectedChoices.clear();
    _choiceString = "";
    variant = "";
    selectedColorIndex = 0;
    quantity = 1;
    isInWishList = false;
    getProductId.value = 0;
  }
}
