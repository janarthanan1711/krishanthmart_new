import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import '../../models/product_response_model.dart';
import '../../repositories/product_repository.dart';
import '../../utils/colors.dart';
import '../../utils/reg_ex_input_formatters.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/useful_elements.dart';
import '../home/components/product_card.dart';

class AllProducts extends StatefulWidget {
  AllProducts(
      {Key? key,
      this.selected_filter = "product",
      this.selected_products = "product"})
      : super(key: key);

  final String selected_filter;
  final String selected_products;

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  ScrollController _productScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final HomeController controller = Get.find();

  ScrollController? _scrollController;
  String? _selectedSort = "";

  List<dynamic> _searchSuggestionList = [];

  String? _searchKey = "";

  List<Product> _productList = [];
  bool _isProductInitial = true;
  int _productPage = 1;
  int? _totalProductData = 0;
  bool _showProductLoadingContainer = false;

  //----------------------------------------

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _productScrollController.dispose();
    super.dispose();
  }

  init() {
    fetchProductData();
    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchProductData();
      }
    });
  }

  fetchProductData() async {
    //print("sc:"+_selectedCategories.join(",").toString());
    //print("sb:"+_selectedBrands.join(",").toString());
    var productResponse =
        await ProductRepository().getAllProducts(page: _productPage);

    _productList.addAll(productResponse.products!);
    _isProductInitial = false;
    _totalProductData = productResponse.meta!.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  resetProductList() {
    _productList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _searchSuggestionList.clear();
    setState(() {});
  }

  Future<void> _onProductListRefresh() async {
    reset();
    resetProductList();
    fetchProductData();
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _productList.length
            ? AppLocalizations.of(context)!.no_more_products_ucf
            : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyTheme.shimmer_highlighted,
        body: Stack(fit: StackFit.loose, children: [
          buildProductList(),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: buildAppBar(context),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: buildProductLoadingContainer())
        ]),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.95),
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: UsefulElements.backButton(context),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.selected_products == 'best_selling'
            ? AppLocalizations.of(context)!.best_selling_ucf
            : widget.selected_products == 'best_deals'
                ? AppLocalizations.of(context)!.best_deals
                : widget.selected_products == 'featured_products'
                    ? AppLocalizations.of(context)!.featured_products_ucf
                    : widget.selected_products == "todays_offer"
                        ? AppLocalizations.of(context)!.todays_deal_ucf
                        : AppLocalizations.of(context)!.all_products_ucf,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.sp, color: MyTheme.black),
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

  buildProductScrollableList() {
    if (_isProductInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onProductListRefresh,
        child: SingleChildScrollView(
          controller: _productScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(height: 75.h),
              MasonryGridView.count(
                itemCount: widget.selected_products == "best_selling"
                    ? controller.bestSellingProductList.length
                    : widget.selected_products == "best_deals" ||
                            widget.selected_products == "todays_offer"
                        ? controller.todayDealList.length
                        : widget.selected_products == 'featured_products'
                            ? controller.featuredProductList.length
                            : _productList.length,
                controller: _scrollController,
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                padding:
                    EdgeInsets.only(top: 10.0, bottom: 10, left: 31, right: 31),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ProductCard(
                    itemIndex: index,
                    product: widget.selected_products == "best_selling"
                        ? controller.bestSellingProductList[index]
                        : widget.selected_products == 'best_deals' ||
                                widget.selected_products == "todays_offer"
                            ? controller.todayDealList[index]
                            : widget.selected_products == "featured_products"
                                ? controller.featuredProductList[index]
                                : _productList[index],
                    onTap: () {},
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalProductData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
}
