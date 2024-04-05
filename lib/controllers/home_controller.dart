import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/category_controller.dart';
import 'package:krishanthmart_new/models/brand_model.dart';
import 'package:krishanthmart_new/models/business_data_response.dart';
import 'package:krishanthmart_new/models/flash_deal_model.dart';
import 'package:krishanthmart_new/repositories/brand_repository.dart';
import 'package:krishanthmart_new/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/category_model.dart';
import '../models/product_response_model.dart';
import '../repositories/business_repositories.dart';
import '../repositories/category_repositories.dart';
import '../repositories/flashdeal_repositories.dart';
import '../repositories/payment_repositories.dart';
import '../repositories/product_repository.dart';
import '../repositories/slider_repository.dart';

class HomeController extends GetxController {
  var carouselImageList = [].obs;
  var carouselIdList = [].obs;
  var carouselNameList = [].obs;
  var carouselChildIdList = [].obs;
  var bannerTwoImageList = [].obs;
  var bannerFourImageList = [].obs;
  var bannerSixImageList = [].obs;
  var bannerOneImageList = [].obs;
  var bannerThreeImageList = [].obs;
  var bannerFiveImageList = [].obs;
  var bannerTwoIdList = [].obs;
  var bannerFourIdList = [].obs;
  var bannerSixIdList = [].obs;
  var bannerOneIdList = [].obs;
  var bannerThreeIdList = [].obs;
  var bannerFiveIdList = [].obs;
  var bannerTwoNameList = [].obs;
  var bannerFourNameList = [].obs;
  var bannerSixNameList = [].obs;
  var bannerOneNameList = [].obs;
  var bannerThreeNameList = [].obs;
  var bannerFiveNameList = [].obs;
  var bannerTwoChildIDList = [].obs;
  var bannerFourChildIDList = [].obs;
  var bannerSixChildIDList = [].obs;
  var bannerOneChildIDList = [].obs;
  var bannerThreeChildIDList = [].obs;
  var bannerFiveChildIDList = [].obs;
  var flashDealList = <FlashDealResponseDatum>[].obs;
  List<Category> featuredCategoryList = [];
  List<Category> topCategoryList = [];
  var subChildCategoriesHome = [].obs;
  var todayDealList = <Product>[].obs;
  List<Product> bestSellingProductList = [];
  List<Product> featuredProductList = [];
  List<Brands> brandProductList = [];
  List<Brands> topBrandsList = [];
  bool isCarouselInitial = true;
  bool isBannerOneInitial = true;
  bool isBannerTwoInitial = true;
  bool isCategoryInitial = true;
  bool isBrandInitiated = true;
  bool isFeaturedProductInitial = true;
  bool isTodaysDealAvailable = true;
  bool isFlashDeal = false;
  bool isBestSellingProductAvailable = true;
  bool showFeaturedLoadingContainer = true;
  var currentPage = 0.obs;
  RxInt dealIndex = 0.obs;
  RxInt dealListIndex = 0.obs;
  var isAddedToCart = false.obs;
  int featuredProductPage = 1;
  var businessResponseDataList = [].obs;
  var subChildCategories = [].obs;
  int? totalFeaturedProductData = 0;
  var couponColor = "".obs;
  var couponTitle = "".obs;
  var couponSubTitle = "".obs;
  Color? hexColorCoupon;
  var subCategoryIds = [].obs;
  CategoryController categoryController = Get.put(CategoryController());

  // var isExpanded = false.obs;

  var isExpanded = RxBool(false);

  @override
  void onInit() {
    fetchAll();
    super.onInit();
  }

  @override
  void onClose() {
    removeAll();
    super.onClose();
  }

  fetchCarouselImages() async {
    var carouselResponse = await SliderRepository().getSliders();
    for (var slider in carouselResponse.image!) {
      carouselImageList.add(slider);
    }
    for (var ids in carouselResponse.parentId!) {
      carouselIdList.add(ids);
    }
    for (var names in carouselResponse.parentName!) {
      carouselNameList.add(names);
    }
    for (var childId in carouselResponse.childId!) {
      carouselChildIdList.add(childId);
    }
    isCarouselInitial = false;
    update();
  }

  fetchBrandsData() async {
    try {
      var brandsResponse = await BrandRepository().getBrands();
      brandProductList.addAll(brandsResponse.brands! ?? []);
      isBrandInitiated = false;
    } catch (error) {
      print("Error fetching products: $error");
    }
    update();
  }

  fetchTopBrandsData() async {
    try {
      var brandsResponse = await BrandRepository().getTopBrands();
      topBrandsList.addAll(brandsResponse.brands! ?? []);
    } catch (error) {
      print("Error fetching products: $error");
    }
    update();
  }

  fetchFlashDealData() async {
    var deal = await FlashDealRepository().getFlashDeals();
    if (deal.success! && deal.flashDeals!.isNotEmpty) {
      flashDealList.addAll(deal.flashDeals! ?? []);
      isFlashDeal = true;
      update();
    }
  }

  fetchTodaysDealproducts() async {
    try {
      var todaysDealResponse =
          await ProductRepository().getTodaysDealProducts();
      todayDealList.value = todaysDealResponse.products ?? [];
      isTodaysDealAvailable = false;
    } catch (error) {
      // Handle error, e.g., show an error message
      print("Error fetching products: $error");
    }
    update();
  }

  fetchFeaturedProducts() async {
    var featuredProductResponse = await ProductRepository().getFeaturedProducts(
        // page: featuredProductPage,
        );
    // featuredProductPage++;
    featuredProductList.addAll(featuredProductResponse.products ?? []);
    // featuredProductList.addAll(productResponse.products!);
    isFeaturedProductInitial = false;
    totalFeaturedProductData = featuredProductResponse.meta!.total;
    showFeaturedLoadingContainer = false;
    update();
  }

  fetchBusinessResponse() async {
    var businessResponse =
        await BusinessSettingRepository().getBusinessResponse();
    if (businessResponse.isNotEmpty) {
      businessResponseDataList.addAll(businessResponse);
      for (Datum businessType in businessResponseDataList) {
        switch (businessType.type) {
          case "cupon_background_color":
            couponColor.value = businessType.value;
            break;
          case "cupon_title":
            couponTitle.value = businessType.value;
            break;
          case "cupon_subtitle":
            couponSubTitle.value = businessType.value;
            break;
          default:
            // Handle other types if needed
            break;
        }
      }
      // print("Getted Business List =======>${businessResponseDataList[0].value}");
    }
  }

  Color hexToColor(String hexColorCode) {
    try {
      // Ensure the input string is at least 7 characters long
      if (hexColorCode.length < 7) {
        throw ArgumentError("Invalid hex color code: $hexColorCode");
      }

      // Extract the substring from index 1 to 7
      String hexWithoutHash = hexColorCode.substring(1);

      // Ensure the substring is a valid hexadecimal color code
      if (RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hexWithoutHash)) {
        // Parse the hexadecimal color code and add the alpha value
        return Color(int.parse(hexWithoutHash, radix: 16) + 0xFF000000);
      } else {
        throw ArgumentError("Invalid hex color code: $hexColorCode");
      }
    } catch (e) {
      // If any error occurs, return a default color (e.g., black)
      print("Error converting hex color $hexColorCode: $e");
      return MyTheme.noColor;
    }
  }


  // Color hexToColor(hexColorCode) {
  //   try {
  //     // Ensure the input string is at least 7 characters long
  //     if (hexColorCode.length < 7) {
  //       throw ArgumentError("Invalid hex color code: $hexColorCode");
  //     }
  //
  //     // Extract the substring from index 1 to 7
  //     String hexWithoutHash = hexColorCode.substring(1, 7);
  //
  //     // Ensure the substring is a valid hexadecimal color code
  //     if (RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hexWithoutHash)) {
  //       // Parse the hexadecimal color code and add the alpha value
  //       return Color(int.parse(hexWithoutHash, radix: 16) + 0xFF000000);
  //     } else {
  //       throw ArgumentError("Invalid hex color code: $hexColorCode");
  //     }
  //   } catch (e) {
  //     // If any error occurs, return a default color (e.g., black)
  //     print("Error converting hex color: $e");
  //     return MyTheme.noColor;
  //   }
  // }

  void toggleExpansion() {
    isExpanded(!isExpanded.value);
  }

  fetchBestSellingProducts() async {
    try {
      var bestSellingProducts =
          await ProductRepository().getBestSellingProducts();
      bestSellingProductList.addAll(bestSellingProducts.products ?? []);
      isBestSellingProductAvailable = false;
    } catch (e) {
      print("Error fetching Categories: $e");
    }
    update();
  }

  fetchFeaturedCategories() async {
    try {
      var categoryResponse = await CategoryRepository().getFeaturedCategories();
      featuredCategoryList.addAll(categoryResponse.categories ?? []);
      isCategoryInitial = false;
      print("length feature ${featuredCategoryList.length}");
    } catch (e) {
      print("Error fetching Categories: $e");
    }
    update();
  }

  fetchTopCategories() async {
    try {
      var categoryResponse = await CategoryRepository().getTopCategories();
      topCategoryList.addAll(categoryResponse.categories ?? []);
      // isCategoryInitial = false;
    } catch (e) {
      print("Error fetching Categories: $e");
    }
    update();
  }

  getChildSubCategories(int subChildCategory) async {
    // subChildCategoriesHome.clear();
    var subChildCategoriesRes = await CategoryRepository()
        .getSubChildCategories(categoryId: subChildCategory);
    subChildCategoriesHome.addAll(subChildCategoriesRes.subChildCategory);
    for (var sub in subChildCategoriesHome) {
      subCategoryIds.add(sub.id);
      break;
    }
    update();
  }

  fetchSliderImages() async {
    await SliderRepository().getBannerOneImages();
    // await SliderRepository().getBannerThreeImages();
    await SliderRepository().getBannerFiveImages();
  }

  fetchBannerFiveImages() async {
    var bannerFiveImages = await SliderRepository().getBannerFiveImages();
    for (var slider in bannerFiveImages.image!) {
      bannerFiveImageList.add(slider);
    }
    for (var ids in bannerFiveImages.parentId!) {
      bannerFiveIdList.add(ids);
    }
    for (var names in bannerFiveImages.parentName!) {
      bannerFiveNameList.add(names);
    }
    for (var childId in bannerFiveImages.childId!) {
      bannerFiveChildIDList.add(childId);
    }
    update();
  }

  fetchBannerOneImages() async {
    var bannerOneImages = await SliderRepository().getBannerOneImages();
    for (var slider in bannerOneImages.image!) {
      bannerOneImageList.add(slider);
    }
    for (var ids in bannerOneImages.parentId!) {
      bannerOneIdList.add(ids);
    }
    for (var names in bannerOneImages.parentName!) {
      bannerOneNameList.add(names);
    }
    for (var childId in bannerOneImages.childId!) {
      bannerOneChildIDList.add(childId);
    }
    update();
  }

  fetchBannerThreeImages() async {
    var bannerOneImages = await SliderRepository().getBannerThreeImages();
    for (var slider in bannerOneImages.image!) {
      bannerThreeImageList.add(slider);
    }
    for (var ids in bannerOneImages.parentId!) {
      bannerThreeIdList.add(ids);
    }
    for (var names in bannerOneImages.parentName!) {
      bannerThreeNameList.add(names);
    }
    for (var childId in bannerOneImages.childId!) {
      bannerThreeChildIDList.add(childId);
    }
    update();
  }

  fetchBannerFourImages() async {
    var bannerTwoResponse = await SliderRepository().getBannerFourImages();
    for (var slider in bannerTwoResponse.image!) {
      bannerFourImageList.add(slider);
    }
    for (var ids in bannerTwoResponse.parentId!) {
      bannerFourIdList.add(ids);
    }
    for (var names in bannerTwoResponse.parentName!) {
      bannerFourNameList.add(names);
    }
    for (var childId in bannerTwoResponse.childId!) {
      bannerFourChildIDList.add(childId);
    }
    update();
  }

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SliderRepository().getBannerTwoImages();
    for (var slider in bannerTwoResponse.image!) {
      bannerTwoImageList.add(slider);
    }
    for (var ids in bannerTwoResponse.parentId!) {
      bannerTwoIdList.add(ids);
    }
    for (var names in bannerTwoResponse.parentName!) {
      bannerTwoNameList.add(names);
    }
    for (var childId in bannerTwoResponse.childId!) {
      bannerTwoChildIDList.add(childId);
    }
    isBannerTwoInitial = false;
    update();
  }

  fetchBannerSixImages() async {
    var bannerTwoResponse = await SliderRepository().getBannerSixImages();
    for (var slider in bannerTwoResponse.image!) {
      bannerSixImageList.add(slider);
    }
    for (var ids in bannerTwoResponse.parentId!) {
      bannerSixIdList.add(ids);
    }
    for (var names in bannerTwoResponse.parentName!) {
      bannerSixNameList.add(names);
    }
    for (var childId in bannerTwoResponse.childId!) {
      bannerSixChildIDList.add(childId);
    }
    // bannerSixIdList.value = bannerTwoResponse.productId as RxList;
    update();
  }

  openWhatsApp(context) async {
    var whatsapp = "+919597959797";
    var whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=Hello, I have a question about https://krishanthmart.com/";
    var whatsappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatsappURL_ios)) {
        await launch(whatsappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed")));
      }
    }
  }

  fetchAll() {
    fetchFlashDealData();
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchBannerOneImages();
    fetchBannerTwoImages();
    fetchBannerFourImages();
    fetchBannerFiveImages();
    fetchBannerThreeImages();
    fetchBannerSixImages();
    fetchBestSellingProducts();
    fetchTodaysDealproducts();
    fetchBrandsData();
    fetchTopBrandsData();
    fetchFeaturedProducts();
    fetchBusinessResponse();
    fetchSliderImages();
    update();
  }

  removeAll() {
    flashDealList.clear();
    carouselImageList.clear();
    featuredCategoryList.clear();
    bannerTwoImageList.clear();
    topCategoryList.clear();
    todayDealList.clear();
    bestSellingProductList.clear();
    featuredProductList.clear();
    brandProductList.clear();
    topBrandsList.clear();
    bannerFourImageList.clear();
    bannerSixImageList.clear();
    bannerOneImageList.clear();
    bannerFiveImageList.clear();
    bannerFiveIdList.clear();
    bannerOneIdList.clear();
    bannerTwoIdList.clear();
    bannerThreeIdList.clear();
    bannerFourIdList.clear();
    bannerSixIdList.clear();
    bannerTwoNameList.clear();
    bannerOneNameList.clear();
    bannerThreeNameList.clear();
    bannerFiveNameList.clear();
    bannerFourNameList.clear();
    bannerSixNameList.clear();
    bannerTwoChildIDList.clear();
    bannerOneChildIDList.clear();
    bannerThreeChildIDList.clear();
    bannerFiveChildIDList.clear();
    bannerFourChildIDList.clear();
    bannerSixChildIDList.clear();
    subChildCategoriesHome.clear();
    isCarouselInitial = true;
    isBannerOneInitial = true;
    isBannerTwoInitial = true;
    isCategoryInitial = true;
    isFeaturedProductInitial = true;
    isBrandInitiated = true;
    update();
  }

  reset() {
    carouselImageList.clear();
    bannerTwoImageList.clear();
    featuredCategoryList.clear();
    todayDealList.clear();
    topCategoryList.clear();
    bestSellingProductList.clear();
    isCarouselInitial = true;
    isBannerOneInitial = true;
    isBannerTwoInitial = true;
    isCategoryInitial = true;
    // cartCount = 0;
  }

  Future<void> onRefresh() async {
    reset();
    fetchAll();
  }
}
