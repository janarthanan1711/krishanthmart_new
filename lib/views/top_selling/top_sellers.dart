import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/shop_response_model.dart';
import '../../repositories/shop_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/useful_elements.dart';
import 'components/shop_square_card.dart';

class TopSellers extends StatefulWidget {
  const TopSellers({super.key});

  @override
  State<TopSellers> createState() => _TopSellersState();
}

class _TopSellersState extends State<TopSellers> {
  ScrollController? _scrollController;
  List<Shop> topSellers = [];
  bool isInit = false;

  getTopSellers() async {
    ShopResponse response = await ShopRepository().topSellers();
    isInit = true;
    if (response.shops != null) {
      topSellers.addAll(response.shops!);
    }

    setState(() {});
  }

  clearAll() {
    isInit = false;
    topSellers.clear();
    setState(() {});
  }

  Future<void> onRefresh() async {
    clearAll();
    return await getTopSellers();
  }

  @override
  void initState() {
    // TODO: implement initState
    getTopSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.shimmer_base,
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: buildTopSellerList(context)),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // centerTitle: true,
      leading: UsefulElements.backButton(context),
      title: Text(
       AppLocalizations.of(context)!.top_sellers_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildTopSellerList(context) {
    if (isInit) {
      //print(productResponse.toString());
      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: topSellers.length,
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.7),
        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 18, right: 18),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ShopSquareCard(
            id: topSellers[index].id,
            image: topSellers[index].logo,
            name: topSellers[index].name,
            stars: double.parse(topSellers[index].rating.toString()),
          );
        },
      );
    } else {
      return ShimmerHelper()
          .buildSquareGridShimmer(scontroller: _scrollController);
    }
  }
}
