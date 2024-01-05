import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishanthmart_new/helpers/main_helpers.dart';
import 'package:krishanthmart_new/models/wishlist_response_model.dart';
import 'package:toast/toast.dart';
import '../../repositories/wishlist_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/toast_component.dart';
import '../../utils/useful_elements.dart';
import '../product_details/product_details.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  ScrollController _mainScrollController = ScrollController();

  //init
  bool _wishlistInit = true;
  List<dynamic> _wishlistItems = [];

  @override
  void initState() {
    if (is_logged_in.$ == true) {
      fetchWishlistItems();
    }

    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  fetchWishlistItems() async {
    var wishlistResponse = await WishListRepository().getUserWishlist();
    _wishlistItems.addAll(wishlistResponse.wishlist_items);
    _wishlistInit = false;
    setState(() {});
  }

  reset() {
    _wishlistInit = true;
    _wishlistItems.clear();
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchWishlistItems();
  }

  Future<void> _onPressRemove(index) async {
    var wishlist_id = _wishlistItems[index].id;
    _wishlistItems.removeAt(index);
    setState(() {});

    var wishlistDeleteResponse =
        await WishListRepository().delete(wishlist_id: wishlist_id);

    if (wishlistDeleteResponse.result == true) {
      ToastComponent.showDialog(wishlistDeleteResponse.message,
          gravity: Toast.top, duration: Toast.lengthShort);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: MyTheme.shimmer_highlighted,
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  buildWishlist(),
                ])),
              ],
            ),
          )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: UsefulElements.backButton(context),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.my_wishlist_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildWishlist() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.you_need_to_log_in,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_wishlistInit == true && _wishlistItems.length == 0) {
      return SingleChildScrollView(
        child: ShimmerHelper().buildListShimmer(item_count: 10),
      );
    } else if (_wishlistItems.length > 0) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 10, right: 10),
          shrinkWrap: true,
          itemCount: _wishlistItems.length,
          itemBuilder: (context, index) {
            return buildWishListItem(index);
          });


      /*
        ListView.builder(
          itemCount: _wishlistItems.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: buildWishListItem(index),
            );
          },
        ),*/
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(AppLocalizations.of(context)!.no_item_is_available,
                  style: TextStyle(color: MyTheme.font_grey))));
    }
  }

  buildWishListItem(index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: _wishlistItems[index].product.id,
          );
        }));
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 90.w,
                      height: 100.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(16), right: Radius.zero),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image:
                                _wishlistItems[index].product.thumbnail_image,
                            fit: BoxFit.cover,
                          ))),
                  Container(
                    width: 230.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(
                            _wishlistItems[index].product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 16.sp,
                                height: 1.6,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                          child: Text(
                            convertPrice(_wishlistItems[index].product.base_price),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          app_language_rtl.$!
              ? Positioned(
                  bottom: 8,
                  left: 12,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever_outlined,
                        color: MyTheme.medium_grey),
                    onPressed: () {
                      _onPressRemove(index);
                    },
                  ),
                )
              : Positioned(
                  bottom: 8,
                  right: 12,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever_outlined,
                        color: MyTheme.medium_grey),
                    onPressed: () {
                      _onPressRemove(index);
                    },
                  ),
                ),
        ],
      ),
    );
  }

}
