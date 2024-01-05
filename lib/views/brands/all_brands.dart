import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import 'package:krishanthmart_new/utils/colors.dart';
import '../../utils/text_styles.dart';
import '../brand_products/brand_products.dart';
import '../mainpage/components/brand_category_card.dart';

class AllBrands extends StatelessWidget {
  const AllBrands({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.brands_ucf,
            style: TextStyles.buildAppBarTexStyle(),
          ),
          centerTitle: true,
          elevation: 0.0,
          titleSpacing: 0,
          leading: IconButton(onPressed: (){
            Get.back();
          }, icon:  Icon(Icons.arrow_back,color: MyTheme.black,),),
        ),
        body: GetBuilder<HomeController>(builder: (homeController) {
          return GridView.builder(
            primary: false,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 1.0,
                mainAxisExtent: 82.h
              // crossAxisSpacing: 4,
              // mainAxisSpacing: 4,
              // crossAxisCount: 3,
            ),
            itemCount: homeController.brandProductList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Get.to(
                          () =>
                          BrandProducts(
                            brand_name:
                            homeController.brandProductList[index].name,
                            id: homeController.brandProductList[index].id,
                          ),
                    );
                  },
                  child: BrandCategoryCard(
                      brands: homeController.brandProductList[index]));
            },
          );
        },)
    );
  }
}
