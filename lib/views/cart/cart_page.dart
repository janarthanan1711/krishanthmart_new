import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';
import '../../repositories/cart_repositories.dart';
import '../../utils/aiz_routes.dart';
import '../../utils/btn_elements.dart';
import '../../utils/colors.dart';
import '../../utils/device_info.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/system_config.dart';
import '../../utils/text_styles.dart';
import '../../utils/toast_component.dart';
import '../../utils/useful_elements.dart';
import '../address/select_address.dart';
import '../mainpage/components/box_decorations.dart';

class CartPage extends StatefulWidget {
  CartPage(
      {Key? key,
        this.has_bottomnav = false,
        this.from_navigation = false,
        // this.counter
      })
      : super(key: key);
  final bool has_bottomnav;
  final bool from_navigation;
  // final CartController? counter;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  var _shopList = [];
  CartResponse? _shopResponse;
  bool _isInitial = true;
  var _cartTotal = 0.00;
  var _cartTotalString = ". . .";
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/

    if (is_logged_in.$ == true) {
      fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  getCartCount() {
    cartController.cartCounter.value;
    // Provider.of<CartCounter>(context, listen: false).getCount();
    // var res = await CartRepository().getCartCount();
    //  widget.counter.controller.sink.add(cartController.cartCounter.value);
  }

  fetchData() async {
    getCartCount();
    var cartResponseList =
    await CartRepository().getCartResponseList(user_id.$);
    print("grandtotal===============>${cartResponseList.grandTotal}");
    if (cartResponseList != null || cartResponseList.data!.isNotEmpty) {
      _shopList = cartResponseList.data!;
      _shopResponse = cartResponseList;
      // getSetCartTotal();
    }
    _isInitial = false;

    setState(() {});
  }

  // getSetCartTotal() {
  //   _cartTotalString = _shopResponse!.grandTotal!.replaceAll(
  //       SystemConfig.systemCurrency!.code!,
  //       SystemConfig.systemCurrency!.symbol!);
  //
  //   setState(() {});
  // }

  onQuantityIncrease(sellerIndex, itemIndex) {
    if (_shopList[sellerIndex].cartItems[itemIndex].quantity <
        _shopList[sellerIndex].cartItems[itemIndex].upperLimit) {
      _shopList[sellerIndex].cartItems[itemIndex].quantity++;
      // getSetCartTotal();
      setState(() {});
      process(mode: "update");
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context)!.cannot_order_more_than} ${_shopList[sellerIndex].cartItems[itemIndex].upperLimit} ${AppLocalizations.of(context)!.items_of_this_all_lower}",
          gravity: Toast.center,
          duration: Toast.lengthLong);
    }
  }

  onQuantityDecrease(sellerIndex, itemIndex) {
    if (_shopList[sellerIndex].cartItems[itemIndex].quantity >
        _shopList[sellerIndex].cartItems[itemIndex].lowerLimit) {
      _shopList[sellerIndex].cartItems[itemIndex].quantity--;
      // getSetCartTotal();
      setState(() {});
      process(mode: "update");
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context)!.cannot_order_more_than} ${_shopList[sellerIndex].cartItems[itemIndex].lowerLimit} ${AppLocalizations.of(context)!.items_of_this_all_lower}",
          gravity: Toast.center,
          duration: Toast.lengthLong);
    }
  }

  onPressDelete(cartId) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
          content: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              AppLocalizations.of(context)!
                  .are_you_sure_to_remove_this_item,
              maxLines: 3,
              style: const TextStyle(color: MyTheme.font_grey, fontSize: 14),
            ),
          ),
          actions: [
            Btn.basic(
              child: Text(
                AppLocalizations.of(context)!.cancel_ucf,
                style: TextStyle(color: MyTheme.medium_grey),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            Btn.basic(
              color: MyTheme.soft_accent_color,
              child: Text(
                AppLocalizations.of(context)!.confirm_ucf,
                style: TextStyle(color: MyTheme.dark_grey),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                confirmDelete(cartId);
              },
            ),
          ],
        ));
  }

  confirmDelete(cartId) async {
    var cartDeleteResponse =
    await CartRepository().getCartDeleteResponse(cartId);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      reset();
      fetchData();
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  onPressUpdate() {
    process(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }

  process({mode}) async {
    var cartIds = [];
    var cartQuantities = [];
    if (_shopList.isNotEmpty) {
      for (var shop in _shopList) {
        if (shop.cartItems.length > 0) {
          shop.cartItems.forEach((cartItem) {
            cartIds.add(cartItem.id);
            cartQuantities.add(cartItem.quantity);
          });
        }
      }
    }

    if (cartIds.isEmpty) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.cart_is_empty,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var cartIdsString = cartIds.join(',').toString();
    var cartQuantitiesString = cartQuantities.join(',').toString();

    print(cartIdsString);
    print(cartQuantitiesString);

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cartIdsString, cartQuantitiesString);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      // cart update message
      // remove on
      // ToastComponent.showDialog(cartProcessResponse.message,
      //     gravity: Toast.center, duration: Toast.lengthLong);

      if (mode == "update") {
        // reset();
        fetchData();
      } else if (mode == "proceed_to_shipping") {
        AIZRoute.push(context, SelectAddress()).then((value) {
          onPopped(value);
        });
      }
    }
  }

  reset() {
    _shopList = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: _scaffoldKey,
          //drawer: MainDrawer(),
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildCartSellerList(),
                        ),
                        // Container(
                        //   height: widget.has_bottomnav ? 140 : 100,
                        // )
                      ]),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomContainer(),
              )
            ],
          )),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: MyTheme.soft_accent_color),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppLocalizations.of(context)!.total_amount_ucf,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(_cartTotalString,
                        style: const TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 58,
                    width: (MediaQuery.of(context).size.width - 48),
                    // width: (MediaQuery.of(context).size.width - 48) * (2 / 3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                        Border.all(color: MyTheme.accent_color, width: 1),
                        borderRadius: app_language_rtl.$!
                            ? const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        )
                            : const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        )),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: MyTheme.accent_color,
                      shape: app_language_rtl.$!
                          ? const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                          ))
                          : const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                            topRight: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          )),
                      child: Text(
                        AppLocalizations.of(context)!.proceed_to_shipping_ucf,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        onPressProceedToShipping();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // leading: Builder(
      //   builder: (context) => widget.from_navigation
      //       ? UsefulElements.backToMain(context, go_back: false)
      //       : UsefulElements.backButton(context),
      // ),
      title: Text(
        AppLocalizations.of(context)!.shopping_cart_ucf,
        style: TextStyles.buildAppBarTexStyle(),
      ),
      centerTitle: true,
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCartSellerList() {
    if (is_logged_in.$ == false) {
      return SizedBox(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.please_log_in_to_see_the_cart_items,
                style: const TextStyle(color: MyTheme.font_grey),
              )));
    } else if (_isInitial && _shopList.isEmpty) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shopList.isNotEmpty) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 26,
          ),
          itemCount: _shopList.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Text(
                        _shopList[index].name,
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        _shopList[index].subTotal.replaceAll(
                            SystemConfig.systemCurrency!.code,
                            SystemConfig.systemCurrency!.symbol) ??
                            '',
                        style: const TextStyle(
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                buildCartSellerItemList(index),
              ],
            );
          },
        ),
      );
    } else if (!_isInitial && _shopList.isEmpty) {
      return SizedBox(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.cart_is_empty,
                style: const TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  SingleChildScrollView buildCartSellerItemList(sellerIndex) {
    return SingleChildScrollView(
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 14,
        ),
        itemCount: _shopList[sellerIndex].cartItems.length,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildCartSellerItemCard(sellerIndex, index);
        },
      ),
    );
  }

  buildCartSellerItemCard(sellerIndex, itemIndex) {
    return Container(
      height: 120,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
                width: DeviceInfo(context).width! / 4,
                height: 120,
                child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(6), right: Radius.zero),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: _shopList[sellerIndex]
                          .cartItems[itemIndex]
                          .productThumbnailImage,
                      fit: BoxFit.cover,
                    ))),
            SizedBox(
              //color: Colors.red,
              width: DeviceInfo(context).width! / 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _shopList[sellerIndex].cartItems[itemIndex].productName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 23.0),
                      child: Row(
                        children: [
                          Text(
                            SystemConfig.systemCurrency != null
                                ? _shopList[sellerIndex]
                                .cartItems[itemIndex]
                                .price
                                .replaceAll(
                                SystemConfig.systemCurrency!.code,
                                SystemConfig.systemCurrency!.symbol)
                                : _shopList[sellerIndex]
                                .cart_items[itemIndex]
                                .price,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      onPressDelete(
                          _shopList[sellerIndex].cartItems[itemIndex].id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Image.asset(
                        'assets/trash.png',
                        height: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_shopList[sellerIndex]
                          .cartItems[itemIndex]
                          .auctionProduct ==
                          0) {
                        onQuantityIncrease(sellerIndex, itemIndex);
                      }
                      return null;
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration:
                      BoxDecorations.buildCartCircularButtonDecoration(),
                      child: Icon(
                        Icons.add,
                        color: _shopList[sellerIndex]
                            .cartItems[itemIndex]
                            .auctionProduct ==
                            0
                            ? MyTheme.accent_color
                            : MyTheme.grey_153,
                        size: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      _shopList[sellerIndex]
                          .cartItems[itemIndex]
                          .quantity
                          .toString(),
                      style:
                      const TextStyle(color: MyTheme.accent_color, fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_shopList[sellerIndex]
                          .cartItems[itemIndex]
                          .auctionProduct ==
                          0) {
                        onQuantityDecrease(sellerIndex, itemIndex);
                      }
                      return null;
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration:
                      BoxDecorations.buildCartCircularButtonDecoration(),
                      child: Icon(
                        Icons.remove,
                        color: _shopList[sellerIndex]
                            .cartItems[itemIndex]
                            .auctionProduct ==
                            0
                            ? MyTheme.accent_color
                            : MyTheme.grey_153,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}

