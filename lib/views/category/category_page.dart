import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/category_controller.dart';
import 'package:krishanthmart_new/views/category/sub_category_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/category_model.dart';
import '../../repositories/category_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/device_info.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/useful_elements.dart';
import '../mainpage/components/box_decorations.dart';

class BottomAppbarIndex {
  int currentIndex = 0;

  setter(index) => currentIndex = index;

  get getter => currentIndex;
}

class CategoryListPages extends StatefulWidget {
  CategoryListPages(
      {Key? key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex,
      this.is_viewMore = false,
      this.category_id = 0})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final bool is_viewMore;
  final BottomAppbarIndex? bottomAppbarIndex;
  final int category_id;

  @override
  _CategoryListPagesState createState() => _CategoryListPagesState();
}

class _CategoryListPagesState extends State<CategoryListPages> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // categoryController.getCategories(widget.parent_category_id);
    gettingCategoryName();
    print(
        "main Category Names ==========> ${categoryController.mainCategoryNames.value}");
    print("category ids========>${widget.category_id}");
    print(widget.is_viewMore);
    print(widget.parent_category_id);
  }

  @override
  void dispose() {
    super.dispose();
    categoryController.categoryList!.clear();
    Future.delayed(const Duration(seconds: 1), () {
      categoryController.assignCategoryNames(0);
      categoryController
          .getChildSubCategories(categoryController.categoryList![0].id!);
      // categoryController.mainCategoryId.value = 0;
    });
  }

  gettingCategoryName() async {
    if (widget.is_viewMore == true) {
      await categoryController.fetchFeaturedCategories();
      categoryController.assignCategoryNames(0);
      await categoryController.getChildSubCategories(4);
    } else {
      categoryController.mainCategoryNames.value = widget.parent_category_name;
      categoryController.mainCategoryId.value = widget.category_id;
      await categoryController.getChildSubCategories(widget.category_id);
    }
  }

  int selectedIndex = 0;
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size(
            DeviceInfo(context).width!,
            50,
          ),
          child: buildAppBar(context),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return buildCategoryList();
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) => widget.is_base_category == false
            ? UsefulElements.backToMain(context, go_back: true)
            : UsefulElements.backButton(context),
      ),
      title: Text(
        AppLocalizations.of(context)!.categories_ucf,
        style: TextStyle(
            fontSize: 25, color: MyTheme.black, fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCategoryList() {
    var data = CategoryRepository().getFeaturedCategories();
    // var data = CategoryRepository()
    //     .getCategories(parent_id: widget.parent_category_id);
    return FutureBuilder(
        future: data,
        builder: (context, AsyncSnapshot<CategoryResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(child: buildShimmer());
          }
          if (snapshot.hasError) {
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            return Row(
              children: [
                SizedBox(
                  height: 710.h,
                  width: 115.w,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(bottom: 75),
                    itemCount: snapshot.data!.categories!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () async {
                            await categoryController.getChildSubCategories(
                                snapshot.data!.categories![index].id!);
                            if (widget.is_viewMore == true) {
                              categoryController.mainCategoryId.value =
                                  snapshot.data!.categories![index].id!;
                            }
                            widget.is_viewMore == true
                                ? categoryController.mainCategoryNames.value =
                                    snapshot.data!.categories![index].name!
                                : categoryController.assignCategoryNames(index);
                          },
                          child: buildCategoryItemCard(snapshot.data, index));
                    },
                  ),
                ),
                Container(
                  width: 1,
                  height: 750.h,
                  color: MyTheme.medium_grey,
                  margin: const EdgeInsets.only(left: 2, right: 5),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25.h,
                      ),
                      GetBuilder<CategoryController>(
                        builder: (categoryControllers) => Row(
                          children: List<Widget>.generate(
                            1,
                            (index) => Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: MyTheme.green),
                              ),
                              child: Text(
                                categoryControllers.mainCategoryNames.value,
                                style: TextStyle(
                                    color: MyTheme.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: DeviceInfo(context).height,
                        width: DeviceInfo(context).width! / 1.6,
                        child: Obx(
                          () => categoryController.subChildCategories.length ==
                                  0
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 210.h, left: 70.w),
                                  child: Text(AppLocalizations.of(context)!
                                      .no_category_found),
                                )
                              : GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: categoryController
                                      .subChildCategories.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: Card(
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(8.0)),
                                              child: Image.network(
                                                categoryController
                                                    .subChildCategories[index]
                                                    .banner,
                                                // height: 64.0,
                                                height: 85,
                                                width: double.maxFinite,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              categoryController
                                                  .subChildCategories[index]
                                                  .name,
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => SubCategoryPage(
                                            categoryId: categoryController
                                                .mainCategoryId.value,
                                            categoryName: categoryController
                                                .mainCategoryNames.value,
                                            subCategoryId: categoryController
                                                .subChildCategories[index].id,
                                            selectedIndexes: index,
                                            from_banner: false,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return SingleChildScrollView(child: buildShimmer());
          }
        });
  }

  Widget buildCategoryItemCard(categoryResponse, index) {
    return Row(
      children: [
        Container(
          width: 120,
          color: MyTheme.PrimaryLightColor,
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
                  child: Image.network(
                    categoryResponse.categories[index].banner,
                    height: 100,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      categoryResponse.categories[index].name,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildShimmer() {
    return Row(
      children: [
        SizedBox(
          height: DeviceInfo(context).height,
          width: 125,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child:
                    ShimmerHelper().buildBasicShimmer(height: 140, width: 50),
              );
            },
          ),
        ),
        Container(
          width: 1,
          height: DeviceInfo(context).height,
          color: MyTheme.medium_grey,
          margin: const EdgeInsets.only(left: 2, right: 5),
        ),
        Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: DeviceInfo(context).height,
              width: DeviceInfo(context).width! / 1.6,
              child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecorations.buildBoxDecoration_1(),
                      child: ShimmerHelper()
                          .buildBasicShimmer(height: 50, width: 50),
                    );
                  }),
            ),
          ],
        )
      ],
    );
  }
}
