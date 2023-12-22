import 'package:get/get.dart';
import 'package:krishanthmart_new/models/brand_model.dart';
import 'package:krishanthmart_new/models/flash_deal_model.dart';
import 'package:krishanthmart_new/repositories/brand_repository.dart';

import '../models/category_model.dart';
import '../models/product_response_model.dart';
import '../repositories/business_repositories.dart';
import '../repositories/category_repositories.dart';
import '../repositories/flashdeal_repositories.dart';
import '../repositories/product_repository.dart';
import '../repositories/slider_repository.dart';

class HomeController extends GetxController {
  var carouselImageList = [].obs;
  var bannerTwoImageList = [].obs;
  var flashDealList = <FlashDealResponseDatum>[].obs;
  List<Category> featuredCategoryList = [];
  List<Category> topCategoryList = [];
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
  bool isFeaturedProductInitial=true;
  bool isTodaysDealAvailable = true;
  bool isFlashDeal= false;
  bool isBestSellingProductAvailable = true;
  bool showFeaturedLoadingContainer = true;
  var currentPage = 0.obs;
  RxInt dealIndex = 0.obs;
  RxInt dealListIndex = 0.obs;
  var isAddedToCart = false.obs;
  int featuredProductPage= 1;
  var businessResponseDataList = [].obs;
  int? totalFeaturedProductData = 0;
  // var isExpanded = false.obs;

  var isExpanded = RxBool(false);

  @override
  void onInit() {
    fetchFlashDealData();
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchBannerTwoImages();
    fetchBestSellingProducts();
    fetchTodaysDealproducts();
    fetchBrandsData();
    fetchTopBrandsData();
    fetchFeaturedProducts();
    fetchBusinessResponse();
    // Future.delayed(const Duration(seconds: 0),() => fetchAll(),);
    super.onInit();
  }

  @override
  void onClose() {
    removeAll();
    super.onClose();
  }

  fetchCarouselImages() async {
    var carouselResponse = await SliderRepository().getSliders();
    for (var slider in carouselResponse.sliders!) {
      carouselImageList.add(slider.photo);
    }
    isCarouselInitial = false;
    update();
  }

  fetchBrandsData() async {
    try{
      var brandsResponse = await BrandRepository().getBrands();
      brandProductList.addAll(brandsResponse.brands! ?? []);
      isBrandInitiated = false;
    }catch(error){
      print("Error fetching products: $error");
    }
    update();
  }

  fetchTopBrandsData() async {
    try{
      var brandsResponse = await BrandRepository().getTopBrands();
      topBrandsList.addAll(brandsResponse.brands! ?? []);
    }catch(error){
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
    var businessResponse = await BusinessSettingRepository().getBusinessResponse();
    print("Getted Business Response =======>${businessResponse[0].value}");
    if (businessResponse.isNotEmpty) {
      businessResponseDataList.addAll(businessResponse);
      print("Getted Business List =======>${businessResponseDataList[0].value}");
    }
  }
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

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SliderRepository().getBannerTwoImages();
    for (var slider in bannerTwoResponse.sliders!) {
      bannerTwoImageList.add(slider.photo);
    }
    isBannerTwoInitial = false;
    update();
  }


  fetchAll() {
    fetchFlashDealData();
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchBannerTwoImages();
    fetchBestSellingProducts();
    fetchTodaysDealproducts();
    fetchBrandsData();
    fetchFeaturedProducts();
    fetchBusinessResponse();
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
