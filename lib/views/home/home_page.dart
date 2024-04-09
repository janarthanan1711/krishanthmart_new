import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/cart_controller.dart';
import 'package:krishanthmart_new/controllers/delivery_slot_controller.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import 'package:krishanthmart_new/controllers/product_controller.dart';
import 'package:krishanthmart_new/utils/colors.dart';
import 'package:krishanthmart_new/utils/image_directory.dart';
import 'package:krishanthmart_new/views/category/sub_category_page.dart';
import 'package:krishanthmart_new/views/coupons/coupon.dart';
import 'package:krishanthmart_new/views/filters/filters.dart';
import 'package:krishanthmart_new/views/flashdeals/flashdealslist.dart';
import 'package:krishanthmart_new/views/home/components/banner_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:krishanthmart_new/views/mainpage/components/brand_grid.dart';
import 'package:krishanthmart_new/views/product_details/all_products.dart';
import 'package:krishanthmart_new/views/product_details/components/product_large_card_list.dart';
import 'package:toast/toast.dart';
import '../../controllers/location_controller.dart';
import '../../helpers/main_helpers.dart';
import '../../models/flash_deal_model.dart';
import '../../models/slider_model.dart';
import '../../repositories/flashdeal_repositories.dart';
import '../../utils/device_info.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/toast_component.dart';
import '../auth/login.dart';
import '../category/category_page.dart';
import '../category/components/category_grid.dart';
import '../flashdeals/flashdealproducts.dart';
import '../mainpage/components/box_decorations.dart';
import '../product_details/product_details.dart';
import '../profile/profile_edit.dart';
import 'components/carousel_deal_card.dart';
import 'components/home_carousel.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'components/product_card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());
  final LocationController locationController = Get.put(LocationController());
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());
  final DeliverySlotController deliveryController =
      Get.put(DeliverySlotController());
  late CarouselController _carouselController;
  late ScrollController _scrollController;
  late final SliderResponse sliderResponse;
  GlobalKey<State<StatefulWidget>> itemKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carouselController = CarouselController();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    cartController.getCount();
    locationController.getUserLocation();
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (80.h - kToolbarHeight);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  showLoginWarning() {
    return ToastComponent.showDialog(
        AppLocalizations.of(context)!.you_need_to_log_in,
        gravity: Toast.center,
        duration: Toast.lengthLong);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: CustomScrollView(
          dragStartBehavior: DragStartBehavior.start,
          controller: _scrollController,
          shrinkWrap: false,
          physics: const ClampingScrollPhysics(),
          semanticChildCount: 1,
          clipBehavior: Clip.none,
          slivers: [
            SliverAppBar(
              backgroundColor: MyTheme.noColor,
              title: Text(
                AppLocalizations.of(context)!.app_name_caps,
                style: TextStyle(
                  color: MyTheme.black,
                  fontSize: Get.height > 690 ? 23.sp : 18.sp,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              pinned: true,
              snap: false,
              floating: false,
              // expandedHeight: 155.h,
              expandedHeight: DeviceInfo(context).height! > 690 ? 118.h : 111.h,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15.0),
                  ),
                  color: Color(0xFFF7EF8A),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Color(0xFFAE8625),
                  //     Color(0xFFF7EF8A),
                  //     Color(0xFFD2AC47),
                  //   ],
                  // ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    homeController.openWhatsApp(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(ImageDirectory.whatsApp),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: is_logged_in.$
                          ? () {
                              Get.to(() => ProfileEdit());
                            }
                          : () => Get.to(() => Login()),
                      child: is_logged_in.$
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${avatar_original.$}"))
                          : Image.asset(
                              'assets/profile_placeholder.png',
                              height: 48,
                              width: 48,
                              fit: BoxFit.fitHeight,
                            ),
                    ),
                    // child: const CircleAvatar(
                    //   backgroundImage:
                    //   AssetImage(ImageDirectory.profileIconImage),
                    // ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                // preferredSize: Size.fromHeight(24.6.h),
                preferredSize: Size.fromHeight(0),
                child: _isSliverAppBarExpanded
                    ? InkWell(
                        onTap: () {
                          Get.to(() => Filter());
                        },
                        child: Container(
                          // height: 32.h,
                          height: 37.5.h,
                          margin: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              bottom: MediaQuery.of(context).size.height > 690
                                  ? 15.4.h
                                  : 20.h),
                          padding: EdgeInsets.only(right: 14.5.w, left: 14.5.w),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(color: MyTheme.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Search...",
                                style: TextStyle(color: MyTheme.medium_grey),
                              ),
                              Icon(
                                Icons.search,
                                color: MyTheme.medium_grey,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => Filter());
                            },
                            child: Container(
                              height: 37.h,
                              // height: 30.h,
                              margin: EdgeInsets.only(left: 16.w, right: 16.w),
                              padding:
                                  EdgeInsets.only(right: 14.5.w, left: 14.5.w),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(color: MyTheme.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Search...",
                                    style:
                                        TextStyle(color: MyTheme.medium_grey),
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: MyTheme.medium_grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 350.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 130.w,
                                  child: Obx(
                                  ()=> Text(
                                      homeController.headerText1.value,
                                      style: TextStyle(
                                          color: const Color(0xFF996515),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "|",
                                  style: TextStyle(
                                      color: const Color(0xFF996515),
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(
                                  width: 120.w,
                                  child: Text(
                                    homeController.headerText2.value,
                                    style: TextStyle(
                                        color: const Color(0xFF996515),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  addRepaintBoundaries: true,
                  childCount: 1,
                  (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          // color: Color(0xFFe6f8e8),
                          // color: Color(0xFFffefc2),
                          color: Colors.yellow[100],
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Row(
                              children: [
                                Obx(() {
                                  // Obx will rebuild when pincodeList changes
                                  return Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: MyTheme.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: locationController
                                                .pincodeData.value ==
                                            ""
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: MyTheme.accent_color2,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Text("Pincode: "),
                                              Text(
                                                user_pincode.$ == ''
                                                    ? locationController
                                                        .pincodeData.value
                                                    : user_pincode.$,
                                                style: TextStyle(
                                                    color:
                                                        MyTheme.accent_color2,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                  );
                                }),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Delivery Time Slot Available",
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.alarm,
                                            color: MyTheme.accent_color2,
                                            size: 11.sp,
                                          ),
                                          Obx(
                                            () => Row(
                                              children: List.generate(
                                                deliveryController
                                                    .deliveryTimeSlot.length,
                                                (index) => Text(
                                                  " ${deliveryController.deliveryTimeSlot[index].transitTime!}",
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: MyTheme
                                                          .accent_color2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.red[100],
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  pincode_matched.$ == true
                                      ? Text(
                                          "Service Available for this pincode ${locationController.pincodeData.value}",
                                          style: TextStyle(
                                            color: MyTheme.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : locationController.isLoading
                                              .value // Assuming you have an isLoading variable in your LocationController
                                          ? CircularProgressIndicator() // Show loader if isLoading is true
                                          : Text(
                                              "Service Not Available for this pincode ${locationController.pincodeData.value}",
                                              style: TextStyle(
                                                color: MyTheme.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const CustomCarousel(),
                        SizedBox(
                          height: 26.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .shop_by_category,
                                  style: TextStyle(
                                    color: MyTheme.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                InkWell(
                                  child: Text(
                                    AppLocalizations.of(context)!.view_more_ucf,
                                    style: TextStyle(
                                        color: MyTheme.black, fontSize: 14.sp),
                                  ),
                                  onTap: () {
                                    Get.to(
                                      () => CategoryListPages(
                                        is_viewMore: true,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          // height: 218.h,
                          height: ScreenUtil().setHeight(336),
                          // height: ScreenUtil().setHeight(330),
                          child: CategoryGridView(
                            homeController.featuredCategoryList,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          width: DeviceInfo(context).width,
                          color: MyTheme.light_blue,
                          child: Text(
                            AppLocalizations.of(context)!.highlight_ucf,
                            style: TextStyle(
                              color: MyTheme.PrimaryColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Container(
                          color: MyTheme.light_blue,
                          width: DeviceInfo(context).width,
                          child: Obx(
                            () => ListView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    homeController.bannerTwoImageList.length,
                                itemBuilder: (context, index) {
                                  String imageUrl =
                                      homeController.bannerTwoImageList[index];
                                  int productId =
                                      homeController.bannerTwoIdList[index];
                                  String categoryName =
                                      homeController.bannerTwoNameList[index];
                                  String subCategoryId = homeController
                                      .bannerTwoChildIDList[index];
                                  // homeController.getChildSubCategories(
                                  //   int.parse(productId),
                                  // );
                                  // int subCategoryId = homeController
                                  //     .subChildCategoriesHome[index].id;
                                  // String productName = homeController
                                  //     .subChildCategoriesHome[index].name;
                                  if (homeController
                                      .bannerTwoImageList.isEmpty) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return BannersHomeList(
                                      imageUrl: imageUrl,
                                      productId: productId,
                                      subCategoryId: subCategoryId,
                                      productName: categoryName,
                                    );
                                  }
                                }),
                          ),
                        ),
                        Container(
                          // color: MyTheme.mild_green,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [MyTheme.white, MyTheme.cinnabar],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          width: DeviceInfo(context).width,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .baskets_must_have,
                                      style: TextStyle(
                                        color: MyTheme.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    // InkWell(
                                    //   child: Text(
                                    //     AppLocalizations.of(context)!
                                    //         .view_more_ucf,
                                    //     style: TextStyle(
                                    //         color: MyTheme.black,
                                    //         fontSize: 14.sp),
                                    //   ),
                                    //   onTap: () {},
                                    // )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 4.w,
                                    right: 4.w,
                                    top: 4.h,
                                    bottom: 4.h),
                                width: ScreenUtil().screenWidth,
                                height: ScreenUtil().setHeight(325),
                                // height: ScreenUtil().setHeight(320),
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 4,
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    int productId =
                                        homeController.bannerFiveIdList[index];
                                    String categoryName = homeController
                                        .bannerFiveNameList[index];
                                    String subCategoryId = homeController
                                        .bannerFiveChildIDList[index];
                                    if (homeController
                                        .bannerFiveImageList.isEmpty) {
                                      return ShimmerHelper()
                                          .buildProductGridShimmer();
                                    } else {
                                      return InkWell(
                                        onTap: () async {
                                          // Get.to(
                                          //   () => ProductDetails(
                                          //     id: int.parse(
                                          //       productId,
                                          //     ),
                                          //   ),
                                          // );
                                          await Get.to(
                                            () => SubCategoryPage(
                                              categoryId: productId,
                                              subCategoryId:
                                                  int.parse(subCategoryId),
                                              selectedIndexes:
                                                  int.parse(subCategoryId),
                                              categoryName: categoryName,
                                              from_banner: true,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: ScreenUtil().setHeight(40),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    homeController
                                                            .bannerFiveImageList[
                                                        index]),
                                                fit: BoxFit.fill),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        homeController.bannerOneImageList.isNotEmpty
                            ? CarouselSlider.builder(
                                itemCount:
                                    homeController.bannerOneImageList.length,
                                itemBuilder: (context, index, realIndex) {
                                  final imageUrl =
                                      homeController.bannerOneImageList[index];
                                  int categoryId =
                                      homeController.bannerOneIdList[index];
                                  String subCategoryId = homeController
                                      .bannerOneChildIDList[index];
                                  String categoryName =
                                      homeController.bannerOneNameList[index];
                                  if (homeController
                                      .bannerOneImageList.isEmpty) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => SubCategoryPage(
                                            categoryName: categoryName,
                                            categoryId: categoryId,
                                            subCategoryId:
                                                int.parse(subCategoryId),
                                            selectedIndexes:
                                                int.parse(subCategoryId),
                                            from_banner: true,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2.5.h),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.fill),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    );
                                  }
                                },
                                options: CarouselOptions(
                                  height: 150.h,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 4),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  reverse: true,
                                  enlargeCenterPage: true,
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.todays_deal_ucf,
                                style: TextStyle(
                                  color: MyTheme.black,
                                  fontSize: 16.sp,
                                ),
                              ),
                              InkWell(
                                child: Text(
                                  AppLocalizations.of(context)!.view_more_ucf,
                                  style: TextStyle(
                                      color: MyTheme.black, fontSize: 14.sp),
                                ),
                                onTap: () {
                                  Get.to(
                                    () => AllProducts(
                                      selected_products: "todays_offer",
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: DeviceInfo(context).width,
                          height: 386.h,
                          child: Column(
                            children: [
                              Obx(
                                () => CarouselSlider.builder(
                                  carouselController: _carouselController,
                                  itemCount:
                                      homeController.todayDealList.length,
                                  options: CarouselOptions(
                                    height: 298.h,
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    viewportFraction: 1,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 1000),
                                    autoPlayCurve: Curves.slowMiddle,
                                    onPageChanged: (index, reason) {
                                      homeController.dealIndex.value = index;
                                    },
                                  ),
                                  itemBuilder: (BuildContext context, int index,
                                      int realIndex) {
                                    return Obx(
                                      () => CarouselDealCard(
                                        product:
                                            homeController.todayDealList[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 85.h,
                                child: Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        homeController.todayDealList.length,
                                    itemBuilder: (context, index) {
                                      return Obx(
                                        () => InkWell(
                                          child: Container(
                                            height: 80.h,
                                            width: 80.h,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4.w),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: homeController
                                                            .dealIndex.value ==
                                                        index
                                                    ? MyTheme.green
                                                    : MyTheme.golden_shadow,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  homeController
                                                      .todayDealList[index]
                                                      .thumbnail_image!,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            // homeController.dealIndex.value = index;
                                            _carouselController
                                                .jumpToPage(index);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        homeController.flashDealList.isNotEmpty
                            ? Container(
                                width: DeviceInfo(context).width,
                                color: MyTheme.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 5.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .flash_deal_ucf,
                                          style: TextStyle(
                                            color: MyTheme.black,
                                            fontSize: 16.sp,
                                          )),
                                      InkWell(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .view_more_ucf,
                                          style: TextStyle(
                                              color: MyTheme.black,
                                              fontSize: 14.sp),
                                        ),
                                        onTap: () {
                                          Get.to(() => const FlashDealList());
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        homeController.flashDealList.isNotEmpty
                            ? buildFlashDealList(context)
                            : const SizedBox(),
                        // Container(
                        //   color: MyTheme.noColor,
                        //   width: DeviceInfo(context).width,
                        //   child: ListView.builder(
                        //       padding: const EdgeInsets.all(0),
                        //       shrinkWrap: true,
                        //       physics: const NeverScrollableScrollPhysics(),
                        //       itemCount: 1,
                        //       itemBuilder: (context, index) {
                        //         String imageUrl =
                        //             homeController.bannerFiveImageList[0];
                        //         String productId =
                        //             homeController.bannerFiveIdList[0];
                        //         homeController.getChildSubCategories(
                        //             int.parse(productId));
                        //         int subCategoryId = homeController
                        //             .subChildCategoriesHome[index].id;
                        //         String productName = homeController
                        //             .subChildCategoriesHome[index].name;
                        //         if (homeController
                        //             .bannerFiveImageList.isEmpty) {
                        //           return const Center(
                        //               child: CircularProgressIndicator());
                        //         } else {
                        //           return BannersHomeList(
                        //             imageUrl: imageUrl,
                        //             productId: productId,
                        //             subCategoryId: subCategoryId,
                        //             productName: productName,
                        //           );
                        //         }
                        //       }),
                        // ),
                        Container(
                          height: 225.h,
                          width: DeviceInfo(context).width,
                          color: MyTheme.blue_light2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.w, right: 4.w, top: 1.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.best_deals,
                                      style: TextStyle(
                                        color: MyTheme.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .view_more_ucf,
                                        style: TextStyle(
                                            color: MyTheme.black,
                                            fontSize: 14.sp),
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => AllProducts(
                                            selected_products: "best_deals",
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 202.h,
                                child: GetBuilder<HomeController>(
                                  builder: (homeController) {
                                    return ProductLargeCardList(
                                        productList:
                                            homeController.todayDealList,
                                        onTap: () {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   color: MyTheme.noColor,
                        //   width: DeviceInfo(context).width,
                        //   child: ListView.builder(
                        //       padding: const EdgeInsets.all(0),
                        //       shrinkWrap: true,
                        //       physics: const NeverScrollableScrollPhysics(),
                        //       itemCount: 1,
                        //       itemBuilder: (context, index) {
                        //         String imageUrl =
                        //             homeController.bannerThreeImageList[0];
                        //         int productId =
                        //             homeController.bannerThreeIdList[0];
                        //         String categoryName =
                        //             homeController.bannerThreeNameList[0];
                        //         String subCategoryId =
                        //             homeController.bannerThreeChildIDList[0];
                        //         // homeController.getChildSubCategories(
                        //         //     int.parse(productId));
                        //         // int subCategoryId = homeController
                        //         //     .subChildCategoriesHome[index].id;
                        //         // String productName = homeController
                        //         //     .subChildCategoriesHome[index].name;
                        //         if (homeController
                        //             .bannerThreeImageList.isEmpty) {
                        //           return const Center(
                        //               child: CircularProgressIndicator());
                        //         } else {
                        //           return BannersHomeList(
                        //             imageUrl: imageUrl,
                        //             productId: productId,
                        //             productName: categoryName,
                        //             subCategoryId: subCategoryId,
                        //           );
                        //         }
                        //       }),
                        // ),
                        Container(
                          color: Color(0xFFfaf3cf),
                          width: DeviceInfo(context).width,
                          height: 255.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .best_selling_ucf,
                                      style: TextStyle(
                                        color: MyTheme.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .view_more_ucf,
                                        style: TextStyle(
                                            color: MyTheme.black,
                                            fontSize: 14.sp),
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => AllProducts(
                                            selected_products: "best_selling",
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 210.h,
                                child: GetBuilder<HomeController>(
                                  builder: (homeController) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 6,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: ProductCard(
                                              product: homeController
                                                      .bestSellingProductList[
                                                  index],
                                              onTap: () {},
                                              itemIndex: index,
                                            ));
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: MyTheme.noColor,
                          width: DeviceInfo(context).width,
                          child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                String imageUrl =
                                    homeController.bannerThreeImageList[index];
                                int productId =
                                    homeController.bannerThreeIdList[index];
                                String categoryName =
                                    homeController.bannerThreeNameList[index];
                                String subCategoryId =
                                    homeController.bannerThreeChildIDList[index];
                                if (homeController
                                    .bannerThreeImageList.isEmpty) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return BannersHomeList(
                                    imageUrl: imageUrl,
                                    productId: productId,
                                    productName: categoryName,
                                    subCategoryId: subCategoryId,
                                  );
                                }
                              }),
                        ),
                        // Container(
                        //   width: DeviceInfo(context).width,
                        //   child: Obx(
                        //     () => ListView.builder(
                        //         padding: const EdgeInsets.all(0),
                        //         shrinkWrap: true,
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         itemCount:
                        //             homeController.bannerThreeImageList.length,
                        //         itemBuilder: (context, index) {
                        //           String imageUrl = homeController
                        //               .bannerThreeImageList[index];
                        //           String categoryName =
                        //               homeController.bannerThreeNameList[index];
                        //           int productId =
                        //               homeController.bannerThreeIdList[index];
                        //           String subCategoryId = homeController
                        //               .bannerThreeChildIDList[index];
                        //           // homeController.getChildSubCategories(
                        //           //     int.parse(productId));
                        //           // int subCategoryId = homeController
                        //           //     .subChildCategoriesHome[index].id;
                        //           // String productName = homeController
                        //           //     .subChildCategoriesHome[index].name;
                        //           if (homeController
                        //               .bannerThreeImageList.isEmpty) {
                        //             return const SizedBox();
                        //           } else {
                        //             return InkWell(
                        //               onTap: () async {
                        //                 await Get.to(
                        //                   () => SubCategoryPage(
                        //                     categoryId: productId,
                        //                     subCategoryId:
                        //                         int.parse(subCategoryId),
                        //                     selectedIndexes:
                        //                         int.parse(subCategoryId),
                        //                     categoryName: categoryName,
                        //                   ),
                        //                 );
                        //               },
                        //               child: Container(
                        //                 height: 150.h,
                        //                 width: DeviceInfo(context).width,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(5),
                        //                   image: DecorationImage(
                        //                       image: NetworkImage(imageUrl),
                        //                       fit: BoxFit.fill),
                        //                 ),
                        //               ),
                        //             );
                        //           }
                        //         }),
                        //   ),
                        // ),
                        Container(
                          color: MyTheme.light_purple2,
                          width: DeviceInfo(context).width,
                          height: 255.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!
                                            .featured_products_ucf,
                                        style: TextStyle(
                                          color: MyTheme.black,
                                          fontSize: 16.sp,
                                        )),
                                    InkWell(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .view_more_ucf,
                                        style: TextStyle(
                                            color: MyTheme.black,
                                            fontSize: 14.sp),
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => AllProducts(
                                            selected_products:
                                                "featured_products",
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 210.h,
                                child: GetBuilder<HomeController>(
                                  builder: (homeController) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 6,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        // productController.itemsIndex.value = index;
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: ProductCard(
                                            product: homeController
                                                .featuredProductList[index],
                                            onTap: () {},
                                            itemIndex: index,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.h),
                          child: Container(
                            height: 195.h,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20.0) //                 <--- border radius here
                              ),
                              gradient:  LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [MyTheme.couponFirstColor, MyTheme.couponSecondColor],
                                )
                              // color: homeController
                              //     .hexToColor(homeController.couponColor.value),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(homeController.couponTitle.value,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.sp,
                                        color: MyTheme.white),
                                    textAlign: TextAlign.center),
                                Text(homeController.couponSubTitle.value,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.sp,
                                        color: MyTheme.white),
                                    textAlign: TextAlign.center),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const Coupons());
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                        color: MyTheme.medium_grey,
                                        border: Border.all(color: MyTheme.white),
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.view_coupon,
                                        style: const TextStyle(
                                            color: MyTheme.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: MyTheme.light_purple,
                          width: DeviceInfo(context).width,
                          height: 278.h,
                          child: const BrandCategoryView(),
                        ),
                        Container(
                          color: MyTheme.white,
                          padding:
                              EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.homekitchenhave,
                                style: TextStyle(
                                  color: MyTheme.black,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: MyTheme.white,
                          width: DeviceInfo(context).width,
                          // height: 324.h,
                          height: 150.h,
                          child: Obx(
                            () => ListView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    homeController.bannerSixImageList.length,
                                itemBuilder: (context, index) {
                                  String imageUrl =
                                      homeController.bannerSixImageList[index];
                                  int productId =
                                      homeController.bannerSixIdList[index];
                                  String subCategoryId = homeController
                                      .bannerSixChildIDList[index];
                                  String categoryName =
                                      homeController.bannerSixNameList[index];
                                  if (homeController
                                      .bannerSixImageList.isEmpty) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2.5.h, horizontal: 5.w),
                                        // height: 100.h,
                                        height: 100.h,
                                        width: 145.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyTheme.medium_grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      onTap: () {
                                        Get.to(() => SubCategoryPage(
                                              subCategoryId:
                                                  int.parse(subCategoryId),
                                              categoryId: productId,
                                              categoryName: categoryName,
                                              selectedIndexes:
                                                  int.parse(subCategoryId),
                                              from_banner: true,
                                            ));
                                      },
                                    );
                                  }
                                }),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [MyTheme.white, Colors.pink[100]!],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.h, bottom: 10.h),
                                child: Text(
                                  AppLocalizations.of(context)!.offer_zone,
                                  style: TextStyle(
                                      color: MyTheme.dark_purple,
                                      fontSize: 20.sp,
                                      fontFamily: 'Pacifico',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // color: MyTheme.light_blue,
                          width: DeviceInfo(context).width,
                          child: Obx(
                            () => ListView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    homeController.bannerFourImageList.length,
                                itemBuilder: (context, index) {
                                  String imageUrl =
                                      homeController.bannerFourImageList[index];
                                  int categoryId =
                                      homeController.bannerFourIdList[index];
                                  String subCategoryId = homeController
                                      .bannerFourChildIDList[index];
                                  String categoryName =
                                      homeController.bannerFourNameList[index];
                                  if (homeController
                                      .bannerFourImageList.isEmpty) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => SubCategoryPage(
                                              categoryId: categoryId,
                                              subCategoryId:
                                                  int.parse(subCategoryId),
                                              categoryName: categoryName,
                                              selectedIndexes:
                                                  int.parse(subCategoryId),
                                              from_banner: true,
                                            ));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2.5.h),
                                        // height: 100.h,
                                        height: 100.h,
                                        width: DeviceInfo(context).width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      ],
                    );
                    // });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildFlashDealList(context) {
  return FutureBuilder<FlashDealResponse>(
      future: FlashDealRepository().getFlashDeals(),
      builder: (context, AsyncSnapshot<FlashDealResponse> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(AppLocalizations.of(context)!.network_error),
          );
        } else if (snapshot.hasData) {
          FlashDealResponse flashDealResponse = snapshot.data!;
          return buildFlashDealListItem(flashDealResponse, 0, context);
        } else {
          return SizedBox();
        }
      });
}

final List<CountdownTimerController> _timerControllerList = [];

DateTime convertTimeStampToDateTime(int timeStamp) {
  var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return dateToTimeStamp;
}

buildFlashDealListItem(
    FlashDealResponse flashDealResponse, index, BuildContext context) {
  DateTime end = convertTimeStampToDateTime(
      flashDealResponse.flashDeals![index].date!); // YYYY-mm-dd
  DateTime now = DateTime.now();
  int diff = end.difference(now).inMilliseconds;
  int endTime = diff + now.millisecondsSinceEpoch;

  void onEnd() {}

  CountdownTimerController timeController =
      CountdownTimerController(endTime: endTime, onEnd: onEnd);
  _timerControllerList.add(timeController);

  return SizedBox(
    // color: MyTheme.amber,
    height: 276.h,
    child: CountdownTimer(
      controller: _timerControllerList[index],
      widgetBuilder: (_, CurrentRemainingTime? time) {
        return GestureDetector(
          onTap: () {
            if (time == null) {
              ToastComponent.showDialog(
                AppLocalizations.of(context)!.flash_deal_has_ended,
                gravity: Toast.center,
                duration: Toast.lengthLong,
              );
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FlashDealProducts(
                  flash_deal_id: flashDealResponse.flashDeals![index].id,
                  flash_deal_name: flashDealResponse.flashDeals![index].title,
                  bannerUrl: flashDealResponse.flashDeals![index].banner,
                  countdownTimerController: _timerControllerList[index],
                );
              }));
            }
          },
          child: Container(
            width: DeviceInfo(context).width,
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecorations.buildBoxDecoration_1(),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              buildFlashDealBanner(flashDealResponse, index),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      width: 210.w,
                                      child: Text(
                                        flashDealResponse
                                                .flashDeals![index].title ??
                                            "",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.sp,
                                            color: MyTheme.golden),
                                      ),
                                    ),
                                  ),
                                  time == null
                                      ? Text(
                                          AppLocalizations.of(context)!
                                              .ended_ucf,
                                          style: TextStyle(
                                              color: MyTheme.accent_color,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : buildTimerRowRow(time),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: List.generate(
                              flashDealResponse.flashDeals![index].products
                                      ?.products?.length ??
                                  6,
                              (productIndex) => InkWell(
                                    onTap: () {
                                      Get.to(() => ProductDetails(
                                            id: flashDealResponse
                                                .flashDeals![index]
                                                .products!
                                                .products![index]
                                                .id,
                                          ));
                                    },
                                    child: buildFlashDealsProductItem(
                                        flashDealResponse, index, productIndex),
                                  )),
                        ),
                      ),
                    )
                  ],
                ),
                // Positioned.fill(
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: Padding(
                //       padding: const EdgeInsets.all(10),
                //       child: InkWell(
                //         onTap: () {},
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment:
                //           MainAxisAlignment.end,
                //           children: [
                //             Text(
                //               AppLocalizations.of(context)!
                //                   .view_more_ucf,
                //               style: const TextStyle(
                //                   fontSize: 10,
                //                   color: MyTheme.grey_153),
                //             ),
                //             const SizedBox(
                //               width: 3,
                //             ),
                //             //Image.asset("assets/arrow.png",height: 10,color: MyTheme.grey_153,),
                //             const Icon(
                //               Icons.arrow_forward_outlined,
                //               size: 10,
                //               color: MyTheme.grey_153,
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget buildFlashDealsProductItemShimmer() {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    height: 50,
    width: 136,
    decoration: BoxDecoration(
      color: MyTheme.light_grey,
      borderRadius: BorderRadius.circular(6.0),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: ShimmerHelper().buildBasicShimmerCustomRadius(
            height: 50,
            width: 50,
            radius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ShimmerHelper().buildBasicShimmer(height: 15, width: 60))
      ],
    ),
  );
}

Card buildFlashDealBanner(flashDealResponse, index) {
  return Card(
    elevation: 10,
    child: FadeInImage.assetNetwork(
      placeholder: 'assets/placeholder_rectangle.png',
      image: flashDealResponse.flashDeals[index].banner,
      fit: BoxFit.cover,
      width: 110.w,
      height: 112.h,
    ),
  );
}

Widget buildFlashDealBannerShimmer(BuildContext context) {
  return ShimmerHelper().buildBasicShimmerCustomRadius(
      width: DeviceInfo(context).width,
      height: 180,
      color: MyTheme.medium_grey_50);
}

Widget buildTimerRowRow(CurrentRemainingTime time) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        timerContainer(
          Text(
            timeText(time.days.toString(), default_length: 3),
            style: TextStyle(
                color: MyTheme.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        timerContainer(
          Text(
            timeText(time.hours.toString(), default_length: 2),
            style: TextStyle(
                color: MyTheme.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        timerContainer(
          Text(
            timeText(time.min.toString(), default_length: 2),
            style: TextStyle(
                color: MyTheme.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        timerContainer(
          Text(
            timeText(time.sec.toString(), default_length: 2),
            style: TextStyle(
                color: MyTheme.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        // const SizedBox(
        //   width: 10,
        // ),
        // Image.asset(
        //   "assets/flash_deal.png",
        //   height: 20,
        //   color: MyTheme.golden,
        // ),
        // const Spacer(),
        // InkWell(
        //     onTap: () {},
        //     child: Row(
        //       children: [
        //         Text(
        //           AppLocalizations.of(context)!.view_more_ucf,
        //           style: const TextStyle(fontSize: 10, color: MyTheme.grey_153),
        //         ),
        //         const SizedBox(
        //           width: 3,
        //         ),
        //         //Image.asset("assets/arrow.png",height: 10,color: MyTheme.grey_153,),
        //         const Icon(
        //           Icons.arrow_forward_outlined,
        //           size: 10,
        //           color: MyTheme.grey_153,
        //         )
        //       ],
        //     ))
      ],
    ),
  );
}

String timeText(String txt, {default_length = 3}) {
  var blank_zeros = default_length == 3 ? "000" : "00";
  var leading_zeros = "";
  if (default_length == 3 && txt.length == 1) {
    leading_zeros = "00";
  } else if (default_length == 3 && txt.length == 2) {
    leading_zeros = "0";
  } else if (default_length == 2 && txt.length == 1) {
    leading_zeros = "0";
  }

  var newtxt = (txt == "" || txt == null.toString()) ? blank_zeros : txt;

  // print(txt + " " + default_length.toString());
  // print(newtxt);

  if (default_length > txt.length) {
    newtxt = leading_zeros + newtxt;
  }
  //print(newtxt);

  return newtxt;
}

Widget buildTimerRowRowShimmer(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(
          Icons.watch_later_outlined,
          color: MyTheme.grey_153,
        ),
        const SizedBox(
          width: 10,
        ),
        ShimmerHelper().buildBasicShimmerCustomRadius(
            height: 30,
            width: 30,
            radius: BorderRadius.circular(6),
            color: MyTheme.shimmer_base),
        const SizedBox(
          width: 4,
        ),
        ShimmerHelper().buildBasicShimmerCustomRadius(
            height: 30,
            width: 30,
            radius: BorderRadius.circular(6),
            color: MyTheme.shimmer_base),
        const SizedBox(
          width: 4,
        ),
        ShimmerHelper().buildBasicShimmerCustomRadius(
            height: 30,
            width: 30,
            radius: BorderRadius.circular(6),
            color: MyTheme.shimmer_base),
        const SizedBox(
          width: 4,
        ),
        ShimmerHelper().buildBasicShimmerCustomRadius(
            height: 30,
            width: 30,
            radius: BorderRadius.circular(6),
            color: MyTheme.shimmer_base),
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          "assets/flash_deal.png",
          height: 20,
          color: MyTheme.golden,
        ),
        const Spacer(),
        InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.view_more_ucf,
                  style: TextStyle(fontSize: 10.sp, color: MyTheme.grey_153),
                ),
                const SizedBox(
                  width: 3,
                ),
                //Image.asset("assets/arrow.png",height: 10,color: MyTheme.grey_153,),
                const Icon(
                  Icons.arrow_forward_outlined,
                  size: 10,
                  color: MyTheme.grey_153,
                )
              ],
            ))
      ],
    ),
  );
}

Widget timerContainer(Widget child) {
  return Container(
    constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: MyTheme.accent_color,
    ),
    child: child,
  );
}

Widget buildFlashDealsProductItem(
    flashDealResponse, flashDealIndex, productIndex) {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    height: 140.h,
    width: 131.w,
    decoration: BoxDecoration(
      color: MyTheme.white,
      border: Border.all(color: MyTheme.golden),
      borderRadius: BorderRadius.circular(6.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 110,
          width: 160,
          child: ClipRRect(
            clipBehavior: Clip.none,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            child: FadeInImage(
              placeholder: const AssetImage("assets/placeholder.png"),
              image: NetworkImage(flashDealResponse.flashDeals[flashDealIndex]
                  .products.products[productIndex].image),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5),
          child: Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  flashDealResponse.flashDeals[flashDealIndex].products!
                      .products[productIndex].name,
                  maxLines: 2,
                  // convertPrice(flashDealResponse.flashDeals[flashDealIndex].products!
                  //     .products[productIndex].price),
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: MyTheme.accent_color,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5),
          child: Row(
            children: [
              Text(
                // flashDealResponse.flashDeals[flashDealIndex].products!
                //     .products[productIndex].price,
                convertPrice(flashDealResponse.flashDeals[flashDealIndex]
                    .products!.products[productIndex].price),
                style: TextStyle(
                    fontSize: 10.sp,
                    color: MyTheme.green,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
