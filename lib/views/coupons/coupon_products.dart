import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/product_response_model.dart';
import '../../repositories/coupon_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/toast_component.dart';
import '../home/components/product_card.dart';

class CouponProducts extends StatefulWidget {
  final String? code;
  final int? id;

  const CouponProducts({
    Key? key,
    this.code,
    this.id,
  }) : super(key: key);

  @override
  State<CouponProducts> createState() => _CouponProductsState();
}

class _CouponProductsState extends State<CouponProducts> {
  ScrollController? _scrollController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context, widget.code),
        body: buildCouponProductList(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, code) {
    return AppBar(
      backgroundColor: Colors.white,
      // centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              code,
              style: TextStyle(
                  fontSize: 16,
                  color: MyTheme.dark_font_grey,
                  fontWeight: FontWeight.bold),
            ),
            // code copy
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code)).then((_) {
                  ToastComponent.showDialog(
                      AppLocalizations.of(context)!.copied_ucf,
                      gravity: Toast.center,
                      duration: 1);
                });
              },
              icon: const Icon(
                color: Colors.black,
                Icons.copy,
                size: 18.0,
              ),
            )
          ],
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCouponProductList(context) {
    return FutureBuilder(
        future: CouponRepository().getCouponProductList(id: widget.id),
        builder: (context, AsyncSnapshot<ProductMiniResponse> snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            return SingleChildScrollView(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                itemCount: productResponse!.products!.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 10, left: 18, right: 18),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    product: productResponse.products![index],
                    onTap: () {},
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
