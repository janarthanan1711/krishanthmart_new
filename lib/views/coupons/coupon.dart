import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/utils/app_config.dart';
import 'package:krishanthmart_new/views/coupons/coupon_products.dart';
import 'package:toast/toast.dart';
import '../../helpers/main_helpers.dart';
import '../../repositories/coupon_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/device_info.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/toast_component.dart';
import '../../utils/useful_elements.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  ScrollController _xcrollController = ScrollController();

  //init
  bool _dataFetch = false;
  List<dynamic> _couponsList = [];
  int _page = 1;
  int? _totalData = 0;
  bool _showLoadingContainer = false;

  _selectGradient(index) {
    if (index == 0 || (index + 1 > 3 && ((index + 1) % 3) == 1)) {
      return MyTheme.buildLinearGradient1();
    } else if (index == 1 || (index + 1 > 3 && ((index + 1) % 3) == 2)) {
      return MyTheme.buildLinearGradient2();
    } else if (index == 2 || (index + 1 > 3 && ((index + 1) % 3) == 0)) {
      return MyTheme.buildLinearGradient3();
    }
  }

  fetchData() async {
    var couponRes = await CouponRepository().getCouponResponseList(page: _page);
    _couponsList.addAll(couponRes.data);
    // _totalData = couponRes.meta?.total;
    _dataFetch = true;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _dataFetch = false;
    _couponsList.clear();
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchData();
  }

  @override
  void initState() {
    fetchData();
    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
          _showLoadingContainer = true;
        });
        fetchData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // _mainScrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: MyTheme.shimmer_highlighted,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            body(),
            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ),
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _couponsList.length
            ? AppLocalizations.of(context)!.no_more_coupons_ucf
            : AppLocalizations.of(context)!.loading_coupons_ucf),
      ),
    );
  }

  Widget body() {
    if (!_dataFetch) {
      return ShimmerHelper().buildListShimmer();
    }

    if (_couponsList.length == 0) {
      return Center(
        child: Text(AppLocalizations.of(context)!.no_data_is_available),
      );
    }
    return RefreshIndicator(
      onRefresh: _onPageRefresh,
      child: SingleChildScrollView(
        controller: _xcrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.separated(
          itemCount: _couponsList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => itemSpacer(),
          itemBuilder: (context, index) {
            return Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Material(
                  elevation: 8,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _selectGradient(index),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 30, bottom: 12.4),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppConfig.app_name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            itemSpacer(),
                            _couponsList[index].discountType == "percent"
                                ? Text(
                                    "${_couponsList[index].discount}% ${AppLocalizations.of(context)!.off}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    "${convertPrice(_couponsList[index].discount.toString())} ${AppLocalizations.of(context)!.off}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                        itemSpacer(height: DeviceInfo(context).width! / 16),
                        // MySeparator(color: Colors.white),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: _couponsList[index]
                                          .details !=
                                      null
                                  ? richText(context, index)
                                  : GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => CouponProducts(
                                              code: _couponsList[index].code!,
                                              id: _couponsList[index].id!),
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .view_products_ucf,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            ),
                            itemSpacer(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.code}: ${_couponsList[index].code}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                            text: _couponsList[index].code!))
                                        .then((_) {
                                      ToastComponent.showDialog(
                                          AppLocalizations.of(context)!
                                              .copied_ucf,
                                          gravity: Toast.center,
                                          duration: 1);
                                    });
                                  },
                                  icon: const Icon(
                                    color: Colors.white,
                                    Icons.copy,
                                    size: 18.0,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  RichText richText(BuildContext context, int index) {
    return RichText(
      text: TextSpan(
        text: '${AppLocalizations.of(context)!.min_spend_ucf} ',
        style: const TextStyle(
          fontSize: 12,
        ),
        children: [
          TextSpan(
            text:
                '${convertPrice(_couponsList[index].details!)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: ' ${AppLocalizations.of(context)!.from}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: ' Krishanthmart',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: ' ${AppLocalizations.of(context)!.store_to_get}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          TextSpan(
            text:
                ' ${_couponsList[index].discountType == "percent" ? _couponsList[index].discount.toString() + "%" : convertPrice(_couponsList[index].discount.toString())}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' ${AppLocalizations.of(context)!.off_on_total_orders}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  itemSpacer({height = 15.0}) {
    return SizedBox(
      height: height,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: UsefulElements.backButton(context),
      title: Text(
        AppLocalizations.of(context)!.coupons_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
