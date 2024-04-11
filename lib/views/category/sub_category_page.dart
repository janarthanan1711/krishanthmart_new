import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/sub_category_controller.dart';
import 'package:krishanthmart_new/utils/device_info.dart';
import '../../controllers/cart_controller.dart';
import '../../utils/colors.dart';
import '../../utils/image_directory.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../cart/cart_page.dart';
import 'components/products_category_card.dart';
import 'package:badges/badges.dart' as badges;

class SubCategoryPage extends StatefulWidget {
  SubCategoryPage({
    super.key,
    this.categoryName,
    this.categoryId,
    this.subCategoryId,
    this.selectedIndexes,
    this.from_banner = false,
  });

  String? categoryName;
  int? categoryId;
  int? subCategoryId;
  int? selectedIndexes;
  bool from_banner;

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  final SubCategoryController subCategoryController =
      Get.put(SubCategoryController());
  ScrollController scrollController = ScrollController();
  final ScrollController xcrollController = ScrollController();
  final ScrollController ycrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  GlobalKey _itemKey = GlobalKey();

  late CarouselController carouselController;

  int page = 1;
  int pageSub = 1;
  String searchKey = "";
  int _selectedIndex = 0;

  // int? selectedIndex;

  // bool showLoadingContainer = false;
  bool showSearchBar = false;

  @override
  void initState() {
    // carouselController = CarouselController();
    getAll();
    // _selectedIndex = widget.selectedIndexes ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carouselController =
          CarouselController(); // Initialize the carousel controller
      // _selectedIndex = widget.selectedIndexes ?? 0;
      carouselController.jumpToPage(
        widget.selectedIndexes ?? 0,
      );
    });
    allProductsScroll();
    categoryProductsScroll();

    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      clearAll();
      scrollController.dispose();
      searchController.dispose();
      ycrollController.dispose();
      xcrollController.dispose();
      super.dispose();
    }
  }

  Future<void> _onRefresh() async {
    clearAll();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    // subCategoryController.selectedIndex.value = widget.categoryId!;
    return Scaffold(
      appBar: AppBar(
        title: buildAppBarTitle(context),
        backgroundColor: MyTheme.shimmer_base,
        foregroundColor: MyTheme.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        bottom: widget.from_banner == false
            ? PreferredSize(
                preferredSize: const Size.fromHeight(45.0),
                child: Row(
                  children: [
                    SizedBox(
                      // width: 350.w,
                      height: 45,
                      width: Get.width,
                      // key: _itemKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Container(
                          width: Get.width,
                          child: Obx(
                            () => CarouselSlider.builder(
                              options: CarouselOptions(
                                // You can customize carousel options here
                                // aspectRatio: 16 / 9,
                                // viewportFraction: 0.8,
                                initialPage: widget.selectedIndexes!,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    // widget.selectedIndexes = index;
                                    index = widget.selectedIndexes!;
                                    print(
                                        "selected Index=======>${widget.selectedIndexes!} ${index}");
                                  });
                                },
                              ),
                              carouselController: carouselController,
                              itemCount:
                                  subCategoryController.subCategoryList.length,
                              itemBuilder: (BuildContext context, int index,
                                  int realIndex) {
                                GlobalKey itemKey = GlobalKey();
                                return InkWell(
                                  key: itemKey,
                                  onTap: () async {
                                    subCategoryController
                                        .showAllProducts.value = true;
                                    setState(() {
                                      page = 1;
                                    });
                                    widget.subCategoryId = subCategoryController
                                        .subCategoryList[index].id;
                                    subCategoryController
                                            .subCategoryIndex.value =
                                        subCategoryController
                                            .selectedIndex.value;
                                    await subCategoryController
                                        .getSubChildCategories(
                                            subCategoryController
                                                .subCategoryList[index].id!);
                                    await subCategoryController
                                        .getAllCategoryProducts(
                                      categoryId: subCategoryController
                                          .subCategoryList[index].id,
                                      page: page,
                                      searchKey: searchKey,
                                      index: index,
                                    );
                                  },
                                  child: Container(
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                      color: widget.subCategoryId ==
                                              subCategoryController
                                                  .subCategoryList[index].id
                                          ? Colors.green
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: widget.subCategoryId ==
                                                subCategoryController
                                                    .subCategoryList[index].id
                                            ? Colors.black
                                            : MyTheme.green,
                                      ),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Center(
                                      child: Text(
                                        subCategoryController
                                            .subCategoryList[index].name!,
                                        style: TextStyle(
                                          color: widget.subCategoryId ==
                                                  subCategoryController
                                                      .subCategoryList[index].id
                                              ? Colors.black
                                              : MyTheme.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : PreferredSize(
                child: SizedBox(),
                preferredSize: const Size.fromHeight(0.0),
              ),
      ),
      body: Column(
        children: [
          widget.from_banner == false
              ? GetBuilder<SubCategoryController>(
                  builder: (subCategoryController) {
                  return Container(
                    width: DeviceInfo(context).width!,
                    color: MyTheme.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Obx(
                            () => InkWell(
                              child: Container(
                                height: 35.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: subCategoryController
                                              .showAllProducts.value ==
                                          true
                                      ? Colors.green
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: subCategoryController
                                                  .showAllProducts.value ==
                                              true
                                          ? Colors.black
                                          : MyTheme.green),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    "All",
                                    style: TextStyle(
                                        color: subCategoryController
                                                    .showAllProducts.value ==
                                                true
                                            ? Colors.black
                                            : MyTheme.green),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                try {
                                  subCategoryController.showAllProducts.value =
                                      true;
                                  subCategoryController.isLoading.value = true;
                                  setState(() {
                                    page = 1;
                                  });
                                  // print(
                                  //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
                                  // print(
                                  //     "All Part set index ${subCategoryController.subCategoryIndex.value}");
                                  // await subCategoryController.getCategoryProducts(
                                  //     categoryId: subCategoryController
                                  //         .allCategoryProductList[subCategoryController.subCategoryIndex.value].id,
                                  //     page: page,
                                  //     searchKey: searchKey);
                                  // subCategoryController.categoryProductList.clear();

                                  //hERE ASSIGNED THE SUBCATEGORY INDEX VALUE TO FETCH ALL PRODUCTS
                                  await subCategoryController
                                      .getAllCategoryProducts(
                                          categoryId: subCategoryController
                                              .subCategoryList[
                                                  widget.selectedIndexes!]
                                              .id,
                                          page: page,
                                          searchKey: searchKey,
                                          index: subCategoryController
                                              .subCategoryIndex.value);
                                  // await subCategoryController
                                  //     .getAllCategoryProducts(
                                  //         categoryId: subCategoryController
                                  //             .subCategoryList[
                                  //                 subCategoryController
                                  //                     .subCategoryIndex.value]
                                  //             .id,
                                  //         page: page,
                                  //         searchKey: searchKey,
                                  //         index: subCategoryController
                                  //             .subCategoryIndex.value);
                                  // subCategoryController.categoryProductId.value =
                                  //     subCategoryController
                                  //         .subCategoryList[subCategoryController
                                  //             .subCategoryIndex.value]
                                  //         .id;
                                  // print(
                                  //     "All Part set index ${subCategoryController.subCategoryIndex.value}");
                                  //
                                  // print(
                                  //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
                                } catch (e) {
                                  // Handle errors (e.g., show an error message)
                                  debugPrint("Error fetching products: $e");
                                } finally {
                                  subCategoryController.isLoading.value = false;
                                }
                              },
                            ),
                          ),
                          Row(
                            children: List.generate(
                              subCategoryController.subChildCategories.length,
                              growable: true,
                              (index) => Obx(
                                () => InkWell(
                                  child: Container(
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: subCategoryController
                                                        .subSelectedIndex
                                                        .value ==
                                                    index &&
                                                subCategoryController
                                                        .showAllProducts
                                                        .value ==
                                                    false
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: subCategoryController
                                                            .subSelectedIndex
                                                            .value ==
                                                        index &&
                                                    subCategoryController
                                                            .showAllProducts
                                                            .value ==
                                                        false
                                                ? Colors.black
                                                : MyTheme.green)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Center(
                                      child: Text(
                                        subCategoryController
                                            .subChildCategories[index].name!,
                                        style: TextStyle(
                                            color: subCategoryController
                                                            .subSelectedIndex
                                                            .value ==
                                                        index &&
                                                    subCategoryController
                                                            .showAllProducts
                                                            .value ==
                                                        false
                                                ? Colors.black
                                                : MyTheme.green),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      pageSub = 1;
                                    });
                                    // print("Calling");
                                    subCategoryController
                                        .showAllProducts.value = false;
                                    subCategoryController
                                        .subSelectedIndex.value = index;
                                    subCategoryController.isInitial.value =
                                        true;
                                    subCategoryController
                                            .subChildCategoryId.value =
                                        subCategoryController
                                            .subChildCategories[index].id!;
                                    print(
                                        "Show All Products========>${subCategoryController.showAllProducts.value}");
                                    print(
                                        "Show selected ID==========>${subCategoryController.subChildCategoryId.value} ${subCategoryController.subChildCategories[index].id!}");
                                    // subCategoryController.categoryProductList.clear();
                                    // subCategoryController.isLoading.value = true;
                                    // print(
                                    //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
                                    // print(
                                    //     "subChildCategory Value ${subCategoryController.categoryProductList[index].name}");

                                    await subCategoryController
                                        .getCategoryProducts(
                                            categoryId: subCategoryController
                                                .subChildCategories[index].id!,
                                            page: pageSub,
                                            searchKey: searchKey,
                                            index: index);
                                    // print(
                                    //     "Passing Ids =====>${subCategoryController.subChildCategories[index].id}");
                                    // print(
                                    //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
                                    // print(subCategoryController
                                    //     .categoryProductList.isEmpty);
                                    // print(
                                    //     "subChildCategory Value ${subCategoryController.categoryProductList[index].name}");
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
              : SizedBox(),
          Expanded(
            child: Stack(
              children: [
                subCategoryController.showAllProducts.value == true
                    ? buildAllProductList()
                    : buildProductList(),
                // buildProductList(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildLoadingContainer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildProductList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildProductScrollableList(),
          )
        ],
      ),
    );
  }

  Container buildAllProductList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildAllProductScrollableList(),
          )
        ],
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height:
          subCategoryController.showLoadingContainer.value == true ? 10.h : 0,
      width: double.infinity,
      color: MyTheme.white,
      child: Center(
        child:
            // subCategoryController.showAllProducts.value == true
            //     ?
            Text(
          subCategoryController.totalData.value ==
                  subCategoryController.allCategoryProductList.length
              ? AppLocalizations.of(context)!.no_more_products_ucf
              : AppLocalizations.of(context)!.loading_more_products_ucf,
        ),

        // : Obx(
        //     () => Text(
        //       subCategoryController.totalData.value ==
        //               subCategoryController.categoryProductList.length
        //           ? AppLocalizations.of(context)!.no_more_products_ucf
        //           : AppLocalizations.of(context)!.loading_more_products_ucf,
        //     ),
        //   ),
      ),
    );
  }

  buildAllProductScrollableList() {
    return GetBuilder<SubCategoryController>(
      builder: (subCategoryController) {
        return Obx(
          //THERE TWO DIFFERENT LIST ONE IS (ALL) OTHER IS (SUBCHILD) WILL FETCH BASED ON CONDITION
          () {
            if (subCategoryController.isInitial.value &&
                subCategoryController.allCategoryProductList.isEmpty) {
              return SingleChildScrollView(
                child: ShimmerHelper().buildListShimmer(),
              );
            } else if (subCategoryController.allCategoryProductList.length >
                0) {
              return ListView.builder(
                controller: xcrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: subCategoryController.allCategoryProductList.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => ProductCategoryCardLarge(
                        product: subCategoryController
                            .allCategoryProductList[index]),
                  );
                },
              );
            } else if (subCategoryController.totalData.value == 0) {
              return Center(
                child:
                    Text(AppLocalizations.of(context)!.no_product_is_available),
              );
            } else if (page > 1 &&
                subCategoryController.allCategoryProductList.isEmpty &&
                subCategoryController.showAllProducts.value == true) {
              return Center(
                child: Text(AppLocalizations.of(context)!.no_data_is_available),
              );
            } else {
              return SingleChildScrollView(
                  child: ShimmerHelper().buildListShimmer());
            }
          },
        );
      },
    );
  }

  buildProductScrollableList() {
    return GetBuilder<SubCategoryController>(
      builder: (subCategoryController) {
        return Obx(
          //THERE TWO DIFFERENT LIST ONE IS (ALL) OTHER IS (SUBCHILD) WILL FETCH BASED ON CONDITION
          () {
            if (subCategoryController.isInitial.value &&
                subCategoryController.categoryProductList.isEmpty) {
              return SingleChildScrollView(
                child: ShimmerHelper().buildListShimmer(),
              );
            } else if (subCategoryController.categoryProductList.length > 0) {
              return ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: ycrollController,
                shrinkWrap: true,
                itemCount: subCategoryController.categoryProductList.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => ProductCategoryCardLarge(
                      product: subCategoryController.categoryProductList[index],
                    ),
                  );
                },
              );
            } else if (subCategoryController.totalData.value == 0) {
              return Center(
                child:
                    Text(AppLocalizations.of(context)!.no_product_is_available),
              );
            } else if (pageSub > 1 &&
                subCategoryController.categoryProductList.isEmpty &&
                subCategoryController.showAllProducts.value == false) {
              return Center(
                child: Text(AppLocalizations.of(context)!.no_data_is_available),
              );
            } else {
              return SingleChildScrollView(
                  child: ShimmerHelper().buildListShimmer());
            }
          },
        );
      },
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: buildAppBarTitleOption(context),
        secondChild: buildAppBarSearchOption(context),
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
        crossFadeState: showSearchBar
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500));
  }

  Container buildAppBarTitleOption(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                    app_language_rtl.$!
                        ? CupertinoIcons.arrow_right
                        : CupertinoIcons.arrow_left,
                    color: MyTheme.black),
                onPressed: () {
                  // clearAll();
                  Get.back();
                }),
            // child: UsefulElements.backButton(context, color: "white"),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: DeviceInfo(context).width! / 2,
            child: Text(
              widget.categoryName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 20,
            child: IconButton(
                onPressed: () {
                  showSearchBar = true;
                  setState(() {});
                },
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.search,
                  size: 25,
                )),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Get.to(() => CartPage(
                    has_bottomnav: false,
                    from_navigation: false,
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: MyTheme.accent_color,
                    borderRadius: BorderRadius.circular(10),
                    padding: const EdgeInsets.all(5),
                  ),
                  badgeAnimation: const badges.BadgeAnimation.slide(
                    toAnimate: false,
                  ),
                  child: Image.asset(
                    ImageDirectory.cartIconImage,
                    color: MyTheme.black,
                    height: 16,
                  ),
                  badgeContent: GetBuilder<CartController>(
                    builder: (cartController) {
                      return Text(
                        "${cartController.cartCounter}",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Container buildAppBarSearchOption(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      width: DeviceInfo(context).width,
      height: 40,
      child: TextField(
        controller: searchController,
        onTap: () {},
        onChanged: (txt) {
          searchKey = txt;
          clearAll();
          // getAll();
          subCategoryController.getCategoryProducts(
              categoryId: widget.categoryId, page: page, searchKey: searchKey);
        },
        onSubmitted: (txt) {
          searchKey = txt;
          clearAll();
          // getAll();
          subCategoryController.getCategoryProducts(
              categoryId: widget.categoryId,
              page: pageSub,
              searchKey: searchKey);
        },
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              showSearchBar = false;
              setState(() {});
            },
            icon: const Icon(
              Icons.clear,
              color: MyTheme.grey_153,
            ),
          ),
          filled: true,
          fillColor: MyTheme.white.withOpacity(0.6),
          hintText:
              "${AppLocalizations.of(context)!.search_products_from} : ${widget.categoryName!}",
          hintStyle: const TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          contentPadding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  allProductsScroll() {
    xcrollController.addListener(() {
      if (xcrollController.position.pixels ==
          xcrollController.position.maxScrollExtent) {
        // User reached the bottom
        if (subCategoryController.allCategoryProductList.length <
                subCategoryController.totalData.value &&
            page < subCategoryController.lastPageAll.value) {
          setState(() {
            page++;
          });
          subCategoryController.showLoadingContainer.value = true;
          subCategoryController.getAllCategoryProducts(
              categoryId: subCategoryController.allCategoryProductId.value,
              page: page,
              searchKey: searchKey);
        } else if (page > 1) {
          print(
              "Last Page Reached=======>${page}:::${subCategoryController.lastPageAll.value}");
          if (xcrollController.position.pixels ==
              xcrollController.position.minScrollExtent) {
            // User reached the top
            // Check if the list is not empty before decrementing the page count
            setState(() {
              page--;
            });
            // Fetch data based on the updated page value
            subCategoryController.showLoadingContainer.value = true;
            subCategoryController.getAllCategoryProducts(
                categoryId: subCategoryController.allCategoryProductId.value,
                page: page,
                searchKey: searchKey);

            // subCategoryController.showLoadingContainer.value = true;
          }
        }
      } else if (xcrollController.position.pixels ==
          xcrollController.position.minScrollExtent) {
        // User reached the top
        if (page > 1) {
          // Check if the list is not empty before decrementing the page count
          setState(() {
            page--;
          });
          // Fetch data based on the updated page value
          subCategoryController.showLoadingContainer.value = true;
          subCategoryController.getAllCategoryProducts(
              categoryId: subCategoryController.allCategoryProductId.value,
              page: page,
              searchKey: searchKey);

          // subCategoryController.showLoadingContainer.value = true;
        }
      }
    });
  }

  categoryProductsScroll() {
    ycrollController.addListener(() {
      if (ycrollController.position.pixels ==
          ycrollController.position.maxScrollExtent) {
        // User reached the bottom
        if (subCategoryController.categoryProductList.length <
                subCategoryController.totalData.value &&
            pageSub < subCategoryController.lastPage.value) {
          setState(() {
            pageSub++;
          });
          subCategoryController.showLoadingContainer.value = true;
          subCategoryController.getCategoryProducts(
              categoryId: subCategoryController.subChildCategoryId.value,
              page: pageSub,
              searchKey: searchKey);
        }
      } else if (pageSub > 1) {
        print(
            "Last Page Reached=======>${page}:::${subCategoryController.lastPage.value}");
        if (ycrollController.position.pixels ==
            ycrollController.position.minScrollExtent) {
          // User reached the top
          // Check if the list is not empty before decrementing the page count
          setState(() {
            page--;
          });
          // Fetch data based on the updated page value
          subCategoryController.showLoadingContainer.value = true;
          subCategoryController.getCategoryProducts(
              categoryId: subCategoryController.subChildCategoryId.value,
              page: pageSub,
              searchKey: searchKey);

          // subCategoryController.showLoadingContainer.value = true;
        }
      } else if (ycrollController.position.pixels ==
          ycrollController.position.minScrollExtent) {
        // User reached the top
        if (pageSub > 1) {
          // Check if the list is not empty before decrementing the page count
          setState(() {
            pageSub--;
          });
          // Fetch data based on the updated page value
          subCategoryController.getCategoryProducts(
              categoryId: subCategoryController.subChildCategoryId.value,
              page: pageSub,
              searchKey: searchKey);

          // subCategoryController.showLoadingContainer.value = true;
        }
      }
    });
  }

  getAll() {
    setState(() {
      subCategoryController.getMainCategories(widget.categoryId);
      subCategoryController.getAllCategoryProducts(
          categoryId: widget.subCategoryId, page: page, searchKey: searchKey);
      subCategoryController.getCategoryProducts(
          categoryId: widget.subCategoryId,
          page: pageSub,
          searchKey: searchKey);
      subCategoryController.getSubCategory(widget.categoryId!);
      subCategoryController.getSubChildCategories(widget.subCategoryId!);
      subCategoryController.subCategoryIndexSelection(widget.subCategoryId);
      subCategoryController.showAllProducts.value = true;
    });
    // subCategoryIndexSelection();
    // assignSelectedIndexes(index: 0);
  }

  clearAll() {
    subCategoryController.subChildCategories.clear();
    subCategoryController.categoryProductList.clear();
    subCategoryController.subCategoryList.clear();
    subCategoryController.mainCategoryList.clear();
    subCategoryController.allCategoryProductList.clear();
    widget.categoryId = 0;
    widget.categoryName = "";
    widget.subCategoryId = 0;
    widget.selectedIndexes = 0;
    subCategoryController.isInitial.value = true;
    subCategoryController.totalData.value = 0;
    page = 1;
    pageSub = 1;
    searchKey = '';
    subCategoryController.showLoadingContainer.value = false;
    subCategoryController.showAllProducts.value = false;
    subCategoryController.selectedIndex.value = 0;
    subCategoryController.subSelectedIndex.value = 0;
    subCategoryController.subCategoryIndex.value = 0;
    subCategoryController.allCategoryProductId.value = 0;
    subCategoryController.categoryProductId.value = 0;
  }
}

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:krishanthmart_new/controllers/sub_category_controller.dart';
// import 'package:krishanthmart_new/utils/device_info.dart';
// import '../../controllers/cart_controller.dart';
// import '../../utils/colors.dart';
// import '../../utils/image_directory.dart';
// import '../../utils/shared_value.dart';
// import '../../utils/shimmer_utils.dart';
// import '../cart/cart_page.dart';
// import 'components/products_category_card.dart';
// import 'package:badges/badges.dart' as badges;
//
// class SubCategoryPage extends StatefulWidget {
//   SubCategoryPage({
//     super.key,
//     this.categoryName,
//     this.categoryId,
//     this.subCategoryId,
//     this.selectedIndexes,
//     this.from_banner = false,
//   });
//
//   String? categoryName;
//   int? categoryId;
//   int? subCategoryId;
//   int? selectedIndexes;
//   bool from_banner;
//
//   @override
//   State<SubCategoryPage> createState() => _SubCategoryPageState();
// }
//
// class _SubCategoryPageState extends State<SubCategoryPage> {
//   final SubCategoryController subCategoryController =
//       Get.put(SubCategoryController());
//   ScrollController scrollController = ScrollController();
//   final ScrollController xcrollController = ScrollController();
//   final TextEditingController searchController = TextEditingController();
//   GlobalKey _itemKey = GlobalKey();
//
//   late CarouselController carouselController;
//
//   int page = 1;
//   int pageSub = 1;
//   String searchKey = "";
//   int _selectedIndex = 0;
//
//   // int? selectedIndex;
//
//   // bool showLoadingContainer = false;
//   bool showSearchBar = false;
//
//   @override
//   void initState() {
//     // carouselController = CarouselController();
//     getAll();
//     // _selectedIndex = widget.selectedIndexes ?? 0;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       carouselController =
//           CarouselController(); // Initialize the carousel controller
//       // _selectedIndex = widget.selectedIndexes ?? 0;
//       carouselController.jumpToPage(
//         widget.selectedIndexes ?? 0,
//       );
//     });
//     xcrollController.addListener(() {
//       if (xcrollController.position.pixels ==
//           xcrollController.position.maxScrollExtent) {
//         // User reached the bottom
//         setState(() {
//           page++;
//           pageSub++;
//         });
//         // Fetch data based on the updated page value
//         if (subCategoryController.showAllProducts.value == true) {
//           subCategoryController.showLoadingContainer.value = true;
//           subCategoryController.getAllCategoryProducts(
//               categoryId: subCategoryController.allCategoryProductId.value,
//               page: page,
//               searchKey: searchKey);
//         } else if (subCategoryController.showAllProducts.value == false) {
//           subCategoryController.showLoadingContainer.value = true;
//           subCategoryController.getCategoryProducts(
//               categoryId: subCategoryController.subChildCategoryId.value,
//               page: pageSub,
//               searchKey: searchKey);
//         }
//       }
//       else if (xcrollController.position.pixels ==
//           xcrollController.position.minScrollExtent) {
//         // User reached the top
//         if (page > 1) {
//           // Check if the list is not empty before decrementing the page count
//           if (subCategoryController.categoryProductList.isNotEmpty ||
//               subCategoryController.allCategoryProductList.isNotEmpty) {
//             setState(() {
//               page--;
//               pageSub--;
//             });
//             // Fetch data based on the updated page value
//             if (subCategoryController.showAllProducts.value == true) {
//               subCategoryController.getAllCategoryProducts(
//                   categoryId: subCategoryController.allCategoryProductId.value,
//                   page: page,
//                   searchKey: searchKey);
//             } else if (subCategoryController.showAllProducts.value == false) {
//               subCategoryController.getCategoryProducts(
//                   categoryId: subCategoryController.subChildCategoryId.value,
//                   page: pageSub,
//                   searchKey: searchKey);
//             }
//             // subCategoryController.showLoadingContainer.value = true;
//           } else {
//             print("No Product Available");
//           }
//         }
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     if (mounted) {
//       clearAll();
//       scrollController.dispose();
//       searchController.dispose();
//       super.dispose();
//     }
//   }
//
//   Future<void> _onRefresh() async {
//     clearAll();
//     getAll();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // subCategoryController.selectedIndex.value = widget.categoryId!;
//     return Scaffold(
//       appBar: AppBar(
//         title: buildAppBarTitle(context),
//         backgroundColor: MyTheme.shimmer_base,
//         foregroundColor: MyTheme.black,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         bottom: widget.from_banner == false
//             ? PreferredSize(
//                 preferredSize: const Size.fromHeight(45.0),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       // width: 350.w,
//                       height: 45,
//                       width: Get.width,
//                       // key: _itemKey,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 5, horizontal: 5),
//                         child: Container(
//                           width: Get.width,
//                           child: Obx(
//                             () => CarouselSlider.builder(
//                               options: CarouselOptions(
//                                 // You can customize carousel options here
//                                 // aspectRatio: 16 / 9,
//                                 // viewportFraction: 0.8,
//                                 initialPage: widget.selectedIndexes!,
//                                 enableInfiniteScroll: true,
//                                 reverse: false,
//                                 autoPlay: false,
//                                 autoPlayInterval: Duration(seconds: 3),
//                                 autoPlayAnimationDuration:
//                                     Duration(milliseconds: 800),
//                                 autoPlayCurve: Curves.fastOutSlowIn,
//                                 enlargeCenterPage: true,
//                                 scrollDirection: Axis.horizontal,
//                                 onPageChanged: (index, reason) {
//                                   setState(() {
//                                     // widget.selectedIndexes = index;
//                                     index = widget.selectedIndexes!;
//                                     print(
//                                         "selected Index=======>${widget.selectedIndexes!} ${index}");
//                                   });
//                                 },
//                               ),
//                               carouselController: carouselController,
//                               itemCount:
//                                   subCategoryController.subCategoryList.length,
//                               itemBuilder: (BuildContext context, int index,
//                                   int realIndex) {
//                                 GlobalKey itemKey = GlobalKey();
//                                 return InkWell(
//                                   key: itemKey,
//                                   onTap: () async {
//                                     subCategoryController
//                                         .showAllProducts.value = true;
//                                     setState(() {
//                                       page = 1;
//                                     });
//                                     widget.subCategoryId = subCategoryController
//                                         .subCategoryList[index].id;
//                                     subCategoryController
//                                             .subCategoryIndex.value =
//                                         subCategoryController
//                                             .selectedIndex.value;
//                                     await subCategoryController
//                                         .getSubChildCategories(
//                                             subCategoryController
//                                                 .subCategoryList[index].id!);
//                                     await subCategoryController
//                                         .getAllCategoryProducts(
//                                       categoryId: subCategoryController
//                                           .subCategoryList[index].id,
//                                       page: page,
//                                       searchKey: searchKey,
//                                       index: index,
//                                     );
//                                   },
//                                   child: Container(
//                                     height: 35.h,
//                                     decoration: BoxDecoration(
//                                       color: widget.subCategoryId ==
//                                               subCategoryController
//                                                   .subCategoryList[index].id
//                                           ? Colors.green
//                                           : Colors.transparent,
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         color: widget.subCategoryId ==
//                                                 subCategoryController
//                                                     .subCategoryList[index].id
//                                             ? Colors.black
//                                             : MyTheme.green,
//                                       ),
//                                     ),
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10),
//                                     child: Center(
//                                       child: Text(
//                                         subCategoryController
//                                             .subCategoryList[index].name!,
//                                         style: TextStyle(
//                                           color: widget.subCategoryId ==
//                                                   subCategoryController
//                                                       .subCategoryList[index].id
//                                               ? Colors.black
//                                               : MyTheme.green,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : PreferredSize(
//                 child: SizedBox(),
//                 preferredSize: const Size.fromHeight(0.0),
//               ),
//       ),
//       body: Column(
//         children: [
//           widget.from_banner == false
//               ? GetBuilder<SubCategoryController>(
//                   builder: (subCategoryController) {
//                   return Container(
//                     width: DeviceInfo(context).width!,
//                     color: MyTheme.white,
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Obx(
//                             () => InkWell(
//                               child: Container(
//                                 height: 35.h,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: subCategoryController
//                                               .showAllProducts.value ==
//                                           true
//                                       ? Colors.green
//                                       : Colors.transparent,
//                                   border: Border.all(
//                                       color: subCategoryController
//                                                   .showAllProducts.value ==
//                                               true
//                                           ? Colors.black
//                                           : MyTheme.green),
//                                 ),
//                                 margin:
//                                     const EdgeInsets.symmetric(horizontal: 5),
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 child: Center(
//                                   child: Text(
//                                     "All",
//                                     style: TextStyle(
//                                         color: subCategoryController
//                                                     .showAllProducts.value ==
//                                                 true
//                                             ? Colors.black
//                                             : MyTheme.green),
//                                   ),
//                                 ),
//                               ),
//                               onTap: () async {
//                                 try {
//                                   subCategoryController.showAllProducts.value =
//                                       true;
//                                   subCategoryController.isLoading.value = true;
//                                   setState(() {
//                                     page = 1;
//                                   });
//                                   // print(
//                                   //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
//                                   // print(
//                                   //     "All Part set index ${subCategoryController.subCategoryIndex.value}");
//                                   // await subCategoryController.getCategoryProducts(
//                                   //     categoryId: subCategoryController
//                                   //         .allCategoryProductList[subCategoryController.subCategoryIndex.value].id,
//                                   //     page: page,
//                                   //     searchKey: searchKey);
//                                   // subCategoryController.categoryProductList.clear();
//
//                                   //hERE ASSIGNED THE SUBCATEGORY INDEX VALUE TO FETCH ALL PRODUCTS
//                                   await subCategoryController
//                                       .getAllCategoryProducts(
//                                           categoryId: subCategoryController
//                                               .subCategoryList[
//                                                   widget.selectedIndexes!]
//                                               .id,
//                                           page: page,
//                                           searchKey: searchKey,
//                                           index: subCategoryController
//                                               .subCategoryIndex.value);
//                                   // await subCategoryController
//                                   //     .getAllCategoryProducts(
//                                   //         categoryId: subCategoryController
//                                   //             .subCategoryList[
//                                   //                 subCategoryController
//                                   //                     .subCategoryIndex.value]
//                                   //             .id,
//                                   //         page: page,
//                                   //         searchKey: searchKey,
//                                   //         index: subCategoryController
//                                   //             .subCategoryIndex.value);
//                                   // subCategoryController.categoryProductId.value =
//                                   //     subCategoryController
//                                   //         .subCategoryList[subCategoryController
//                                   //             .subCategoryIndex.value]
//                                   //         .id;
//                                   // print(
//                                   //     "All Part set index ${subCategoryController.subCategoryIndex.value}");
//                                   //
//                                   // print(
//                                   //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
//                                 } catch (e) {
//                                   // Handle errors (e.g., show an error message)
//                                   debugPrint("Error fetching products: $e");
//                                 } finally {
//                                   subCategoryController.isLoading.value = false;
//                                 }
//                               },
//                             ),
//                           ),
//                           Row(
//                             children: List.generate(
//                               subCategoryController.subChildCategories.length,
//                               growable: true,
//                               (index) => Obx(
//                                 () => InkWell(
//                                   child: Container(
//                                     height: 35.h,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: subCategoryController
//                                                         .subSelectedIndex
//                                                         .value ==
//                                                     index &&
//                                                 subCategoryController
//                                                         .showAllProducts
//                                                         .value ==
//                                                     false
//                                             ? Colors.green
//                                             : Colors.transparent,
//                                         border: Border.all(
//                                             color: subCategoryController
//                                                             .subSelectedIndex
//                                                             .value ==
//                                                         index &&
//                                                     subCategoryController
//                                                             .showAllProducts
//                                                             .value ==
//                                                         false
//                                                 ? Colors.black
//                                                 : MyTheme.green)),
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10),
//                                     child: Center(
//                                       child: Text(
//                                         subCategoryController
//                                             .subChildCategories[index].name!,
//                                         style: TextStyle(
//                                             color: subCategoryController
//                                                             .subSelectedIndex
//                                                             .value ==
//                                                         index &&
//                                                     subCategoryController
//                                                             .showAllProducts
//                                                             .value ==
//                                                         false
//                                                 ? Colors.black
//                                                 : MyTheme.green),
//                                       ),
//                                     ),
//                                   ),
//                                   onTap: () async {
//                                     setState(() {
//                                       pageSub = 1;
//                                     });
//                                     // print("Calling");
//                                     subCategoryController
//                                         .showAllProducts.value = false;
//                                     subCategoryController
//                                         .subSelectedIndex.value = index;
//                                     subCategoryController.isInitial.value =
//                                         true;
//                                     subCategoryController
//                                             .subChildCategoryId.value =
//                                         subCategoryController
//                                             .subChildCategories[index].id!;
//                                     print(
//                                         "Show All Products========>${subCategoryController.showAllProducts.value}");
//                                     print(
//                                         "Show selected ID==========>${subCategoryController.subChildCategoryId.value} ${subCategoryController.subChildCategories[index].id!}");
//                                     // subCategoryController.categoryProductList.clear();
//                                     // subCategoryController.isLoading.value = true;
//                                     // print(
//                                     //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
//                                     // print(
//                                     //     "subChildCategory Value ${subCategoryController.categoryProductList[index].name}");
//
//                                     await subCategoryController
//                                         .getCategoryProducts(
//                                             categoryId: subCategoryController
//                                                 .subChildCategories[index].id!,
//                                             page: pageSub,
//                                             searchKey: searchKey,
//                                             index: index);
//                                     // print(
//                                     //     "Passing Ids =====>${subCategoryController.subChildCategories[index].id}");
//                                     // print(
//                                     //     "subcategory product length =======>${subCategoryController.categoryProductList.length}");
//                                     // print(subCategoryController
//                                     //     .categoryProductList.isEmpty);
//                                     // print(
//                                     //     "subChildCategory Value ${subCategoryController.categoryProductList[index].name}");
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 })
//               : SizedBox(),
//           Expanded(
//             child: Stack(
//               children: [
//                 buildProductList(),
//                 // Align(
//                 //     alignment: Alignment.bottomCenter,
//                 //     child: buildLoadingContainer())
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Container buildLoadingContainer() {
//     return Container(
//       height: subCategoryController.showLoadingContainer.value ? 10.h : 0,
//       width: double.infinity,
//       color: MyTheme.white,
//       child: Center(
//         child: subCategoryController.showAllProducts.value == true
//             ? Obx(
//                 () => Text(
//                   subCategoryController.totalData.value ==
//                           0
//                       ? AppLocalizations.of(context)!.no_more_products_ucf
//                       : AppLocalizations.of(context)!.loading_more_products_ucf,
//                 ),
//               )
//             : Obx(
//                 () => Text(
//                   subCategoryController.totalData.value ==
//                           0
//                       ? AppLocalizations.of(context)!.no_more_products_ucf
//                       : AppLocalizations.of(context)!.loading_more_products_ucf,
//                 ),
//               ),
//       ),
//     );
//   }
//
//   buildProductList() {
//     return GetBuilder<SubCategoryController>(
//       builder: (subCategoryController) {
//         return SizedBox(
//           // height: Get.height / 1.259,
//           height: 900.h,
//           child: Obx(
//             //THERE TWO DIFFERENT LIST ONE IS (ALL) OTHER IS (SUBCHILD) WILL FETCH BASED ON CONDITION
//             () {
//               if (subCategoryController.isInitial.value &&
//                   subCategoryController.allCategoryProductList.isEmpty) {
//                 return SingleChildScrollView(
//                   child: ShimmerHelper().buildListShimmer(),
//                 );
//               } else if (subCategoryController.categoryProductList.length > 0 ||
//                   subCategoryController.allCategoryProductList.length > 0) {
//                 return SingleChildScrollView(
//                   controller: xcrollController,
//                   physics: const BouncingScrollPhysics(
//                       parent: AlwaysScrollableScrollPhysics()),
//                   child: ListView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     // physics: const BouncingScrollPhysics(
//                     //     parent: AlwaysScrollableScrollPhysics()),
//                     // controller: xcrollController,
//                     shrinkWrap: true,
//                     itemCount: subCategoryController.showAllProducts.value ==
//                             true
//                         ? subCategoryController.allCategoryProductList.length
//                         : subCategoryController.categoryProductList.length,
//                     itemBuilder: (context, index) {
//                       return Obx(
//                         () => ProductCategoryCardLarge(
//                           product:
//                               subCategoryController.showAllProducts.value ==
//                                       true
//                                   ? subCategoryController
//                                       .allCategoryProductList[index]
//                                   : subCategoryController
//                                       .categoryProductList[index],
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               } else if (subCategoryController.totalData.value == 0) {
//                 return Center(
//                   child: Text(
//                       AppLocalizations.of(context)!.no_product_is_available),
//                 );
//               } else if (page > 1 &&
//                   subCategoryController.allCategoryProductList.isEmpty && subCategoryController.showAllProducts.value == true) {
//                 return Center(
//                   child:
//                       Text(AppLocalizations.of(context)!.no_data_is_available),
//                 );
//               } else if (pageSub > 1 &&
//                   subCategoryController.categoryProductList.isEmpty && subCategoryController.showAllProducts.value == false) {
//                 return Center(
//                   child:
//                       Text(AppLocalizations.of(context)!.no_data_is_available),
//                 );
//               } else {
//                 return SingleChildScrollView(
//                     child: ShimmerHelper().buildListShimmer());
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildAppBarTitle(BuildContext context) {
//     return AnimatedCrossFade(
//         firstChild: buildAppBarTitleOption(context),
//         secondChild: buildAppBarSearchOption(context),
//         firstCurve: Curves.fastOutSlowIn,
//         secondCurve: Curves.fastOutSlowIn,
//         crossFadeState: showSearchBar
//             ? CrossFadeState.showSecond
//             : CrossFadeState.showFirst,
//         duration: const Duration(milliseconds: 500));
//   }
//
//   Container buildAppBarTitleOption(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 20,
//             child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: Icon(
//                     app_language_rtl.$!
//                         ? CupertinoIcons.arrow_right
//                         : CupertinoIcons.arrow_left,
//                     color: MyTheme.black),
//                 onPressed: () {
//                   // clearAll();
//                   Get.back();
//                 }),
//             // child: UsefulElements.backButton(context, color: "white"),
//           ),
//           Container(
//             padding: const EdgeInsets.only(left: 15),
//             width: DeviceInfo(context).width! / 2,
//             child: Text(
//               widget.categoryName!,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const Spacer(),
//           SizedBox(
//             width: 20,
//             child: IconButton(
//                 onPressed: () {
//                   showSearchBar = true;
//                   setState(() {});
//                 },
//                 padding: EdgeInsets.zero,
//                 icon: const Icon(
//                   Icons.search,
//                   size: 25,
//                 )),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           InkWell(
//             onTap: () {
//               Get.to(() => CartPage(
//                     has_bottomnav: false,
//                     from_navigation: false,
//                   ));
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               child: badges.Badge(
//                   badgeStyle: badges.BadgeStyle(
//                     shape: badges.BadgeShape.circle,
//                     badgeColor: MyTheme.accent_color,
//                     borderRadius: BorderRadius.circular(10),
//                     padding: const EdgeInsets.all(5),
//                   ),
//                   badgeAnimation: const badges.BadgeAnimation.slide(
//                     toAnimate: false,
//                   ),
//                   child: Image.asset(
//                     ImageDirectory.cartIconImage,
//                     color: MyTheme.black,
//                     height: 16,
//                   ),
//                   badgeContent: GetBuilder<CartController>(
//                     builder: (cartController) {
//                       return Text(
//                         "${cartController.cartCounter}",
//                         style: TextStyle(fontSize: 10, color: Colors.white),
//                       );
//                     },
//                   )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Container buildAppBarSearchOption(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       width: DeviceInfo(context).width,
//       height: 40,
//       child: TextField(
//         controller: searchController,
//         onTap: () {},
//         onChanged: (txt) {
//           searchKey = txt;
//           clearAll();
//           // getAll();
//           subCategoryController.getCategoryProducts(
//               categoryId: widget.categoryId, page: page, searchKey: searchKey);
//         },
//         onSubmitted: (txt) {
//           searchKey = txt;
//           clearAll();
//           // getAll();
//           subCategoryController.getCategoryProducts(
//               categoryId: widget.categoryId,
//               page: pageSub,
//               searchKey: searchKey);
//         },
//         autofocus: false,
//         decoration: InputDecoration(
//           suffixIcon: IconButton(
//             onPressed: () {
//               showSearchBar = false;
//               setState(() {});
//             },
//             icon: const Icon(
//               Icons.clear,
//               color: MyTheme.grey_153,
//             ),
//           ),
//           filled: true,
//           fillColor: MyTheme.white.withOpacity(0.6),
//           hintText:
//               "${AppLocalizations.of(context)!.search_products_from} : ${widget.categoryName!}",
//           hintStyle: const TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
//           enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
//               borderRadius: BorderRadius.circular(6)),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
//               borderRadius: BorderRadius.circular(6)),
//           contentPadding: const EdgeInsets.all(8.0),
//         ),
//       ),
//     );
//   }
//
//   getAll() {
//     setState(() {
//       subCategoryController.getMainCategories(widget.categoryId);
//       subCategoryController.getAllCategoryProducts(
//           categoryId: widget.subCategoryId, page: page, searchKey: searchKey);
//       subCategoryController.getCategoryProducts(
//           categoryId: widget.subCategoryId,
//           page: pageSub,
//           searchKey: searchKey);
//       subCategoryController.getSubCategory(widget.categoryId!);
//       subCategoryController.getSubChildCategories(widget.subCategoryId!);
//       subCategoryController.subCategoryIndexSelection(widget.subCategoryId);
//       subCategoryController.showAllProducts.value = true;
//     });
//     // subCategoryIndexSelection();
//     // assignSelectedIndexes(index: 0);
//   }
//
//   clearAll() {
//     subCategoryController.subChildCategories.clear();
//     subCategoryController.categoryProductList.clear();
//     subCategoryController.subCategoryList.clear();
//     subCategoryController.mainCategoryList.clear();
//     subCategoryController.allCategoryProductList.clear();
//     widget.categoryId = 0;
//     widget.categoryName = "";
//     widget.subCategoryId = 0;
//     widget.selectedIndexes = 0;
//     subCategoryController.isInitial.value = true;
//     subCategoryController.totalData.value = 0;
//     page = 1;
//     pageSub = 1;
//     searchKey = '';
//     subCategoryController.showLoadingContainer.value = false;
//     subCategoryController.showAllProducts.value = false;
//     subCategoryController.selectedIndex.value = 0;
//     subCategoryController.subSelectedIndex.value = 0;
//     subCategoryController.subCategoryIndex.value = 0;
//     subCategoryController.allCategoryProductId.value = 0;
//     subCategoryController.categoryProductId.value = 0;
//   }
// }
