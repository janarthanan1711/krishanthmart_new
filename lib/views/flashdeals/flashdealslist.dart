import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/views/flashdeals/flashdealproducts.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import 'package:toast/toast.dart';
import '../../models/flash_deal_model.dart';
import '../../repositories/flashdeal_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/device_info.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/toast_component.dart';
import '../mainpage/components/box_decorations.dart';
import 'package:flutter_countdown_timer/index.dart';

class FlashDealList extends StatefulWidget {
  const FlashDealList({super.key,this.hasBottomNav = false});

  final bool hasBottomNav;

  @override
  _FlashDealListState createState() => _FlashDealListState();
}

class _FlashDealListState extends State<FlashDealList> {
  final List<CountdownTimerController> _timerControllerList = [];

  DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildFlashDealList(context),
      ),
    );
  }

  Widget buildFlashDealList(context) {
    return FutureBuilder<FlashDealResponse>(
        future: FlashDealRepository().getFlashDeals(),
        builder: (context, AsyncSnapshot<FlashDealResponse> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Network Error!"),
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            FlashDealResponse flashDealResponse = snapshot.data!;
            return SingleChildScrollView(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: flashDealResponse.flashDeals!.length,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildFlashDealListItem(flashDealResponse, index);
                },
              ),
            );
          } else {
            return buildShimmer();
          }
        });
  }

  CustomScrollView buildShimmer() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 20,
              );
            },
            itemCount: 20,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return buildFlashDealListItemShimmer();

            },
          ),
        )
      ],
    );
  }

  String timeText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  buildFlashDealListItem(FlashDealResponse flashDealResponse, index) {
    DateTime end = convertTimeStampToDateTime(
        flashDealResponse.flashDeals![index].date!); // YYYY-mm-dd
    DateTime now = DateTime.now();
    int diff = end.difference(now).inMilliseconds;
    int endTime = diff + now.millisecondsSinceEpoch;

    void onEnd() {}

    CountdownTimerController timeController =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
    _timerControllerList.add(timeController);

    return SizedBox(
      // color: MyTheme.amber,
      height: 340,
      child: CountdownTimer(
        controller: _timerControllerList[index],
        widgetBuilder: (_, CurrentRemainingTime? time) {
          return GestureDetector(
            onTap: () {
              if (time == null) {
                ToastComponent.showDialog(
                  AppLocalizations.of(context)!.flash_deal_has_ended,
                  gravity: Toast.center,
                  duration: Toast.lengthLong,
                );
              } else {
                Get.to(
                  () => FlashDealProducts(
                    flash_deal_id: flashDealResponse.flashDeals![index].id,
                    flash_deal_name: flashDealResponse.flashDeals![index].title,
                    bannerUrl: flashDealResponse.flashDeals![index].banner,
                    countdownTimerController: _timerControllerList[index],
                  ),
                );
              }
            },
            child: Container(
              width: DeviceInfo(context).width,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                buildFlashDealBanner(flashDealResponse, index),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                        width: 210,
                                        child: Text(
                                          flashDealResponse
                                                  .flashDeals![index].title ??
                                              "",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: MyTheme.golden),
                                        ),
                                      ),
                                    ),
                                    time == null
                                        ? Text(
                                            AppLocalizations.of(context)!
                                                .ended_ucf,
                                            style: const TextStyle(
                                                color: MyTheme.accent_color,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : buildTimerRowRow(time),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: List.generate(
                                flashDealResponse.flashDeals![index].products
                                        ?.products?.length ??
                                    6,
                                (productIndex) => buildFlashDealsProductItem(
                                    flashDealResponse, index, productIndex)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.view_more_ucf,
                                style: const TextStyle(
                                    fontSize: 10, color: MyTheme.grey_153),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              //Image.asset("assets/arrow.png",height: 10,color: MyTheme.grey_153,),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                size: 10,
                                color: MyTheme.grey_153,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildFlashDealListItemShimmer() {
    Container(
      width: DeviceInfo(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    buildFlashDealBannerShimmer(),
                    const SizedBox(
                      width: 10,
                    ),
                    buildTimerRowRowShimmer()
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: List.generate(
                    6,
                    (productIndex) =>
                        buildFlashDealsProductItemShimmer()),
              ),
            ),
          )
        ],
      ),
    );
    // return SizedBox(
    //   // color: MyTheme.amber,
    //   height: 340,
    //   child: Stack(
    //     children: [
    //       buildFlashDealBannerShimmer(),
    //       Positioned(
    //         bottom: 0,
    //         left: 0,
    //         right: 0,
    //         child: Container(
    //           width: DeviceInfo(context).width,
    //           height: 196,
    //           margin: const EdgeInsets.symmetric(horizontal: 18),
    //           decoration: BoxDecorations.buildBoxDecoration_1(),
    //           child: Column(
    //             children: [
    //               Container(
    //                 child: buildTimerRowRowShimmer(),
    //               ),
    //               SingleChildScrollView(
    //                 scrollDirection: Axis.horizontal,
    //                 physics: const BouncingScrollPhysics(),
    //                 child: Container(
    //                   padding: const EdgeInsets.only(top: 10),
    //                   width: 460,
    //                   child: Wrap(
    //                     //spacing: 10,
    //                     runSpacing: 10,
    //                     crossAxisAlignment: WrapCrossAlignment.center,
    //                     runAlignment: WrapAlignment.spaceBetween,
    //                     alignment: WrapAlignment.start,
    //                     children: List.generate(6, (productIndex) {
    //                       return buildFlashDealsProductItemShimmer();
    //                     }),
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget buildFlashDealsProductItem(
      flashDealResponse, flashDealIndex, productIndex) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ProductDetails(
            id: flashDealResponse
                .flashDeals[flashDealIndex].products.products[productIndex].id,
          ),
        );
      },
      child: Card(
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          height: 165,
          width: 140,
          decoration: BoxDecoration(
            color: MyTheme.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: 160,
                child: ClipRRect(
                  clipBehavior: Clip.none,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/placeholder.png"),
                    image: NetworkImage(flashDealResponse
                        .flashDeals[flashDealIndex]
                        .products
                        .products[productIndex]
                        .image),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        flashDealResponse.flashDeals[flashDealIndex].products!
                            .products[productIndex].name,
                        // convertPrice(flashDealResponse.flashDeals[flashDealIndex].products!
                        //     .products[productIndex].price),
                        style: const TextStyle(
                            fontSize: 12,
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5),
                child: Row(
                  children: [
                    Text(
                      flashDealResponse.flashDeals[flashDealIndex].products!
                          .products[productIndex].price,
                      // convertPrice(flashDealResponse.flashDeals[flashDealIndex].products!
                      //     .products[productIndex].price),
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFlashDealsProductItemShimmer() {
   return  Container(
      margin: const EdgeInsets.only(left: 10),
      height: 165,
      width: 140,
      decoration: BoxDecoration(
        color: MyTheme.shimmer_highlighted,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 110,
            width: 160,
            child: ClipRRect(
              clipBehavior: Clip.none,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
              child: ShimmerHelper().buildBasicShimmerCustomRadius(
                          height: 50,
                          width: 50,
                          radius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );

  }

  Card buildFlashDealBanner(flashDealResponse, index) {
    return Card(
      elevation: 10,
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/placeholder_rectangle.png',
        image: flashDealResponse.flashDeals[index].banner,
        fit: BoxFit.cover,
        width: 140,
        height: 140,
      ),
    );
  }

  Widget buildFlashDealBannerShimmer() {
    return ShimmerHelper().buildBasicShimmerCustomRadius(
      width: 140,
      height: 140,
      color: MyTheme.medium_grey_50,
    );
  }

  Widget buildTimerRowRow(CurrentRemainingTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          timerContainer(
            Text(
              timeText(time.days.toString(), default_length: 3),
              style: const TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          timerContainer(
            Text(
              timeText(time.hours.toString(), default_length: 2),
              style: const TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          timerContainer(
            Text(
              timeText(time.min.toString(), default_length: 2),
              style: const TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          timerContainer(
            Text(
              timeText(time.sec.toString(), default_length: 2),
              style: const TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimerRowRowShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          timerContainer(
            ShimmerHelper().buildBasicShimmerCustomRadius(
                height: 20,
                width: 20,
                radius: BorderRadius.circular(6),
                color: MyTheme.shimmer_base),
          ),
          const SizedBox(
            width: 4,
          ),
          ShimmerHelper().buildBasicShimmerCustomRadius(
              height: 20,
              width: 20,
              radius: BorderRadius.circular(6),
              color: MyTheme.shimmer_base),
          const SizedBox(
            width: 4,
          ),
          ShimmerHelper().buildBasicShimmerCustomRadius(
              height: 20,
              width: 20,
              radius: BorderRadius.circular(6),
              color: MyTheme.shimmer_base),
          const SizedBox(
            width: 4,
          ),
          ShimmerHelper().buildBasicShimmerCustomRadius(
              height: 20,
              width: 20,
              radius: BorderRadius.circular(6),
              color: MyTheme.shimmer_base),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
    );
  }

  Widget timerContainer(Widget child) {
    return Container(
      constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: MyTheme.accent_color,
      ),
      child: child,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context)!.flash_deals_ucf,
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
