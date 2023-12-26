import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import 'package:krishanthmart_new/utils/colors.dart';
import 'package:krishanthmart_new/views/flashdeals/flashdealslist.dart';
import 'package:krishanthmart_new/views/home/components/banner_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:krishanthmart_new/views/mainpage/components/brand_grid.dart';
import 'package:krishanthmart_new/views/product_details/components/product_large_card_list.dart';
import 'package:toast/toast.dart';
import '../../controllers/location_controller.dart';
import '../../models/flash_deal_model.dart';
import '../../repositories/flashdeal_repositories.dart';
import '../../utils/device_info.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/toast_component.dart';
import '../category/category_page.dart';
import '../category/components/category_grid.dart';
import '../flashdeals/flashdealproducts.dart';
import '../mainpage/components/box_decorations.dart';
import '../mainpage/components/custom_appbar.dart';
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
  LocationController locationController = Get.put(LocationController());
  late CarouselController _carouselController;
  late ScrollController _scrollController;

  // late ScrollController bodyScrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ProductRepository().getBestSellingProducts();
    // ProductRepository().getFeaturedProducts();
    _carouselController = CarouselController();
    // bodyScrollController = ScrollController();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          // _textColor = _isSliverAppBarExpanded ? Colors.white : Colors.blue;
        });
      });
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (82.h - kToolbarHeight);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    // bodyScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        shrinkWrap: true,
        semanticChildCount: 1,
        clipBehavior: Clip.none,
        // headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: MyTheme.noColor,
            // forceElevated: innerBoxIsScrolled,
            title: Text(
              'KRISHANTHMART',
              style: TextStyle(
                color: MyTheme.black,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 155.h,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFAE8625),
                    Color(0xFFF7EF8A),
                    Color(0xFFD2AC47),
                  ],
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(31.5.h),
              child: _isSliverAppBarExpanded
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(14.5.h),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Search....',
                            prefixIcon: Icon(
                              Icons.search,
                              color: MyTheme.black,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.keyboard_voice_outlined,
                                color: MyTheme.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Obx(
                            () => InkWell(
                              onTap: () {
                                locationController.getUserLocation();
                              },
                              child: Row(
                                children: [
                                  Text(locationController
                                              .isAddressSelected.value ==
                                          false
                                      ? "Delivery Location"
                                      : locationController
                                          .currentLocation.value),
                                  const Icon(Icons.arrow_drop_down_outlined)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(5.h),
                            child: TextField(
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Search....',
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: MyTheme.black,
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.keyboard_voice_outlined,
                                        color: MyTheme.black,
                                      ))),
                            ),
                          ),
                        ),
                        Container(
                          width: 350.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Free Delivery",
                                    style: TextStyle(
                                        color: const Color(0xFF996515),
                                        fontSize: 21.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    "On order above \u{20B9}99",
                                    style: TextStyle(
                                        color: const Color(0xFF996515),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.sp),
                                  ),
                                ],
                              ),
                              Text(
                                "|",
                                style: TextStyle(
                                    color: const Color(0xFF996515),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Flat \u{20B9}50 off",
                                    style: TextStyle(
                                        color: const Color(0xFF996515),
                                        fontSize: 21.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    "Above \u{20B9}199 | Code: BLINK50",
                                    style: TextStyle(
                                        color: const Color(0xFF996515),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.sp),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          // },
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      // padding: EdgeInsets.only(top: 0),
                      clipBehavior: Clip.none,
                      semanticChildCount: 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          // physics: const NeverScrollableScrollPhysics(),
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // shrinkWrap: true,
                          children: [
                            const CustomCarousel(),
                            SizedBox(
                              height: 26.h,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .shop_by_category,
                                      style: TextStyle(
                                          color: MyTheme.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold),
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
                                        Get.to(() => CategoryListPages());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              // width: DeviceInfo(context).width,
                              // margin: EdgeInsets.symmetric(horizontal: 6.w),
                              height: 216.h,
                              child: CategoryGridView(
                                  homeController.featuredCategoryList),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              width: DeviceInfo(context).width,
                              color: MyTheme.indigo,
                              child: Text(
                                AppLocalizations.of(context)!.highlight_ucf,
                                style: TextStyle(
                                    color: MyTheme.PrimaryColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              color: MyTheme.indigo,
                              width: DeviceInfo(context).width,
                              height: 324.h,
                              child: Obx(
                                () => ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: homeController
                                        .bannerTwoImageList.length,
                                    itemBuilder: (context, index) {
                                      String imageUrl = homeController
                                          .bannerTwoImageList[index];
                                      if (homeController
                                          .bannerTwoImageList.isEmpty) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return BannersHomeList(
                                            imageUrl: imageUrl);
                                      }
                                    }),
                              ),
                            ),
                            Container(
                              color: MyTheme.light_pink,
                              width: DeviceInfo(context).width,
                              height: 337.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .baskets_must_have,
                                          style: TextStyle(
                                              color: MyTheme.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .view_more_ucf,
                                            style: TextStyle(
                                                color: MyTheme.black,
                                                fontSize: 14.sp),
                                          ),
                                          onTap: () {},
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 4.w, right: 4.w, top: 4.h),
                                    width: DeviceInfo(context).width,
                                    height: 315.h,
                                    child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                      ),
                                      itemCount: 4,
                                      itemBuilder: (context, index) {
                                        if (homeController
                                            .flashDealList.isEmpty) {
                                          return ShimmerHelper()
                                              .buildProductGridShimmer();
                                        } else {
                                          return Obx(
                                            () => InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        homeController
                                                            .flashDealList[
                                                                index]
                                                            .banner!),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
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
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 4.w, right: 4.w, top: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .todays_deal_ucf,
                                    style: TextStyle(
                                        color: MyTheme.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .view_more_ucf,
                                      style: TextStyle(
                                          color: MyTheme.black,
                                          fontSize: 14.sp),
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: DeviceInfo(context).width,
                              height: 385.h,
                              child: Column(
                                children: [
                                  Obx(
                                    () => CarouselSlider.builder(
                                      carouselController: _carouselController,
                                      itemCount:
                                          homeController.todayDealList.length,
                                      options: CarouselOptions(
                                        height: 297.h,
                                        autoPlay: true,
                                        aspectRatio: 2.0,
                                        viewportFraction: 1,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 1000),
                                        autoPlayCurve: Curves.slowMiddle,
                                        onPageChanged: (index, reason) {
                                          homeController.dealIndex.value =
                                              index;
                                        },
                                      ),
                                      itemBuilder: (BuildContext context,
                                          int index, int realIndex) {
                                        return Obx(
                                          () => CarouselDealCard(
                                            product: homeController
                                                .todayDealList[index],
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
                                                                .dealIndex
                                                                .value ==
                                                            index
                                                        ? MyTheme.green
                                                        : MyTheme.white,
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
                            Container(
                              color: MyTheme.amber_medium,
                              width: DeviceInfo(context).width,
                              height: 150.h,
                              child: Container(
                                height: 150.h,
                                width: DeviceInfo(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                      image: AssetImage("assets/halfprice.jpg"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Container(
                              color: MyTheme.amber_medium,
                              width: DeviceInfo(context).width,
                              height: 150.h,
                              child: Container(
                                height: 150.h,
                                width: DeviceInfo(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/baskets_have.jpg"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Container(
                              color: MyTheme.golden,
                              width: DeviceInfo(context).width,
                              height: 255.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .best_selling_ucf,
                                          style: TextStyle(
                                              color: MyTheme.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .view_more_ucf,
                                            style: TextStyle(
                                                color: MyTheme.white,
                                                fontSize: 14.sp),
                                          ),
                                          onTap: () {},
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
                                            itemCount: homeController
                                                .bestSellingProductList.length,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
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
                                      )),
                                ],
                              ),
                            ),
                            Container(
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
                                            fontWeight: FontWeight.bold)),
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
                            ),
                            buildFlashDealList(context),
                            Container(
                                color: MyTheme.PrimaryLightColor,
                                width: DeviceInfo(context).width,
                                height: 150.h,
                                child: Container(
                                  height: 150.h,
                                  width: DeviceInfo(context).width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: const DecorationImage(
                                        image: NetworkImage(
                                            "https://krishanthmart.com/public/uploads/all/E05zNYsRkZTDQwv3YGJvwQe05kY3MoqWKIrxkxFZ.jpg"),
                                        fit: BoxFit.fill),
                                  ),
                                )),
                            Container(
                              height: 221.h,
                              width: DeviceInfo(context).width,
                              color: MyTheme.gigas,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 4.w, right: 4.w, top: 1.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .best_deals,
                                          style: TextStyle(
                                              color: MyTheme.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .view_more_ucf,
                                            style: TextStyle(
                                                color: MyTheme.white,
                                                fontSize: 14.sp),
                                          ),
                                          onTap: () {},
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
                            Container(
                              color: MyTheme.white,
                              width: DeviceInfo(context).width,
                              height: 348.h,
                              child: const BrandCategoryView(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    "Offer Zone",
                                    style: TextStyle(
                                        color: MyTheme.dark_purple,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: MyTheme.shimmer_highlighted,
                              width: DeviceInfo(context).width,
                              height: 100.h,
                              child: Container(
                                margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                                width: DeviceInfo(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/offerzone1.jpg"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Container(
                              color: MyTheme.shimmer_highlighted,
                              width: DeviceInfo(context).width,
                              height: 100.h,
                              child: Container(
                                margin: EdgeInsets.only(top: 5.h, bottom: 2.h),
                                width: DeviceInfo(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/offerzone2.jpg"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Container(
                              color: MyTheme.shimmer_highlighted,
                              width: DeviceInfo(context).width,
                              height: 100.h,
                              child: Container(
                                margin: EdgeInsets.only(top: 5.h),
                                width: DeviceInfo(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/offerzone3.jpg"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Container(
                              color: MyTheme.dark_purple,
                              width: DeviceInfo(context).width,
                              height: 255.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .featured_products_ucf,
                                            style: TextStyle(
                                                color: MyTheme.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold)),
                                        InkWell(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .view_more_ucf,
                                            style: TextStyle(
                                                color: MyTheme.white,
                                                fontSize: 14.sp),
                                          ),
                                          onTap: () {},
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
                                            itemCount: homeController
                                                .featuredProductList.length,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: ProductCard(
                                                    product: homeController
                                                            .featuredProductList[
                                                        index],
                                                    onTap: () {},
                                                    itemIndex: index,
                                                  ));
                                            },
                                          );
                                        },
                                      )),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   appBar: CustomAppBar(),
    //   // drawer: CustomDrawer(),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       // crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         const CustomCarousel(),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Padding(
    //               padding: EdgeInsets.only(left: 10.w),
    //               child: Text(
    //                 AppLocalizations.of(context)!.shop_by_category,
    //                 style: TextStyle(
    //                     color: MyTheme.black,
    //                     fontSize: 16.sp,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             TextButton(
    //                 onPressed: () {
    //                   Get.to(() => CategoryListPages());
    //                 },
    //                 child: Text(
    //                   AppLocalizations.of(context)!.view_more_ucf,
    //                   style: TextStyle(color: MyTheme.black, fontSize: 14.sp),
    //                 ))
    //           ],
    //         ),
    //         Container(
    //           color: MyTheme.PrimaryLightColor,
    //           width: DeviceInfo(context).width,
    //           height: 216.h,
    //           child: Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 5, horizontal: 8.1),
    //             child: CategoryGridView(homeController.featuredCategoryList),
    //           ),
    //         ),
    //         Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 9),
    //             width: DeviceInfo(context).width,
    //             color: MyTheme.indigo,
    //             child: Text(
    //               AppLocalizations.of(context)!.highlight_ucf,
    //               style: TextStyle(
    //                   color: MyTheme.PrimaryColor,
    //                   fontSize: 16.sp,
    //                   fontWeight: FontWeight.bold),
    //             )),
    //         Container(
    //           color: MyTheme.indigo,
    //           width: DeviceInfo(context).width,
    //           height: 276.h,
    //           child: Obx(
    //             () => ListView.builder(
    //                 shrinkWrap: true,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 itemCount: homeController.bannerTwoImageList.length,
    //                 itemBuilder: (context, index) {
    //                   String imageUrl =
    //                       homeController.bannerTwoImageList[index];
    //                   if (homeController.bannerTwoImageList.isEmpty) {
    //                     return const Center(child: CircularProgressIndicator());
    //                   } else {
    //                     return BannersHomeList(imageUrl: imageUrl);
    //                   }
    //                 }),
    //           ),
    //         ),
    //         Container(
    //           color: MyTheme.pale,
    //           width: DeviceInfo(context).width,
    //           height: 120.h,
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 8.w),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       AppLocalizations.of(context)!.baskets_must_have,
    //                       style: TextStyle(
    //                           color: MyTheme.black,
    //                           fontSize: 16.sp,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                     TextButton(
    //                         onPressed: () {},
    //                         child: Text(
    //                           AppLocalizations.of(context)!.view_more_ucf,
    //                           style: TextStyle(
    //                               color: MyTheme.black, fontSize: 14.sp),
    //                         ))
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: DeviceInfo(context).width,
    //                 height: 79.h,
    //                 child: Obx(
    //                   () => ListView.builder(
    //                       shrinkWrap: true,
    //                       physics: const BouncingScrollPhysics(),
    //                       scrollDirection: Axis.horizontal,
    //                       itemCount: homeController.flashDealList.length,
    //                       itemBuilder: (context, index) {
    //                         if (homeController.flashDealList.isEmpty) {
    //                           return const Center(
    //                               child: CircularProgressIndicator());
    //                         } else {
    //                           return Card(
    //                             elevation: 20,
    //                             child: Image.network(
    //                               homeController.flashDealList[index].banner!,
    //                             ),
    //                           );
    //                         }
    //                       }),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Padding(
    //               padding: EdgeInsets.only(left: 10.w),
    //               child: Text(
    //                 AppLocalizations.of(context)!.todays_deal_ucf,
    //                 style: TextStyle(
    //                     color: MyTheme.black,
    //                     fontSize: 16.sp,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             TextButton(
    //                 onPressed: () {},
    //                 child: Text(
    //                   AppLocalizations.of(context)!.view_more_ucf,
    //                   style: TextStyle(color: MyTheme.black, fontSize: 14.sp),
    //                 ))
    //           ],
    //         ),
    //         SizedBox(
    //           width: DeviceInfo(context).width,
    //           height: 380.h,
    //           child: Column(
    //             children: [
    //               Obx(
    //                 () => CarouselSlider.builder(
    //                   carouselController: _carouselController,
    //                   itemCount: homeController.todayDealList.length,
    //                   options: CarouselOptions(
    //                     height: 295.h,
    //                     autoPlay: true,
    //                     aspectRatio: 2.0,
    //                     viewportFraction: 1,
    //                     autoPlayInterval: const Duration(seconds: 3),
    //                     autoPlayAnimationDuration:
    //                         const Duration(milliseconds: 1000),
    //                     autoPlayCurve: Curves.slowMiddle,
    //                     onPageChanged: (index, reason) {
    //                       homeController.dealIndex.value = index;
    //                     },
    //                   ),
    //                   itemBuilder:
    //                       (BuildContext context, int index, int realIndex) {
    //                     return Obx(
    //                       () => CarouselDealCard(
    //                         product: homeController.todayDealList[index],
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 84.h,
    //                 child: Obx(
    //                   () => ListView.builder(
    //                     shrinkWrap: true,
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: homeController.todayDealList.length,
    //                     itemBuilder: (context, index) {
    //                       return Obx(
    //                         () => InkWell(
    //                           child: Container(
    //                             height: 80.h,
    //                             width: 80.h,
    //                             margin:
    //                                 const EdgeInsets.symmetric(horizontal: 8),
    //                             decoration: BoxDecoration(
    //                               border: Border.all(
    //                                 color:
    //                                     homeController.dealIndex.value == index
    //                                         ? MyTheme.green
    //                                         : MyTheme.white,
    //                               ),
    //                               borderRadius: BorderRadius.circular(10),
    //                               image: DecorationImage(
    //                                 image: NetworkImage(
    //                                   homeController.todayDealList[index]
    //                                       .thumbnail_image!,
    //                                 ),
    //                                 fit: BoxFit.fill,
    //                               ),
    //                             ),
    //                           ),
    //                           onTap: () {
    //                             // homeController.dealIndex.value = index;
    //                             _carouselController.jumpToPage(index);
    //                           },
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 0.5.h,
    //         ),
    //         Container(
    //           color: MyTheme.amber_medium,
    //           width: DeviceInfo(context).width,
    //           height: 100.h,
    //           child: Container(
    //             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //             height: 100.h,
    //             width: DeviceInfo(context).width,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //               image: const DecorationImage(
    //                   image: AssetImage("assets/baskets_have.jpg"),
    //                   fit: BoxFit.fill),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           color: MyTheme.golden,
    //           width: DeviceInfo(context).width,
    //           height: 255.h,
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 8.w),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       AppLocalizations.of(context)!.best_selling_ucf,
    //                       style: TextStyle(
    //                           color: MyTheme.white,
    //                           fontSize: 16.sp,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                     TextButton(
    //                       onPressed: () {},
    //                       child: Text(
    //                         AppLocalizations.of(context)!.view_more_ucf,
    //                         style: TextStyle(
    //                             color: MyTheme.white, fontSize: 14.sp),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                   height: 210.h,
    //                   child: GetBuilder<HomeController>(
    //                     builder: (homeController) {
    //                       return ListView.builder(
    //                         shrinkWrap: true,
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount:
    //                             homeController.bestSellingProductList.length,
    //                         physics: const BouncingScrollPhysics(),
    //                         itemBuilder: (context, index) {
    //                           return Container(
    //                               margin:
    //                                   const EdgeInsets.symmetric(horizontal: 5),
    //                               child: ProductCard(
    //                                 product: homeController
    //                                     .bestSellingProductList[index],
    //                                 onTap: () {},
    //                               ));
    //                         },
    //                       );
    //                     },
    //                   )),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           color: MyTheme.amber_medium,
    //           width: DeviceInfo(context).width,
    //           height: 100.h,
    //           child: Container(
    //             margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
    //             height: 100.h,
    //             width: DeviceInfo(context).width,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //               image: const DecorationImage(
    //                   image: AssetImage("assets/halfprice.jpg"),
    //                   fit: BoxFit.fill),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           width: DeviceInfo(context).width,
    //           color: MyTheme.white,
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 10.w),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(AppLocalizations.of(context)!.flash_deal_ucf,
    //                     style: TextStyle(
    //                         color: MyTheme.black,
    //                         fontSize: 16.sp,
    //                         fontWeight: FontWeight.bold)),
    //                 TextButton(
    //                     onPressed: () {
    //                       Get.to(const FlashDealList());
    //                     },
    //                     child: Text(AppLocalizations.of(context)!.view_more_ucf,
    //                         style: TextStyle(
    //                             color: MyTheme.black, fontSize: 14.sp)))
    //               ],
    //             ),
    //           ),
    //         ),
    //         buildFlashDealList(context),
    //         Container(
    //             color: MyTheme.PrimaryLightColor,
    //             width: DeviceInfo(context).width,
    //             height: 100.h,
    //             child: Container(
    //               margin:
    //                   const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //               height: 100.h,
    //               width: DeviceInfo(context).width,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(5),
    //                 image: const DecorationImage(
    //                     image: NetworkImage(
    //                         "https://krishanthmart.com/public/uploads/all/E05zNYsRkZTDQwv3YGJvwQe05kY3MoqWKIrxkxFZ.jpg"),
    //                     fit: BoxFit.fill),
    //               ),
    //             )),
    //         Container(
    //           height: 230.h,
    //           width: DeviceInfo(context).width,
    //           color: MyTheme.gigas,
    //           child: Column(
    //             children: [
    //               Expanded(
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 8),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         AppLocalizations.of(context)!.best_deals,
    //                         style: TextStyle(
    //                             color: MyTheme.white,
    //                             fontSize: 16.sp,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       TextButton(
    //                         onPressed: () {},
    //                         child: Text(
    //                           AppLocalizations.of(context)!.view_more_ucf,
    //                           style: TextStyle(
    //                               color: MyTheme.white, fontSize: 14.sp),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 202.h,
    //                 child: GetBuilder<HomeController>(
    //                   builder: (homeController) {
    //                     return ProductLargeCardList(
    //                         productList: homeController.todayDealList,
    //                         onTap: () {});
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           color: MyTheme.white,
    //           width: DeviceInfo(context).width,
    //           height: 370.h,
    //           child: const Padding(
    //             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8.1),
    //             child: BrandCategoryView(),
    //           ),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               "Offer Zone",
    //               style: TextStyle(
    //                   color: MyTheme.dark_purple,
    //                   fontSize: 16.sp,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //           ],
    //         ),
    //         Container(
    //           color: MyTheme.shimmer_highlighted,
    //           width: DeviceInfo(context).width,
    //           height: 100.h,
    //           child: Container(
    //             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //             width: DeviceInfo(context).width,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //               image: const DecorationImage(
    //                   image: AssetImage("assets/offerzone1.jpg"),
    //                   fit: BoxFit.fill),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           color: MyTheme.shimmer_highlighted,
    //           width: DeviceInfo(context).width,
    //           height: 100.h,
    //           child: Container(
    //             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //             width: DeviceInfo(context).width,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //               image: const DecorationImage(
    //                   image: AssetImage("assets/offerzone2.jpg"),
    //                   fit: BoxFit.fill),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           color: MyTheme.shimmer_highlighted,
    //           width: DeviceInfo(context).width,
    //           height: 100.h,
    //           child: Container(
    //             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //             width: DeviceInfo(context).width,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //               image: const DecorationImage(
    //                   image: AssetImage("assets/offerzone3.jpg"),
    //                   fit: BoxFit.fill),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           color: MyTheme.dark_purple,
    //           width: DeviceInfo(context).width,
    //           height: 255.h,
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 8),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                         AppLocalizations.of(context)!.featured_products_ucf,
    //                         style: TextStyle(
    //                             color: MyTheme.white,
    //                             fontSize: 16.sp,
    //                             fontWeight: FontWeight.bold)),
    //                     TextButton(
    //                         onPressed: () {},
    //                         child: Text(
    //                             AppLocalizations.of(context)!.view_more_ucf,
    //                             style: TextStyle(
    //                                 color: MyTheme.white, fontSize: 14.sp)))
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                   height: 210.h,
    //                   child: GetBuilder<HomeController>(
    //                     builder: (homeController) {
    //                       return ListView.builder(
    //                         shrinkWrap: true,
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount:
    //                             homeController.featuredProductList.length,
    //                         physics: const BouncingScrollPhysics(),
    //                         itemBuilder: (context, index) {
    //                           return Container(
    //                               margin:
    //                                   const EdgeInsets.symmetric(horizontal: 5),
    //                               child: ProductCard(
    //                                 product: homeController
    //                                     .featuredProductList[index],
    //                                 onTap: () {},
    //                               ));
    //                         },
    //                       );
    //                     },
    //                   )),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

Widget buildFlashDealList(context) {
  return FutureBuilder<FlashDealResponse>(
      future: FlashDealRepository().getFlashDeals(),
      builder: (context, AsyncSnapshot<FlashDealResponse> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Network Error!"),
          );
        } else if (snapshot.hasData) {
          FlashDealResponse flashDealResponse = snapshot.data!;
          return buildFlashDealListItem(flashDealResponse, 1, context);
          // return ListView.builder(
          //   itemCount: 1,
          //   scrollDirection: Axis.vertical,
          //   physics: const NeverScrollableScrollPhysics(),
          //   shrinkWrap: true,
          //   itemBuilder: (context, index) {
          //     return buildFlashDealListItem(
          //         flashDealResponse, index, context);
          //   },
          // );
        } else {
          // return buildShimmer();
          return const SizedBox();
        }
      });
}

CustomScrollView buildShimmer() {
  return CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 0,
            );
          },
          itemCount: 20,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildFlashDealListItemShimmer(context);
          },
        ),
      )
    ],
  );
}

buildFlashDealListItemShimmer(BuildContext context) {
  return SizedBox(
    // color: MyTheme.amber,
    height: 340.h,
    child: Stack(
      children: [
        buildFlashDealBannerShimmer(context),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: DeviceInfo(context).width,
            height: 196.h,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecorations.buildBoxDecoration_1(),
            child: Column(
              children: [
                Container(
                  child: buildTimerRowRowShimmer(context),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: 460.h,
                    child: Wrap(
                      //spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.start,
                      children: List.generate(6, (productIndex) {
                        return buildFlashDealsProductItemShimmer();
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
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
                              (productIndex) => buildFlashDealsProductItem(
                                  flashDealResponse, index, productIndex)),
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
  if (txt != null) {
    if (default_length == 3 && txt.length == 1) {
      leading_zeros = "00";
    } else if (default_length == 3 && txt.length == 2) {
      leading_zeros = "0";
    } else if (default_length == 2 && txt.length == 1) {
      leading_zeros = "0";
    }
  }

  var newtxt =
      (txt == null || txt == "" || txt == null.toString()) ? blank_zeros : txt;

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
  return Card(
    child: Container(
      margin: const EdgeInsets.only(left: 10),
      height: 165,
      width: 140,
      decoration: BoxDecoration(
        color: MyTheme.white,
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
                    // convertPrice(flashDealResponse.flashDeals[flashDealIndex].products!
                    //     .products[productIndex].price),
                    style: TextStyle(
                        fontSize: 12.sp,
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
                  flashDealResponse.flashDeals[flashDealIndex].products!
                      .products[productIndex].price,
                  // convertPrice(flashDealResponse.flashDeals[flashDealIndex].products!
                  //     .products[productIndex].price),
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: MyTheme.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
