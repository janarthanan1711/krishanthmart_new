import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../models/product_response_model.dart';
import '../../repositories/product_repository.dart';
import '../../utils/colors.dart';
import '../../utils/image_directory.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../cart/cart_page.dart';
import '../home/components/product_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badges;


class TopSellingProducts extends StatefulWidget {
  const TopSellingProducts({super.key});

  @override
  _TopSellingProductsState createState() => _TopSellingProductsState();
}

class _TopSellingProductsState extends State<TopSellingProducts> {
  ScrollController? _scrollController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: MyTheme.shimmer_base,
        appBar: buildAppBar(context),
        body: buildProductList(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
          child:         InkWell(
            onTap: (){
              Get.to(()=>CartPage(has_bottomnav: false,from_navigation: false,));
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
        ),
      ],
      title: Text(
        AppLocalizations.of(context)!.top_selling_products_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: ProductRepository().getBestSellingProducts(),
        builder: (context, AsyncSnapshot<ProductMiniResponse> snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            //print("product error");
            //print(snapshot.error.toString());
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            //print(productResponse.toString());
            return SingleChildScrollView(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                itemCount: productResponse!.products!.length,
                shrinkWrap: true,
                padding:
                const EdgeInsets.only(top: 20.0, bottom: 10, left: 30, right: 30),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    product: productResponse.products![index],
                    onTap: (){
                    },
                    itemIndex: index,
                  );
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}